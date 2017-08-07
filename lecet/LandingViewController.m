//
//  LandingViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/20/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "LandingViewController.h"
#import "IntroViewController.h"

#import "LoginViewController.h"
#import "DashboardViewController.h"
#import <DataManagerSDK/TouchIDManager.h>

@interface LandingViewController ()<LoginDelegate, DashboardViewControllerDelegate,IntroViewControllerDelegate>{
    BOOL isLogin;
    BOOL showLoginDirect;
}
@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LAUNCHSCREEN"];
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    controller.view.frame = self.view.frame;
    [self.view addSubview:controller.view];

    NSString *isLoginPersisted = [[DataManager sharedManager] getKeyChainValue:kKeychainAccessToken serviceName:kKeychainServiceName];
    if (isLoginPersisted != nil & isLoginPersisted.length>0) {

        isLogin = YES;
        
        [self showIntroductionViewCOntrollerShow:^(id obj){
            showLoginDirect = NO;
            [self showIntroduction];
        } dontShow:^(id obj) {
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoLogin) userInfo:nil repeats:NO];
        }];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUnAuthorized:) name:NOTIFICATION_UNAUTHORIZED object:nil];
}

- (void)autoLogin {
    [self login];
}

- (void)presentLogin {

    if (!isLogin) {
        isLogin = YES;
        if (![[DataManager sharedManager] shouldLoginUsingTouchId]) {

            showLoginDirect = YES;
            [self showIntroductionViewCOntrollerShow:^(id object){
                [self showIntroduction];
            } dontShow:^(id obj){
                [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(showLogin) userInfo:nil repeats:NO];
            }];
        
        } else {
            //showLoginDirect = NO;
            [self login];
        }
    }

}

- (void)notificationUnAuthorized:(NSNotification*)notification {
    [self logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentLogin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutSubviews];
}

- (void)showLogin {
    LoginViewController *controller = [LoginViewController new];
    controller.loginDelegate = self;
    [self presentViewController:controller animated:NO completion:nil];
}

- (void)showDashboard {
  
    [[DataManager sharedManager] storeKeyChainValue:kKeychainUserIsAdmin password:@"0" serviceName:kKeychainServiceName];

    NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];

    [[DataManager sharedManager] userInformation:[NSNumber numberWithInteger:userId.integerValue] success:^(id object) {
        
        NSArray *roles = object[@"roles"];
        for (NSDictionary *role in roles) {
            
            NSString *name = role[@"name"];
            if ([name isEqualToString:@"superAdmin"]) {
                [[DataManager sharedManager] storeKeyChainValue:kKeychainUserIsAdmin password:@"1" serviceName:kKeychainServiceName];
            }
            
        }
        
        NSString *dateString = [DerivedNSManagedObject shortDateStringFromDate:[NSDate date]];
        NSDate *currentDate = [DerivedNSManagedObject dateFromShortDateString:dateString];
        
        [[DataManager sharedManager] hiddentProjects:^(id object) {
            
            [[DataManager sharedManager] bidsRecentlyMade:currentDate success:^(id object) {
                DashboardViewController *controller = [DashboardViewController new];
                controller.dashboardViewControllerDelegate = self;
                [self.navigationController pushViewController:controller animated:YES];
            } failure:^(id object) {
                
                [self promptForReloginWithMessage:NSLocalizedLanguage(@"LOGIN_AUTH_ERROR_SERVER")];
                
            }];
            
        } failure:^(id object) {
            
            [self promptForReloginWithMessage:NSLocalizedLanguage(@"LOGIN_AUTH_ERROR_SERVER")];
            
        }];

    } failure:^(id object) {
        
        [self promptForReloginWithMessage:NSLocalizedLanguage(@"LOGIN_AUTH_ERROR_SERVER")];

    }];
    
}

- (void)loginUsingTouchId {
    [[TouchIDManager sharedTouchIDManager] authenticateWithSuccessHandler:^{
        [[DataManager sharedManager] loginFingerPrintForSuccess:^(id object) {
            [self showDashboard];
        } failure:^(id object) {
        
            [self promptForReloginWithMessage:NSLocalizedLanguage(@"LOGIN_AUTH_ERROR_MSG")];

        }];
        
    } error:^{
        showLoginDirect = YES;
        [self showLogin];
    } viewController:self];

}

- (void)showIntroduction{
    IntroViewController *controller = [IntroViewController new];
    controller.introViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)login {
    showLoginDirect = NO;
    [self showIntroductionViewCOntrollerShow:^(id object){
        [self showIntroduction];
    } dontShow:^(id object){
        [self loginSub];
    }];
}
- (void)loginSub {
    if ([[DataManager sharedManager] shouldLoginUsingTouchId]) {
        
        NSDate *currentDate = [NSDate date];
        NSDate *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kKeychainTouchIDExpiration];
        
        if (expirationDate != nil) {
            
            NSTimeInterval interval = [currentDate timeIntervalSinceDate:expirationDate];
            
            NSString *accessToken = [[DataManager sharedManager] getKeyChainValue:kKeychainAccessToken serviceName:kKeychainServiceName];
            
            if (accessToken == nil) {
                accessToken = @"";
            }
            
            if( ( interval > 0) || (accessToken.length==0) ) {
                [self loginUsingTouchId];
            } else {
                [self showDashboard];
            }
            
        } else {
            [self loginUsingTouchId];
        }
        
    } else {
        [self showDashboard];
    }
    
}

- (void)logout {
    [[DataManager sharedManager] storeKeyChainValue:kKeychainAccessToken password:@"" serviceName:kKeychainServiceName];
   
    [self.navigationController popToRootViewControllerAnimated:YES];
    isLogin = NO;
    [self presentLogin];
}


- (void)promptForReloginWithMessage:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action) {
                                                            [self login];
                                                        }];
    
    [alert addAction:closeAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - IntroViewControllerDelegate
- (void)tappedIntroCloseButton {
    if (showLoginDirect) {
        [self showLogin];
    } else {
         [self login];
    }
}


- (void)showIntroductionViewCOntrollerShow:(APIBlock)showIntro dontShow:(APIBlock)dontShowIntro{
     NSString *currentAppVersion = [[DataManager sharedManager] currentAppVersion];
     NSString *previousVersion = [[DataManager sharedManager] previousVersion];
     
     if (!previousVersion) {
     // first Install or deleted
         [[DataManager sharedManager] setPreviousVersion:currentAppVersion];
         showIntro(nil);
     } else if ([previousVersion isEqualToString:currentAppVersion]) {
     // same version
         dontShowIntro(nil);
     } else {
     // other version or updated
         [[DataManager sharedManager] setPreviousVersion:currentAppVersion];
         showIntro(nil);
     }
}

@end

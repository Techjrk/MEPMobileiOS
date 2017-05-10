//
//  LandingViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/20/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "LandingViewController.h"

#import "LoginViewController.h"
#import "DashboardViewController.h"

@interface LandingViewController ()<LoginDelegate, DashboardViewControllerDelegate>{
    BOOL isLogin;
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
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoLogin) userInfo:nil repeats:NO];
        
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
            [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(showLogin) userInfo:nil repeats:NO];
        } else {
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

}

- (void)loginUsingTouchId {
    [[TouchIDManager sharedTouchIDManager] authenticateWithSuccessHandler:^{
        [[DataManager sharedManager] loginFingerPrintForSuccess:^(id object) {
            [self showDashboard];
        } failure:^(id object) {
        
            [self promptForReloginWithMessage:NSLocalizedLanguage(@"LOGIN_AUTH_ERROR_MSG")];

        }];
        
    } error:^{
        [self showLogin];
    } viewController:self];

}

- (void)login {
    
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
@end

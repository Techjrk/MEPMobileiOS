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

@interface LandingViewController ()<LoginDelegate>{
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
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(login) userInfo:nil repeats:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isLogin) {
        isLogin = YES;
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(showLogin) userInfo:nil repeats:NO];
    }
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

- (void)login {
    
    NSDate *currentDate = [DerivedNSManagedObject dateFromDayString:@"2015-11-01"];
    
    [[DataManager sharedManager] bidsRecentlyMade:currentDate success:^(id object) {
        DashboardViewController *controller = [DashboardViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    } failure:^(id object) {
    }];

}

@end

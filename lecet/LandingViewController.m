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
    controller.view.frame = self.view.frame;
    [self.view addSubview:controller.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isLogin) {
        isLogin = YES;
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(showLogin) userInfo:nil repeats:NO];
    }
}

- (void)showLogin {
    LoginViewController *controller = [LoginViewController new];
    controller.loginDelegate = self;
    [self presentViewController:controller animated:NO completion:nil];
}

- (void)login {
    DashboardViewController *controller = [DashboardViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

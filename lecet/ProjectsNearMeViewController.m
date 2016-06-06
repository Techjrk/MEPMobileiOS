//
//  ProjectsNearMeViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectsNearMeViewController.h"

#import "projectsNearMeConstants.h"
#import "ShareLocationViewController.h"
#import "GoToSettingsViewController.h"

@interface ProjectsNearMeViewController ()<ShareLocationDelegate, GoToSettingsDelegate>{
    BOOL isFirstLaunch;
}
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
- (IBAction)tappedButtonback:(id)sender;
@end

@implementation ProjectsNearMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableTapGesture:YES];
    
    _textFieldSearch.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _textFieldSearch.layer.cornerRadius = kDeviceWidth * 0.0106;
    _textFieldSearch.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_searchTextField"]];
    imageView.frame = CGRectMake(0, 0, kDeviceWidth * 0.1, kDeviceHeight * 0.025);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _textFieldSearch.leftView = imageView;
    _textFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    _textFieldSearch.textColor = [UIColor whiteColor];
    _textFieldSearch.font = PROJECTS_TEXTFIELD_TEXT_FONT;
    [_textFieldSearch setTintColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationAppBecomeActive:) name:NOTIFICATION_APP_BECOME_ACTIVE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationLocationDenied:) name:NOTIFICATION_APP_BECOME_ACTIVE object:nil];
    
}

- (void)NotificationAppBecomeActive:(NSNotification*)notification {
    [self viewWasLaunced];
}

- (void)NotificationLocationDenied:(NSNotification*)notification {
    [self gotoSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedButtonback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWasLaunced {
    if (!isFirstLaunch) {
        isFirstLaunch = YES;
        switch ([[DataManager sharedManager] locationManager].currentStatus) {
            case kCLAuthorizationStatusNotDetermined:{
                [self showShareLocation];
                break;
            }
            case kCLAuthorizationStatusDenied : {
                [self gotoSettings];
            }
            default: {
                break;
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self viewWasLaunced];
}

- (void)tappedButtonShareLocation:(id)object {
    [[[DataManager sharedManager] locationManager] requestAlways];
}

- (void)gotoSettings {
    GoToSettingsViewController *controller = [GoToSettingsViewController new];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.goToSettingsDelegate = self;
    [self presentViewController:controller animated:NO completion:nil];
    
}

- (void)showShareLocation {
    ShareLocationViewController *controller = [ShareLocationViewController new];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.shareLocationDelegate = self;
    [self presentViewController:controller animated:NO completion:nil];

}

-(void)tappedButtonShareCancel:(id)object {
    [self gotoSettings];
}

-(void)tappedButtonGotoSettingsCancel:(id)object {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tappedButtonGotoSettings:(id)object {
    
    if ([[DataManager sharedManager] locationManager].currentStatus != kCLAuthorizationStatusAuthorizedAlways) {
        isFirstLaunch = NO;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end

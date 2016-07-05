//
//  ChangePasswordViewController.m
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ProfileNavView.h"
#import "ChangePasswordView.h"
#import "ProfileNavView.h"

#define CHANGEPASSWORD_VC_BG_COLOR          RGB(245,245,245)

@interface ChangePasswordViewController ()<ProfileNavViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet ProfileNavView *profileNavView;
@property (weak, nonatomic) IBOutlet ChangePasswordView *chnagePasswordView;

@end

@implementation ChangePasswordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:[[self class] description] bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _profileNavView.profileNavViewDelegate = self;
    [self.view setBackgroundColor:CHANGEPASSWORD_VC_BG_COLOR];
    _profileNavView.profileNavViewDelegate = self;
    [_profileNavView setNavTitleLabel:NSLocalizedLanguage(@"CHANGEPASSWORD_NAV_TITLE")];
    [self enableTapGesture:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ProfileNav Delegate
- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    
    if (profileNavItem == ProfileNavItemSaveButton) {
        
        NSString *currentPassword = [_chnagePasswordView getCurrentPasswordText];
        NSString *newPassword = [_chnagePasswordView getNewPasswordText];
        NSString *confirmPassword = [_chnagePasswordView getConfirmPasswordText];
        
        [[DataManager sharedManager] featureNotAvailable];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

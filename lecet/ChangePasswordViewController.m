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
#define BOTTOM_LABEL_FONT_COLOR             RGB(149,149,149)
#define BOTTOM_LABEL_FONT                   fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 9.0f)

@interface ChangePasswordViewController ()<ProfileNavViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet ProfileNavView *profileNavView;
@property (weak, nonatomic) IBOutlet ChangePasswordView *chnagePasswordView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

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
    _bottomLabel.font = BOTTOM_LABEL_FONT;
    _bottomLabel.textColor = BOTTOM_LABEL_FONT_COLOR;
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
        
        NSDictionary *changePasswordDict = @{@"oldPassword":currentPassword,@"password":newPassword,@"confirmation":confirmPassword};
        
        if (currentPassword.length > 0 && newPassword.length > 0 && confirmPassword.length > 0) {
            
            if ([newPassword isEqualToString:confirmPassword]) {
                
                [[DataManager sharedManager] changePassword:[changePasswordDict mutableCopy] success:^(id object) {
                    
                    [[DataManager sharedManager] promptMessage:@"Change pasword had been \n Successfull"];
                    
                }failure:^(id object) {
                    
                }];

            } else {
                [[DataManager sharedManager] promptMessage:@"New Password and Confirm Pasword didn't match"];
            }
    
        }
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

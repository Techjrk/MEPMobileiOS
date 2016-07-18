//
//  SettingsViewController.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SettingsViewController.h"
#import "ProfileNavView.h"
#import "SettingsView.h"
#import "ChangePasswordViewController.h"

#define SETTINGS_VC_BG_COLOR RGB(245,245,245)
#define BOTTOM_LABEL_FONT_COLOR             RGB(149,149,149)
#define BOTTOM_LABEL_FONT                   fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 9.0f)

@interface SettingsViewController ()<ProfileNavViewDelegate,SettingViewDelegate>
@property (weak, nonatomic) IBOutlet ProfileNavView *navView;
@property (weak, nonatomic) IBOutlet SettingsView *settingsView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@end

@implementation SettingsViewController
@synthesize settingsViewControllerDelegate;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:[[self class] description] bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_navView hideSaveButton:YES];
    
    [_navView setNavTitleLabel:NSLocalizedLanguage(@"SETTINGS_NAV_TITLE")];
    _navView.profileNavViewDelegate = self;
    [self.view setBackgroundColor:SETTINGS_VC_BG_COLOR];
    _settingsView.settingViewDelegate = self;
    
    _bottomLabel.font = BOTTOM_LABEL_FONT;
    _bottomLabel.textColor = BOTTOM_LABEL_FONT_COLOR;
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    _bottomLabel.text = [NSString stringWithFormat:@"MEP %@",version];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav View Delegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    
    switch (profileNavItem) {
        case ProfileNavItemBackButton:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ProfileNavItemSaveButton:{
            
            break;
        }
    }
}


#pragma mark - Setting View Delegate

- (void)switchButtonStateChange:(BOOL)isOn {
    
}

- (void)selectedSettings:(SettingItems)items {
    
    switch (items) {
        case SettingItemsChangePassword:{
            ChangePasswordViewController *controller = [ChangePasswordViewController new];

            [self.navigationController pushViewController:controller animated:YES];
            
            break;
        }
        case SettingItemsSignOut:{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedLanguage(@"SETTINGS_SIGNOUT") preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_YES")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    [self.settingsViewControllerDelegate tappedLogout];
                                                                }];
            
            [alert addAction:yesAction];

            UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_NO")
                                                                  style:UIAlertActionStyleDestructive
                                                                handler:^(UIAlertAction *action) {
                                                                    
                                                                }];
            
            [alert addAction:noAction];

            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

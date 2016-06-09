//
//  SettingsViewController.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SettingsViewController.h"
#import "ProfileNavView.h"
#import "SettingConstant.h"
#import "SettingsView.h"
#import "ChangePasswordViewController.h"
@interface SettingsViewController ()<ProfileNavViewDelegate,SettingViewDelegate>
@property (weak, nonatomic) IBOutlet ProfileNavView *navView;
@property (weak, nonatomic) IBOutlet SettingsView *settingsView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_navView hideSaveButton:YES];
    
    [_navView setNavTitleLabel:NSLocalizedLanguage(@"SETTINGS_NAV_TITLE")];
    _navView.profileNavViewDelegate = self;
    [self.view setBackgroundColor:SETTINGS_VC_BG_COLOR];
    _settingsView.settingViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav View Delegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    
    switch (profileNavItem) {
        case ProfileNavItemBackButton:{
            [self dismissViewControllerAnimated:YES completion:nil];
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
            [self.navigationController presentViewController:controller animated:YES completion:nil];
        
            break;
        }
        case SettingItemsSignOut:{
            
            break;
        }
    }
    
}

@end

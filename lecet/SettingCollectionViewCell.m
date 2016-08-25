//
//  SettingCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SettingCollectionViewCell.h"
#import "SettingsNotificationsView.h"
#import "SettingsCPView.h"

#define SETTINGS_SIGNOUT_LABEL_FONT fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define SETTINGS_SIGNOUT_LABEL_FONT_COLOR RGB(149,149,149)

@interface SettingCollectionViewCell()<SettingsNotificationsViewDelegate>
@property (weak, nonatomic) IBOutlet SettingsNotificationsView *notificationView;
@property (weak, nonatomic) IBOutlet SettingsCPView *changePasswordView;
@property (weak, nonatomic) IBOutlet UILabel *labelSignOut;

@end

@implementation SettingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _notificationView.settingsNotificationsViewDelegate = self;
    _labelSignOut.font = SETTINGS_SIGNOUT_LABEL_FONT;
    _labelSignOut.textColor = SETTINGS_SIGNOUT_LABEL_FONT_COLOR;
    _labelSignOut.text = NSLocalizedLanguage(@"SETTING_CVCELL_SIGNOUT");
}

- (void)setHideNotificationView:(BOOL)hide {
    [_notificationView setHidden:hide];
    
}

- (void)setHideChangePassword:(BOOL)hide {
    [_changePasswordView setHidden:hide];
}

#pragma mark - SettingNotifcationView Delegate

- (void) switchButtonStateChange:(BOOL)isOn {
    [_settingCollectionViewCellDelegate switchButtonStateChange:isOn];
}

@end

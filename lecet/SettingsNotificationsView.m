//
//  SettingsNotificationsView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SettingsNotificationsView.h"

#define SETTINGS_LABEL_FONT                 fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define SETTINGS_LABEL_FONT_COLOR           RGB(34,34,34)
#define SETTINGS_SWITCHBUTTON_BG_COLOR      RGB(168,195,230)

@interface SettingsNotificationsView ()
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SettingsNotificationsView

- (void)awakeFromNib {
    _label.font = SETTINGS_LABEL_FONT;
    _label.textColor = SETTINGS_LABEL_FONT_COLOR;
    [_switchButton setOnTintColor:SETTINGS_SWITCHBUTTON_BG_COLOR];
    _label.text = NSLocalizedLanguage(@"SETTING_NOTIFICATIONS_TEXT");
}

- (IBAction)switchButtonClicked:(id)sender {
    [_settingsNotificationsViewDelegate switchButtonStateChange:[_switchButton isOn]];
}


@end

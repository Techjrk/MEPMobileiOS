//
//  DropDownMenuView.m
//  lecet
//
//  Created by Get Devs on 18/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DropDownMenuView.h"
#import "dropDownMenuConstants.h"

@interface DropDownMenuView ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonMyProfile;
@property (weak, nonatomic) IBOutlet UIButton *buttonHiddenProjects;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;
@property (weak, nonatomic) IBOutlet UIView *leftSideView;
@property (weak, nonatomic) IBOutlet UIView *rightSideView;
- (IBAction)tappedDropDownButtonMenu:(id)sender;
@end

@implementation DropDownMenuView

-(void)awakeFromNib{
    
    _userNameLabel.font = DROPDOWN_MENU_LABEL_USERNAME_FONT;
    _emailAddressLabel.font = DROPDOWN_MENU_LABEL_EMAIL_ADDRESS_FONT;
    
    _userNameLabel.textColor = DROPDOWN_MENU_LABEL_USERNAME_FONT_COLOR;
    _emailAddressLabel.textColor = DROPDOWN_MENU_LABEL_EMAIL_ADDRESS_FONT_COLOR;
    
   

    _buttonMyProfile.titleLabel.font = DROPDOWN_MENU_BUTTON_MY_PROFILE_FONT;
    _buttonHiddenProjects.titleLabel.font = DROPDOWN_MENU_BUTTON_HIDDEN_PROJECTS_FONT;
    _buttonSettings.titleLabel.font = DROPDOWN_MENU_BUTTON_SETTINGS_FONT;

    _buttonMyProfile.titleLabel.textColor = DROPDOWN_MENU_BUTTON_FONT_COLOR;
    _buttonHiddenProjects.titleLabel.textColor = DROPDOWN_MENU_BUTTON_FONT_COLOR;
    _buttonSettings.titleLabel.textColor = DROPDOWN_MENU_BUTTON_FONT_COLOR;
    
    _buttonMyProfile.tag = DropDownMenuMyProfile;
    [_buttonMyProfile setTitle:NSLocalizedLanguage(@"DROPDOWNMENU_MYPROFILE_BUTTON_TEXT") forState:UIControlStateNormal];
    
    _buttonHiddenProjects.tag = DropDownMenuHiddenProjects;
    [_buttonHiddenProjects setTitle:NSLocalizedLanguage(@"DROPDOWNMENU_HIDDENPROJECTS_BUTTON_TEXT") forState:UIControlStateNormal];
    
    _buttonSettings.tag = DropDownMenuSettings;
    [_buttonSettings setTitle:NSLocalizedLanguage(@"DROPDOWNMENU_SETTING_BUTTON_TEXT") forState:UIControlStateNormal];
    
    [self.view setBackgroundColor:DROPDOWN_MENU_VIEW_BG_COLOR];
    self.layer.cornerRadius = kDeviceWidth * (0.0106);
    self.layer.masksToBounds = YES;
}

- (IBAction)tappedDropDownButtonMenu:(id)sender{
    
    UIButton *button = sender;
    [_dropDownMenuDelegate tappedDropDownMenu:(DropDownMenuItem)button.tag];
    
}

- (void)setUserName:(NSString *)username{
    
    _userNameLabel.text = username;
    
}

- (void)setEmailAddress:(NSString *)emailAddress{
    
    _emailAddressLabel.text = emailAddress;
    
}











@end

//
//  DropDownMenuView.m
//  lecet
//
//  Created by Get Devs on 18/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DropDownMenuView.h"
#import "dropDownMenuConstants.h"
#import "Utilities.h"


@interface DropDownMenuView (){
    
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;


@property (weak, nonatomic) IBOutlet UIButton *buttonMyProfile;
@property (weak, nonatomic) IBOutlet UIButton *buttonHiddenProjects;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;


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
    
    
    //Draw TOp triangle
    [self drawDropDownTriangleTop];
    
    
    
    [self drawDimBackgroundAndCornerWithRadius];
    

    
}




- (IBAction)tappedDropDownButtonMenu:(id)sender{
    
    UIButton *button = sender;
    [_dropDownMenuDelegate tappedDropDownMenu:(DropDownMenuItem)button.tag];
    
}




- (void)drawDropDownTriangleTop{
    
    
    //Screen Size for Y axiz
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    int height = 0;
    
    float widthNeedToAdd = screenWidth * 0.021f;
    float width = screenWidth + widthNeedToAdd;
    int triangleTopDirection = -1;
    
    int triangleSize =  9;
    
    
    UIColor *bgColor = [UIColor whiteColor];
    CAShapeLayer *triangleTop = [[Utilities sharedIntances] drawDropDownTopTriangle:width backgroundColor:bgColor triangleTopDirection:triangleTopDirection heightPlacement:height sizeOfTriangle:triangleSize];
    
    
    [self.layer insertSublayer:triangleTop atIndex:1];
}



-(void)drawDimBackgroundAndCornerWithRadius{
    
    
    UIBezierPath *shadowPath = [[Utilities sharedIntances] drawShadowPath];
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(-7.0f, -100.0f);
    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowPath = shadowPath.CGPath;
    
    
    [self.view.layer setCornerRadius:5.0f];

    
}







@end

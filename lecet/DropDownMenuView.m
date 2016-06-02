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
    //Draw TOp triangle
    [self drawDropDownTriangleTop];

    //[self cornerRadius];
    
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
    
    float widthNeedToAdd;
    float width = screenWidth;
    if (isiPhone4) {
        
         widthNeedToAdd = screenWidth * 0.005f;
         width = screenWidth + widthNeedToAdd;
        
    }else{

         widthNeedToAdd = screenWidth * 0.021f;
         width = screenWidth + widthNeedToAdd;
    }
    
    
    int triangleTopDirection = -1;
    
    int triangleSize =  9;
    
    
    UIColor *bgColor = [UIColor whiteColor];
    CAShapeLayer *triangleTop = [[Utilities sharedIntances] drawDropDownTopTriangle:width backgroundColor:bgColor triangleTopDirection:triangleTopDirection heightPlacement:height sizeOfTriangle:triangleSize];
    
    
    [self.layer insertSublayer:triangleTop atIndex:1];
}



- (void)cornerRadius{
    
    CGRect frame = _leftSideView.bounds;
    frame.size.height = frame.size.height + 6;
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.frame;
    maskLayer.path  = maskPath.CGPath;
    
    _leftSideView.layer.mask = maskLayer;
    
    
    CGRect frameRight = _rightSideView.bounds;
    frameRight.size.height = frameRight.size.height + 6;
    
    
    UIBezierPath *maskPathRight = [UIBezierPath bezierPathWithRoundedRect:frameRight byRoundingCorners:( UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayerRight = [[CAShapeLayer alloc] init];
    maskLayerRight.frame = self.view.frame;
    maskLayerRight.path  = maskPathRight.CGPath;
    
    _rightSideView.layer.mask = maskLayerRight;
 
}

- (void)setUserName:(NSString *)username{
    
    _userNameLabel.text = username;
    
}

- (void)setEmailAddress:(NSString *)emailAddress{
    
    _emailAddressLabel.text = emailAddress;
    
}











@end

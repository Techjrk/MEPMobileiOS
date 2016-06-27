//
//  ProfileNavView.m
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProfileNavView.h"

#define PROFILE_NAV_VIEW_BG_COLOR               RGB(5, 35, 74)

#define PROFILE_NAV_TITLE_FONT                  fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define PROFILE_NAV_TITLE_FONT_COLOR            RGB(255,255,255)

#define PROFILE_NAV_SAVE_BUTTON_FONT            fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define PROFILE_NAV_SAVE_BUTTON_FONT_COLOR      RGB(168,195,230)

@interface ProfileNavView () {
    BOOL setTitleFromController;
}
@property (weak, nonatomic) IBOutlet UILabel *profileNavTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightNavButton;
@property (weak, nonatomic) IBOutlet UIButton *leftNavButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;

@end

@implementation ProfileNavView

- (void)awakeFromNib {
    
    _constraintWidth.constant = 0;
    [self setBackgroundColor:PROFILE_NAV_VIEW_BG_COLOR];
    _leftNavButton.tag = ProfileNavItemBackButton;
    _rightNavButton.tag = ProfileNavItemSaveButton;
    
    _profileNavTitleLabel.font = PROFILE_NAV_TITLE_FONT;
    _profileNavTitleLabel.textColor = PROFILE_NAV_TITLE_FONT_COLOR;
    
    _rightNavButton.titleLabel.font = PROFILE_NAV_SAVE_BUTTON_FONT;
    [_rightNavButton setTitleColor:PROFILE_NAV_SAVE_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    //if (!setTitleFromController) {
         [_rightNavButton setTitle:NSLocalizedLanguage(@"PROFILE_NAV_RIGHT_BUTTON_TEXT") forState:UIControlStateNormal];
    //}
   
}

- (IBAction)tappedProfileNavButton:(id)sender {
    UIButton *button = sender;
    [_profileNavViewDelegate tappedProfileNav:(ProfileNavItem)button.tag];
}

- (void)setNavTitleLabel:(NSString *)name {
    _profileNavTitleLabel.text = name;
}

- (void)hideSaveButton:(BOOL)hide {
    [_rightNavButton setHidden:hide];
}

- (void)setNavRightButtonTitle:(NSString *)text {
    //setTitleFromController = YES;
    [_rightNavButton setTitle:text forState:UIControlStateNormal];
}

- (void)setRigthBorder:(int)border {
    _constraintWidth.constant = border;
}

@end

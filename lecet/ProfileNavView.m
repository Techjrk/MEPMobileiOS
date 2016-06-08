//
//  ProfileNavView.m
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProfileNavView.h"
#import "profileNavViewConstant.h"

@interface ProfileNavView ()
@property (weak, nonatomic) IBOutlet UILabel *profileNavTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightNavButton;
@property (weak, nonatomic) IBOutlet UIButton *leftNavButton;

@end

@implementation ProfileNavView

- (void)awakeFromNib {
    [self setBackgroundColor:PROFILE_NAV_VIEW_BG_COLOR];
    _leftNavButton.tag = ProfileNavItemBackButton;
    _rightNavButton.tag = ProfileNavItemSaveButton;
    
    _profileNavTitleLabel.font = PROFILE_NAV_TITLE_FONT;
    _profileNavTitleLabel.textColor = PROFILE_NAV_TITLE_FONT_COLOR;
    
    _rightNavButton.titleLabel.font = PROFILE_NAV_SAVE_BUTTON_FONT;
    [_rightNavButton setTitleColor:PROFILE_NAV_SAVE_BUTTON_FONT_COLOR forState:UIControlStateNormal];
}

- (IBAction)tappedProfileNavButton:(id)sender {
    UIButton *button = sender;
    [_profileNavViewDelegate tappedProfileNav:(ProfileNavItem)button.tag];
}

- (void)setNavTitleLabel:(NSString *)name{
    _profileNavTitleLabel.text = name;
}
@end

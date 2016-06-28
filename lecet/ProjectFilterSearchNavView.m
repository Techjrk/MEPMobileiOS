//
//  ProjectFilterSearchNavView.m
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterSearchNavView.h"




#define BUTTON_FONT                        fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define BUTTON_FONT_COLOR                  RGB(168,195,230)

#define SEACRCH_PLACEHOLDER_FONT           fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define SEACRCH_PLACEHOLDER_COLOR          RGB(255,255,255)
#define SEACRCH_PLACEHOLDER_TEXT           @" "
#define SEACRCH_TEXTFIELD_TEXT_FONT        fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)

@interface ProjectFilterSearchNavView ()
@property (weak, nonatomic) IBOutlet UIView *containerTextView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation ProjectFilterSearchNavView

- (void)awakeFromNib {
    [_containerTextView.layer setCornerRadius:4.0f];
    _containerTextView.layer.masksToBounds = YES;
    
    _rightButton.titleLabel.font = BUTTON_FONT;
    [_rightButton setTitleColor:BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kDeviceWidth * 0.1, kDeviceHeight * 0.025);
    [button setImage:[UIImage imageNamed:@"icon_searchTextField"] forState:UIControlStateNormal];
    
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:SEACRCH_PLACEHOLDER_TEXT attributes:@{NSFontAttributeName:SEACRCH_PLACEHOLDER_FONT, NSForegroundColorAttributeName:SEACRCH_PLACEHOLDER_COLOR}];
    
    [placeHolder appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",NSLocalizedLanguage(@"SEARCH_PLACEHOLDER")] attributes:@{NSFontAttributeName:SEACRCH_TEXTFIELD_TEXT_FONT, NSForegroundColorAttributeName:[SEACRCH_PLACEHOLDER_COLOR colorWithAlphaComponent:0.5f]}]];

    
    _textField.leftView = button;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.attributedPlaceholder = placeHolder;
    _textField.font = SEACRCH_TEXTFIELD_TEXT_FONT;
    _textField.textColor = SEACRCH_PLACEHOLDER_COLOR;
    
    
    _backButton.tag = ProjectFilterSearchNavItemBack;
    _rightButton.tag = ProjectFilterSearchNavItemApply;
    
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

- (IBAction)tappedButton:(id)sender {
    UIButton *button = sender;
    [_projectFilterSearchNavViewDelegate tappedFilterSearchNavButton:(ProjectFilterSearchNavItem)button.tag];
    
}

- (void)textFieldChanged:(UITextField *)textField {
    [_projectFilterSearchNavViewDelegate textFieldChanged:textField];
}

@end

//
//  CPCustomTextFieldView.m
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CPCustomTextFieldView.h"

#define CPCUSTOMTEXTFIELD_LEFT_LABEL_FONT                   fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define CPCUSTOMTEXTFIELD_LEFT_LABEL_FONT_COLOR             RGB(34,34,34)

#define CPCUSTOMTEXTFIELD_TEXTFIELD_PLACEHOLDER_FONT        fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define CPCUSTOMTEXTFIELD_TEXTFIELD_PLACEHOLDER_FONT_COLOR  RGB(34,34,34)

@interface CPCustomTextFieldView ()
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CPCustomTextFieldView


- (void)awakeFromNib {
    [super awakeFromNib];
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _leftTitleLabel.font = CPCUSTOMTEXTFIELD_LEFT_LABEL_FONT;
    _leftTitleLabel.textColor = CPCUSTOMTEXTFIELD_LEFT_LABEL_FONT_COLOR;
    
}

-(void)setPlaceHolder:(NSString *)placeHolder {
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[CPCUSTOMTEXTFIELD_TEXTFIELD_PLACEHOLDER_FONT_COLOR colorWithAlphaComponent:0.5f], NSFontAttributeName:CPCUSTOMTEXTFIELD_TEXTFIELD_PLACEHOLDER_FONT}];
}

- (void)textFieldChanged:(UITextField *)textField
{

}

- (NSString *)text {
    return _textField.text;
}

- (void)setText:(NSString *)text {
    _textField.text = text;
}

- (void)setLefTitleText:(NSString *)title {
    _leftTitleLabel.text = title;
}

- (void)setSecure:(BOOL)secure {
    _textField.secureTextEntry = secure;
}

- (BOOL)becomeFirstResponder {
    return [_textField becomeFirstResponder];
}


@end

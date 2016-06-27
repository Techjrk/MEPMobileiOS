//
//  CustomTextField.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomTextField.h"

#define CUSTOM_TEXTFIELD_LABEL_FONT                  fontNameWithSize(FONT_NAME_LATO_REGULAR, 8)
#define CUSTOM_TEXTFIELD_FIELD_FONT                  fontNameWithSize(FONT_NAME_LATO_REGULAR, 14)

#define CUSTOM_TEXTFIELD_LABEL_COLOR                 RGB(72, 72, 74)
#define CUSTOM_TEXTFIELD_FIELD_COLOR                 RGB(72, 72, 74)
#define CUSTOM_TEXTFIELD_LAYER_COLOR                 RGB(72, 72, 74)

@interface CustomTextField()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceholder;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation CustomTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    _labelPlaceholder.hidden = YES;
    _labelPlaceholder.font = CUSTOM_TEXTFIELD_LABEL_FONT;
    _labelPlaceholder.textColor = CUSTOM_TEXTFIELD_LABEL_COLOR;
    
    _textField.font = CUSTOM_TEXTFIELD_FIELD_FONT;
    _textField.textColor = CUSTOM_TEXTFIELD_FIELD_COLOR;
    
    _lineView.backgroundColor = CUSTOM_TEXTFIELD_LAYER_COLOR;
    
}

-(void)setPlaceHolder:(NSString *)placeHolder {
    _labelPlaceholder.text = placeHolder;
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:CUSTOM_TEXTFIELD_FIELD_COLOR, NSFontAttributeName:CUSTOM_TEXTFIELD_FIELD_FONT}];
}

- (void)textFieldChanged:(UITextField *)textField
{
    _labelPlaceholder.hidden = textField.text.length == 0;
}

- (NSString *)text {
    return _textField.text;
}

- (void)setText:(NSString *)text {
    _textField.text = text;
}

- (void)setSecure:(BOOL)secure {
    _textField.secureTextEntry = secure;
}

- (BOOL)becomeFirstResponder {
    return [_textField becomeFirstResponder];
}

@end

//
//  MyProfileTextView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileTextView.h"

@interface MyProfileTextView ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MyProfileTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)setPlaceHolder:(NSString *)placeHolder {
   // _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[CPCUSTOMTEXTFIELD_TEXTFIELD_PLACEHOLDER_FONT_COLOR colorWithAlphaComponent:0.5f], NSFontAttributeName:CPCUSTOMTEXTFIELD_TEXTFIELD_PLACEHOLDER_FONT}];
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

- (void)setSecure:(BOOL)secure {
    _textField.secureTextEntry = secure;
}

- (BOOL)becomeFirstResponder {
    return [_textField becomeFirstResponder];
}
@end

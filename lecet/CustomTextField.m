//
//  CustomTextField.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomTextField.h"

#import "customTextFieldConstants.h"

@interface CustomTextField()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceholder;
@property (weak, nonatomic) IBOutlet UITextField *textField;

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
    
}

-(void)setPlaceHolder:(NSString *)placeHolder {
    _labelPlaceholder.text = placeHolder;
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:CUSTOM_TEXTFIELD_FIELD_COLOR, NSFontAttributeName:CUSTOM_TEXTFIELD_FIELD_FONT}];

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CALayer *layer = [CALayer new];
    
    CGFloat thickness = 1;
    layer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
    layer.backgroundColor = CUSTOM_TEXTFIELD_LAYER_COLOR.CGColor;
    [self.view.layer addSublayer:layer];
    
}

- (void)textFieldChanged:(UITextField *)textField
{
    _labelPlaceholder.hidden = textField.text.length == 0;
}


@end

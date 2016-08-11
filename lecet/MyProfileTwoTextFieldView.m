//
//  MyProfileTwoTextFieldView.m
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileTwoTextFieldView.h"
#import "MyProfileHeaderView.h"

@interface MyProfileTwoTextFieldView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MyProfileHeaderView *myProfileHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLeft;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRight;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation MyProfileTwoTextFieldView

- (void)awakeFromNib {
    [_lineView setBackgroundColor:MYPROFILE_VERTICAL_LINE_BG_COLOR];
    
    [_textFieldLeft setFont:MYPROFILE_TEXTFIELD_FONT];
    [_textFieldRight setFont:MYPROFILE_TEXTFIELD_FONT];
    [_textFieldLeft setTextColor:MYPROFILE_TEXTFIELD_FONT_COLOR];
    [_textFieldRight setTextColor:MYPROFILE_TEXTFIELD_FONT_COLOR];
    
    [_textFieldLeft addTarget:self action:@selector(textFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
    [_textFieldRight addTarget:self action:@selector(textFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
    _textFieldLeft.delegate = self;
    _textFieldRight.delegate = self;
    
    
}
- (BOOL)becomeFirstResponder {
    
    if (_textFieldLeft) {
        return [_textFieldLeft becomeFirstResponder];
    }else {
        return [_textFieldRight becomeFirstResponder];
    }
    
}
- (void)setTileLeftLabelText:(NSString *)title {
    [_myProfileHeaderView setLeftLabelText:title];
}
- (void)setTileRightLabelText:(NSString *)title {
    [_myProfileHeaderView setRightLabelText:title];
}
- (void)setHideTitleRightLabel:(BOOL)hide {
    [_myProfileHeaderView hideRightLabel:hide];
}
- (void)setTextFieldLeftText:(NSString *)text {
    _textFieldLeft.text = text;
}
- (void)setTextFieldLeftPlaceholder:(NSString *)text {
    _textFieldLeft.placeholder = text;
}

- (void)setTextFielRightText:(NSString *)text {
    _textFieldRight.text = text;
}
- (void)setTextFielRightPlaceholder:(NSString *)text {
    _textFieldRight.placeholder = text;
}

- (NSString *)getTextLeft {
    return _textFieldLeft.text;
}
- (NSString *)getTextRight {
    return _textFieldRight.text;
}
- (void)setSecureTextFieldLeft:(BOOL)secure {
    _textFieldLeft.secureTextEntry = secure;
}

- (void)setLeftTFKeyboard:(UIKeyboardType)keyboard {
    [_textFieldLeft setKeyboardType:keyboard];
}
- (void)setRightTFKeyboard:(UIKeyboardType)keyboard {
    [_textFieldRight setKeyboardType:keyboard];
}
- (void)textFieldDidBeginEditing
{
    [_textFieldViewDelegate textFieldDidBeginEditing:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _textFieldLeft) {
        [_textFieldLeft resignFirstResponder];
    }
    if (textField == _textFieldRight) {
        [_textFieldRight resignFirstResponder];
    }
    
    return NO;
}

@end

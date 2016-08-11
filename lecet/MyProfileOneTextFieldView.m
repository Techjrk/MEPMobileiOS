//
//  MyProfileOneTextFieldView.m
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileOneTextFieldView.h"
#import "MyProfileHeaderView.h"

@interface MyProfileOneTextFieldView ()<UITextViewDelegate>{
    
    NSString *textFieldViewText;
    NSString *textFieldViewPlaceHolder;
    
}
@property (weak, nonatomic) IBOutlet MyProfileHeaderView *myProfileHeaderView;
@property (weak, nonatomic) IBOutlet UITextView *textFieldView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeaderHeight;

@end

@implementation MyProfileOneTextFieldView
- (void)awakeFromNib {
    [_textFieldView setFont:MYPROFILE_TEXTFIELD_FONT];
    [_textFieldView setTextColor:MYPROFILE_TEXTFIELD_FONT_COLOR];

    _textFieldView.delegate = self;
    _constraintHeaderHeight.constant = ((kDeviceHeight *0.1195) / 2);

    _textFieldView.editable = YES;
}
- (void)setTileLeftLabelText:(NSString *)title {
    [_myProfileHeaderView setLeftLabelText:title];
}

- (void)setHideTitleRightLabel:(BOOL)hide {
    [_myProfileHeaderView hideRightLabel:hide];
}

- (void)setTextFielText:(NSString *)text {
    if ([DerivedNSManagedObject objectOrNil:text]) {
        _textFieldView.text = text;
    } else {
        _textFieldView.textColor = [UIColor lightGrayColor];
        _textFieldView.text = textFieldViewPlaceHolder;
    }
}

- (void)setTextFieldPlaceholder:(NSString *)text {
    textFieldViewPlaceHolder = text;
}

- (void)setSecureTextField:(BOOL)secure {
    _textFieldView.secureTextEntry = secure;
}

- (NSString *)getText {
    if ([textFieldViewText isEqualToString:textFieldViewPlaceHolder]) {
        return @"";
    }else{
        return _textFieldView.text;
    }
}

- (BOOL)becomeFirstResponder {
    return [_textFieldView becomeFirstResponder];
}

- (void)setKeyBoard:(UIKeyboardType)keyBoard {
    [_textFieldView setKeyboardType:keyBoard];
}

- (void)textFieldDidBeginEditing
{
    if ([_textFieldView.text isEqualToString:textFieldViewPlaceHolder]) {
        _textFieldView.text = @"";
        
        [_textFieldView setFont:MYPROFILE_TEXTFIELD_FONT];
        [_textFieldView setTextColor:MYPROFILE_TEXTFIELD_FONT_COLOR];
        
    }
    
    [_textfieldViewDelegate textFieldDidBeginEditing:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_textFieldView.text isEqualToString:@""]) {
        _textFieldView.textColor = [UIColor lightGrayColor];
        _textFieldView.text = textFieldViewPlaceHolder;

    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self textFieldDidBeginEditing];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

- (void)setScrollableEnabled:(BOOL)enabled {
    [_textFieldView setScrollEnabled:enabled];
}

@end

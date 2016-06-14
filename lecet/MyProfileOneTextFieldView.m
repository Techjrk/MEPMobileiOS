//
//  MyProfileOneTextFieldView.m
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileOneTextFieldView.h"
#import "MyProfileHeaderView.h"
#import "myProfileConstant.h"
@interface MyProfileOneTextFieldView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet MyProfileHeaderView *myProfileHeaderView;
@property (weak, nonatomic) IBOutlet UITextView *textFieldView;

@end

@implementation MyProfileOneTextFieldView
- (void)awakeFromNib {
    [_textFieldView setFont:MYPROFILE_TEXTFIELD_FONT];
    [_textFieldView setTextColor:MYPROFILE_TEXTFIELD_FONT_COLOR];

    _textFieldView.delegate = self;

}
- (void)setTileLeftLabelText:(NSString *)title {
    [_myProfileHeaderView setLeftLabelText:title];
}

- (void)setHideTitleRightLabel:(BOOL)hide {
    [_myProfileHeaderView hideRightLabel:hide];
}

- (void)setTextFielText:(NSString *)text {
    _textFieldView.text = text;
    
}

- (void)setSecureTextField:(BOOL)secure {
    _textFieldView.secureTextEntry = secure;
}

- (NSString *)getText {
    return _textFieldView.text;
}

- (BOOL)becomeFirstResponder {
    return [_textFieldView becomeFirstResponder];
}

- (void)setKeyBoard:(UIKeyboardType)keyBoard {
    [_textFieldView setKeyboardType:keyBoard];
}

- (void)textFieldDidBeginEditing
{
    [_textfieldViewDelegate textFieldDidBeginEditing:self];
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

@end

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
@interface MyProfileOneTextFieldView ()
@property (weak, nonatomic) IBOutlet MyProfileHeaderView *myProfileHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldView;

@end

@implementation MyProfileOneTextFieldView
- (void)awakeFromNib {
    [_textFieldView setFont:MYPROFILE_TEXTFIELD_FONT];
    [_textFieldView setTextColor:MYPROFILE_TEXTFIELD_FONT_COLOR];
    [_textFieldView addTarget:self action:@selector(textFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
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


@end

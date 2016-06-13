//
//  MyProfileTwoTextFieldView.m
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileTwoTextFieldView.h"
#import "MyProfileHeaderView.h"
#import "myProfileConstant.h"
@interface MyProfileTwoTextFieldView ()
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
- (void)setTextFielRightText:(NSString *)text {
    _textFieldRight.text = text;
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

@end

//
//  MyProfileCustomTextFieldView.m
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileCustomTextFieldView.h"
#import "MyProfileHeaderView.h"
#import "myProfileConstant.h"
@interface MyProfileCustomTextFieldView ()
@property (weak, nonatomic) IBOutlet MyProfileHeaderView *myProfileHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBelow;

@end

@implementation MyProfileCustomTextFieldView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textFieldOne addTarget:self action:@selector(textFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
    [_textFieldBelow addTarget:self action:@selector(textFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
    _lineView.backgroundColor =[[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    
    [_textFieldOne setFont:MYPROFILE_TEXTFIELD_FONT];
    [_textFieldBelow setFont:MYPROFILE_TEXTFIELD_FONT];
    [_textFieldOne setTextColor:MYPROFILE_TEXTFIELD_FONT_COLOR];
    [_textFieldBelow setTextColor:MYPROFILE_TEXTFIELD_FONT_COLOR];

}

-(void)setPlaceHolder:(NSString *)placeHolder {
    // _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[CPCUSTOMTEXTFIELD_TEXTFIELD_PLACEHOLDER_FONT_COLOR colorWithAlphaComponent:0.5f], NSFontAttributeName:CPCUSTOMTEXTFIELD_TEXTFIELD_PLACEHOLDER_FONT}];
}

- (void)textFieldDidBeginEditing
{
    [_textFieldViewDelegate textFieldDidBeginEditing:self];
}

- (NSString *)textOne {
    return _textFieldOne.text;
}

- (NSString *)textTwo {
    return _textFieldBelow.text;
}

- (void)setTextOne:(NSString *)text {
    _textFieldOne.text = text;
}
- (void)setTextFieldTwo:(NSString *)text {
    _textFieldBelow.text = text;
}

- (void)setSecureTextFieldOne:(BOOL)secure {
    _textFieldOne.secureTextEntry = secure;
}
- (void)setSecureTextFieldTwo:(BOOL)secure {
    _textFieldBelow.secureTextEntry = secure;
}

- (BOOL)becomeFirstResponder {
    
    if (_textFieldOne) {
        return [_textFieldOne becomeFirstResponder];
    }else {
        return [_textFieldBelow becomeFirstResponder];
    }
    
}

- (void)setTileLeftLabelText:(NSString *)title {
    [_myProfileHeaderView setLeftLabelText:title];
}

- (void)setHideTitleRightLabel:(BOOL)hide {
    [_myProfileHeaderView hideRightLabel:hide];
}

- (void)setTextFieldOneText:(NSString *)text {
    _textFieldOne.text = text;
}

- (void)setTextFieldTwoText:(NSString *)text {
    _textFieldBelow.text = text;
  
}
- (NSString *)getTextOne {
    return _textFieldOne.text;
}
- (NSString *)getTextTwo {
    return _textFieldBelow.text;
}

- (void)configureView:(UIView*)view {
    CGFloat borderWidth = 1.0;
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(borderWidth, view.frame.size.height - borderWidth, view.frame.size.width, 1)];
    mask.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [view addSubview:mask];
    
}






@end

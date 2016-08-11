//
//  MyProfileView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileView.h"
#import "MyProfileCustomTextFieldView.h"
#import "MyProfileOneTextFieldView.h"
#import "MyProfileTwoTextFieldView.h"
#import "MyProfileHeaderView.h"

@interface MyProfileView ()<TextfieldViewDelegate>{
    NSDictionary *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    NSArray *headerIndex;
    NSArray *textFieldIndex;
    NSMutableArray *myProfileDataInfo;
    NSDictionary *profileInfo;
    UIView *activeView;
    UITextView *tempTextView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet MyProfileCustomTextFieldView *nameTextFieldview;
@property (weak, nonatomic) IBOutlet MyProfileOneTextFieldView *emailAddressTextFieldView;
@property (weak, nonatomic) IBOutlet MyProfileOneTextFieldView *titleTextFieldView;
@property (weak, nonatomic) IBOutlet MyProfileOneTextFieldView *organizationTextFieldView;

@property (weak, nonatomic) IBOutlet MyProfileTwoTextFieldView *phoneFaxTextFieldView;
@property (weak, nonatomic) IBOutlet MyProfileOneTextFieldView *streetAddressTextFieldView;
@property (weak, nonatomic) IBOutlet MyProfileOneTextFieldView *cityTextFieldView;
@property (weak, nonatomic) IBOutlet MyProfileTwoTextFieldView *stateZipTextFieldView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintOrganizationHeight;


@end

@implementation MyProfileView


- (void)awakeFromNib {

    [_containerView setBackgroundColor:MYPROFILE_CONTAINERVIEW_BG_COLOR];
    [self.view setBackgroundColor:MYPROFILE_CONTAINERVIEW_BG_COLOR];
    
    [_nameTextFieldview setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_NAME")];
    [_nameTextFieldview setHideTitleRightLabel:YES];
    
    [_emailAddressTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_EMAIL_ADDRESS")];
    [_emailAddressTextFieldView setHideTitleRightLabel:YES];
    [_emailAddressTextFieldView setKeyBoard:UIKeyboardTypeEmailAddress];
    
    [_titleTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_TITLE")];
    [_titleTextFieldView setHideTitleRightLabel:YES];
    
    [_organizationTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_ORGANIZATION")];
    [_organizationTextFieldView setHideTitleRightLabel:YES];
    
    [_phoneFaxTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_PHONE")];
    [_phoneFaxTextFieldView setLeftTFKeyboard:UIKeyboardTypePhonePad];
    [_phoneFaxTextFieldView setHideTitleRightLabel:NO];
    [_phoneFaxTextFieldView setTileRightLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_FAX")];
    [_phoneFaxTextFieldView setRightTFKeyboard:UIKeyboardTypePhonePad];
    
    [_streetAddressTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STREETADDRESS")];
    [_streetAddressTextFieldView setHideTitleRightLabel:YES];
    
    [_cityTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_CITY")];
    [_cityTextFieldView setHideTitleRightLabel:YES];
    
    [_stateZipTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STATE")];
    [_stateZipTextFieldView setHideTitleRightLabel:NO];
    [_stateZipTextFieldView setTileRightLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_ZIP")];
    [_stateZipTextFieldView setRightTFKeyboard:UIKeyboardTypeNumberPad];
    
    
    _nameTextFieldview.textFieldViewDelegate = self;
    _emailAddressTextFieldView.textfieldViewDelegate = self;
    _titleTextFieldView.textfieldViewDelegate = self;
    _organizationTextFieldView.textfieldViewDelegate = self;
    _phoneFaxTextFieldView.textFieldViewDelegate = self;
    _streetAddressTextFieldView.textfieldViewDelegate = self;
    _cityTextFieldView.textfieldViewDelegate = self;
    _stateZipTextFieldView.textFieldViewDelegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)setHeader{
    
    headerIndex= @[@"0",@"3",@"5",@"7",@"9",@"11",@"13",@"15"];
    textFieldIndex = @[@"1",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16"];
    myProfileDataInfo = [@[NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_NAME"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_FIRSTNAME"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_LASTNAME"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_EMAIL_ADDRESS"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_EMAIL_ADDRESS"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_TITLE"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_TITLE"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_ORGANIZATION"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_ORGANIZATION"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_PHONE"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_PHONE"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STREETADDRESS"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_STREETADDRESS"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_CITY"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_CITY"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STATE"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_STATE")] mutableCopy];
    
}

- (void)setInfo:(id)info {
    profileInfo = info;
    
}

- (void)setFirstName:(NSString *)text {
    if ([DerivedNSManagedObject objectOrNil:text]) {
        [_nameTextFieldview setTextFieldOneText:text];
    }
}

- (void)setFirstNamePlaceholder:(NSString *)text {
    [_nameTextFieldview setPlaceHolderOne:text];
}

- (void)setLastName:(NSString *)text {
    if ([DerivedNSManagedObject objectOrNil:text]) {
        [_nameTextFieldview setTextFieldTwoText:text];
    }
}

- (void)setLastNamePlaceholder:(NSString *)text {
    [_nameTextFieldview setTextFieldTwoText:text];
}

- (void)setEmailAddress:(NSString *)text {
    [_emailAddressTextFieldView setTextFielText:text];
}

- (void)setEmailAddressPlaceholder:(NSString *)text {
    [_emailAddressTextFieldView setTextFieldPlaceholder:text];
}

- (void)setTitle:(NSString *)text {
    [_titleTextFieldView setTextFielText:text];
}

- (void)setTitlePlaceholder:(NSString *)text {
    [_titleTextFieldView setTextFieldPlaceholder:text];
}

- (void)setOrganization:(NSString *)text {
    if ([DerivedNSManagedObject objectOrNil:text]) {
        CGSize size = [self totalHeightContentInTextFieldView:text];
        NSLayoutConstraint *height = _constraintOrganizationHeight;
        _constraintOrganizationHeight.constant = height.constant + size.height ;
    }
    [_organizationTextFieldView setTextFielText:text];
}

- (void)setOrganizationPlaceholder:(NSString *)text {
    [_organizationTextFieldView setTextFieldPlaceholder:text];
    
}

- (void)setPhone:(NSString *)text {
    if ([DerivedNSManagedObject objectOrNil:text]) {
        [_phoneFaxTextFieldView setTextFieldLeftText:text];
    }
}

- (void)setPhonePlaceHolder:(NSString *)text {
    [_phoneFaxTextFieldView setTextFieldLeftPlaceholder:text];
}

- (void)setFax:(NSString *)text {
    if ([DerivedNSManagedObject objectOrNil:text]) {
        [_phoneFaxTextFieldView setTextFielRightText:text];
    }
}

- (void)setFaxPlaceholder:(NSString *)text {
    [_phoneFaxTextFieldView setTextFielRightPlaceholder:text];
}

- (void)setStreetAddress:(NSString *)text {
    [_streetAddressTextFieldView setTextFielText:text];
}

- (void)setStreetAddressPlaceholder:(NSString *)text {
    [_streetAddressTextFieldView setTextFieldPlaceholder:text];
}

- (void)setCity:(NSString *)text {
    [_cityTextFieldView setTextFielText:text];
}
- (void)setCityPlaceholder:(NSString *)text {
    [_cityTextFieldView setTextFieldPlaceholder:text];
}

- (void)setState:(NSString *)text {
    if ([DerivedNSManagedObject objectOrNil:text]) {
        [_stateZipTextFieldView setTextFieldLeftText:text];
    }
}

- (void)setStatePlaceholder:(NSString *)text {
    [_stateZipTextFieldView setTextFieldLeftPlaceholder:text];
}

- (void)setZIP:(NSString *)text {
    if ([DerivedNSManagedObject objectOrNil:text]) {
        [_stateZipTextFieldView setTextFielRightText:text];
    }
}

- (void)setZIPPlaceholder:(NSString *)text {
    [_stateZipTextFieldView setTextFielRightPlaceholder:text];
}


#pragma mark - Get Text

- (NSString *)getFirstName {
    return [_nameTextFieldview getTextOne];
}
- (NSString *)getLastName {
    return [_nameTextFieldview getTextTwo];
}
- (NSString *)getEmail {
    return [_emailAddressTextFieldView getText];
}
- (NSString *)getTitle {
    return [_titleTextFieldView getText];
}
- (NSString *)getOrganization {
    return [_organizationTextFieldView getText];
}
- (NSString *)getPhone {
    return [_phoneFaxTextFieldView getTextLeft];
}
- (NSString *)getFax {
    return [_phoneFaxTextFieldView getTextRight];
}
- (NSString *)getStreetAddress {
    return [_streetAddressTextFieldView getText];
}
- (NSString *)getCity {
    return [_cityTextFieldView getText];
}
- (NSString *)getState {
    return [_stateZipTextFieldView getTextLeft];
}
- (NSString *)getZip {
    return [_stateZipTextFieldView getTextRight];
}

#pragma mark - TextFieldViewDelegate Delegate
- (void)textFieldDidBeginEditing:(UIView *)view {
    if (view == _nameTextFieldview) {
        activeView = _nameTextFieldview;
    }
    if (view == _emailAddressTextFieldView) {
        activeView = _emailAddressTextFieldView;
    }
    if (view == _titleTextFieldView) {
        activeView = _titleTextFieldView;
    }
    if (view == _organizationTextFieldView) {
        activeView = _organizationTextFieldView;
    }
    if (view == _phoneFaxTextFieldView) {
        activeView = _phoneFaxTextFieldView;
    }
    if (view == _streetAddressTextFieldView) {
        activeView = _streetAddressTextFieldView;
    }
    if (view == _cityTextFieldView) {
        activeView = _cityTextFieldView;
    }
    if (view == _stateZipTextFieldView) {
        activeView = _stateZipTextFieldView;
    }
    
    
}
- (CGSize)totalHeightContentInTextFieldView:(NSString *)text {
    UITextView *textView = [UITextView new];
    [textView setText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width, FLT_MAX)];
    
    return size;
}


#pragma mark - KeyBoard
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeView.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}



@end

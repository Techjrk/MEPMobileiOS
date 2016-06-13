//
//  MyProfileView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileView.h"
#import "myProfileConstant.h"
#import "MyProfileCustomTextFieldView.h"
#import "MyProfileOneTextFieldView.h"
#import "MyProfileTwoTextFieldView.h"
@interface MyProfileView (){
    NSDictionary *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    NSArray *headerIndex;
    NSArray *textFieldIndex;
    NSMutableArray *myProfileDataInfo;
    NSDictionary *profileInfo;
    
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



@end

@implementation MyProfileView


- (void)awakeFromNib {

    [_containerView setBackgroundColor:MYPROFILE_CONTAINERVIEW_BG_COLOR];
    [self.view setBackgroundColor:MYPROFILE_CONTAINERVIEW_BG_COLOR];
    
    [_nameTextFieldview setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_NAME")];
    [_nameTextFieldview setHideTitleRightLabel:YES];
    
    [_emailAddressTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_EMAIL_ADDRESS")];
    [_emailAddressTextFieldView setHideTitleRightLabel:YES];
    
    [_titleTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_TITLE")];
    [_titleTextFieldView setHideTitleRightLabel:YES];
    
    [_organizationTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_ORGANIZATION")];
    [_organizationTextFieldView setHideTitleRightLabel:YES];
    
    [_phoneFaxTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_PHONE")];
    [_phoneFaxTextFieldView setHideTitleRightLabel:NO];
    [_phoneFaxTextFieldView setTileRightLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_FAX")];
    
    [_streetAddressTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STREETADDRESS")];
    [_streetAddressTextFieldView setHideTitleRightLabel:YES];
    
    [_cityTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_CITY")];
    [_cityTextFieldView setHideTitleRightLabel:YES];
    
    [_stateZipTextFieldView setTileLeftLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STATE")];
    [_stateZipTextFieldView setHideTitleRightLabel:NO];
    [_stateZipTextFieldView setTileRightLabelText:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_ZIP")];
    
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
    [_nameTextFieldview setTextFieldOneText:text];
}

- (void)setLastName:(NSString *)text {
    [_nameTextFieldview setTextFieldTwoText:text];
}

- (void)setEmailAddress:(NSString *)text {
    [_emailAddressTextFieldView setTextFielText:text];
}

- (void)setTitle:(NSString *)text {
    [_titleTextFieldView setTextFielText:text];
}

- (void)setOrganization:(NSString *)text {
    [_organizationTextFieldView setTextFielText:text];
}

- (void)setPhone:(NSString *)text {
    [_phoneFaxTextFieldView setTextFieldLeftText:text];
}

- (void)setFax:(NSString *)text {
    [_phoneFaxTextFieldView setTextFielRightText:text];
}

- (void)setStreetAddress:(NSString *)text {
    [_streetAddressTextFieldView setTextFielText:text];
}

- (void)setCity:(NSString *)text {
    [_cityTextFieldView setTextFielText:text];
}

- (void)setState:(NSString *)text {
    [_stateZipTextFieldView setTextFieldLeftText:text];
}

- (void)setZIP:(NSString *)text {
    [_stateZipTextFieldView setTextFielRightText:text];
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

@end

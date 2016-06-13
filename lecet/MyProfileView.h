//
//  MyProfileView.h
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@interface MyProfileView : BaseViewClass
- (void)setFirstName:(NSString *)text;
- (void)setLastName:(NSString *)text;
- (void)setEmailAddress:(NSString *)text;
- (void)setTitle:(NSString *)text;
- (void)setOrganization:(NSString *)text;
- (void)setPhone:(NSString *)text;
- (void)setFax:(NSString *)text;
- (void)setStreetAddress:(NSString *)text;
- (void)setCity:(NSString *)text;
- (void)setState:(NSString *)text;
- (void)setZIP:(NSString *)text;

- (NSString *)getFirstName;
- (NSString *)getLastName;
- (NSString *)getEmail;
- (NSString *)getTitle;
- (NSString *)getOrganization;
- (NSString *)getPhone;
- (NSString *)getFax;
- (NSString *)getStreetAddress;
- (NSString *)getCity;
- (NSString *)getState;
- (NSString *)getZip;

- (void)setInfo:(id)info;
@end

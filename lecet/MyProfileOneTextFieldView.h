//
//  MyProfileOneTextFieldView.h
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
#import "TextfieldViewDelegate.h"
@interface MyProfileOneTextFieldView : BaseViewClass
@property (nonatomic,assign) id <TextfieldViewDelegate> textfieldViewDelegate;

- (void)setTileLeftLabelText:(NSString *)title;
- (void)setHideTitleRightLabel:(BOOL)hide;
- (void)setTextFielText:(NSString *)text;
- (void)setSecureTextField:(BOOL)secure;
- (void)setKeyBoard:(UIKeyboardType)keyBoard;
- (NSString *)getText;
- (void)setScrollableEnabled:(BOOL)enabled;
@end

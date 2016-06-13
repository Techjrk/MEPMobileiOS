//
//  MyProfileTwoTextFieldView.h
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@interface MyProfileTwoTextFieldView : BaseViewClass
- (void)setTileLeftLabelText:(NSString *)title;
- (void)setTileRightLabelText:(NSString *)title;
- (void)setHideTitleRightLabel:(BOOL)hide;
- (void)setTextFieldLeftText:(NSString *)text;
- (void)setTextFielRightText:(NSString *)text;

- (NSString *)getTextLeft;
- (NSString *)getTextRight;
@end

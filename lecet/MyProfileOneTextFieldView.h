//
//  MyProfileOneTextFieldView.h
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
@interface MyProfileOneTextFieldView : BaseViewClass
- (void)setTileLeftLabelText:(NSString *)title;
- (void)setHideTitleRightLabel:(BOOL)hide;
- (void)setTextFielText:(NSString *)text;
- (void)setSecureTextField:(BOOL)secure;

- (NSString *)getText;
@end

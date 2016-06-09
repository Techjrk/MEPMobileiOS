//
//  CPCustomTextFieldView.h
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@interface CPCustomTextFieldView : BaseViewClass
- (NSString *)text;
- (void)setText:(NSString *)text;
- (void)setSecure:(BOOL)secure;
- (void)setLefTitleText:(NSString *)title;
-(void)setPlaceHolder:(NSString *)placeHolder;

@end

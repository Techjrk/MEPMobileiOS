//
//  CustomTextField.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@interface CustomTextField : BaseViewClass
- (NSString*)text;
- (void)setText:(NSString*)text;
- (void)setSecure:(BOOL)secure;
- (void) setPlaceHolder:(NSString*)placeHolder;
@end

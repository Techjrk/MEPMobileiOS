//
//  CustonEntryField.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@interface CustomEntryField : BaseViewClass
- (void)setTitle:(NSString*)title line1Text:(NSString*)line1Text line2Text:(NSString*)line2Text;
- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
@end

//
//  MyProfileHeaderView.h
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
@interface MyProfileHeaderView : BaseViewClass

- (void)setLeftLabelText:(NSString *)text;
- (void)setRightLabelText:(NSString *)text;
- (void)hideRightLabel:(BOOL)hide;


@end

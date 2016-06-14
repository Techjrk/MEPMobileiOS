//
//  TextfieldViewDelegate.h
//  lecet
//
//  Created by Michael San Minay on 14/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TextfieldViewDelegate <NSObject>
@required
- (void)textFieldDidBeginEditing:(UIView *)view;
@end

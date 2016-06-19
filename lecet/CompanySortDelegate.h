//
//  CompanySortDelegate.h
//  lecet
//
//  Created by Michael San Minay on 19/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "companySortViewConstant.h"

@protocol CompanySortDelegate <NSObject>
- (void)selectedSort:(CompanySortItem)item;
@end

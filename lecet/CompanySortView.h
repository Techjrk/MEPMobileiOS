//
//  CompanySortView.h
//  lecet
//
//  Created by Michael San Minay on 18/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
#import "companySortViewConstant.h"
#import "CompanySortDelegate.h"


@interface CompanySortView : BaseViewClass
@property (nonatomic,assign) id <CompanySortDelegate> companySortDelegate;

@end

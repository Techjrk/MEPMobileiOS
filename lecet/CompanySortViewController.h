//
//  CompanySortViewController.h
//  lecet
//
//  Created by Michael San Minay on 19/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CompanySortView.h"

@interface CompanySortViewController : BaseViewController
@property (nonatomic,assign) id<CompanySortDelegate> companySortDelegate;

@end

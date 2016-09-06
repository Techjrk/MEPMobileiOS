//
//  ValuationViewController.h
//  lecet
//
//  Created by Michael San Minay on 01/07/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol ValuationViewControllerDelegate <NSObject>
- (void)tappedValuationApplyButton:(id)items;
@end

@interface ValuationViewController : BaseViewController
@property (nonatomic,assign) id <ValuationViewControllerDelegate> valuationViewControllerDelegate;
@property (nonatomic, strong) NSDictionary *valuationValue;

@end

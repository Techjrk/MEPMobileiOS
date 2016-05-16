//
//  ProjectDetailViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/12/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_BidRecent.h"

@interface ProjectDetailViewController : UIViewController
@property (nonatomic) CGRect previousRect;
- (void)detailsFromBid:(DB_BidRecent*)record;
@end

//
//  ProjectDetailViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/12/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_Bid.h"
#import "BaseViewController.h"

@interface ProjectDetailViewController : BaseViewController
@property (nonatomic) CGRect previousRect;
- (void)detailsFromProject:(DB_Project*)record;
@end

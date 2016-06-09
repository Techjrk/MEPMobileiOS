//
//  BidderListViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/9/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface BidderListViewController : BaseViewController
@property (nonatomic, copy) NSMutableArray *collectionItems;
@property (nonatomic, copy) NSString *projectName;
@end

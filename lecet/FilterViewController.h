//
//  FilterViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 7/1/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface FilterViewController : BaseViewController
@property (strong, nonatomic) NSMutableArray *listViewItems;
@property (weak, nonatomic) NSString *searchTitle;
@property (nonatomic) BOOL singleSelect;
@end

//
//  FilterViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 7/1/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@protocol FilterViewControllerDelegate
- (void)tappedFilterViewControllerApply:(NSMutableArray*)selectedItems key:(NSString*)key titles:(NSMutableArray*)titles;
@end

@interface FilterViewController : BaseViewController
@property (weak, nonatomic) id<FilterViewControllerDelegate>filterViewControllerDelegate;
@property (strong, nonatomic) NSMutableArray *listViewItems;
@property (weak, nonatomic) NSString *searchTitle;
@property (strong, nonatomic) NSString *fieldValue;
@property (nonatomic) BOOL singleSelect;
@end

//
//  ProjectNearMeFilterViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 1/18/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ListItemCollectionViewCell.h"

@protocol ProjectNearMeFilterViewControllerDelegate
- (void) applySearchFilter:(NSDictionary*)filter;
@end

@interface ProjectNearMeFilterViewController : BaseViewController
// Properties
@property (weak, nonatomic) id<ProjectNearMeFilterViewControllerDelegate>projectNearMeFilterViewControllerDelegate;
@property (strong, nonatomic) NSMutableDictionary *projectFilterDictionary;

@property (strong, nonatomic)ListViewItemArray *listItemsProjectStageId;
@property (strong, nonatomic)ListViewItemArray *listItemsJurisdictions;
@property (strong, nonatomic)ListViewItemArray *listItemsProjectTypeId;

@end

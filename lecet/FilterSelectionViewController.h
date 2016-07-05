//
//  FilterSelectionViewController.h
//  lecet
//
//  Created by Michael San Minay on 05/07/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    ProjectFilterItemAny = 0,
    ProjectFilterItemHours = 1,
    ProjectFilterItemDays = 2,
    ProjectFilterItemMonths = 3,
} ProjectFilterItem;

#define PROJECT_SELECTION_TITLE @"TITLE"
#define PROJECT_SELECTION_VALUE @"VALUE"
#define PROJECT_SELECTION_TYPE  @"TYPE"


@protocol FilterSelectionViewControllerDelegate <NSObject>
- (void)tappedApplyButton:(id)items;

@end

@interface FilterSelectionViewController : UIViewController

@property (nonatomic,assign) id <FilterSelectionViewControllerDelegate> filterSelectionViewControllerDelegate;

@property (nonatomic,strong) NSArray *dataInfo;
@property (nonatomic,weak) NSString *navTitle;

@end

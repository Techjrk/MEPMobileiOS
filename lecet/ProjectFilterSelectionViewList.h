//
//  ProjectFilterSelectionViewList.h
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum  {
    ProjectFilterItemAny = 0,
    ProjectFilterItemHours = 1,
    ProjectFilterItemDays = 2,
    ProjectFilterItemMonths = 3,
} ProjectFilterItem;

#define PROJECT_SELECTION_TITLE @"TITLE"
#define PROJECT_SELECTION_VALUE @"VALUE"
#define PROJECT_SELECTION_TYPE  @"TYPE"

@protocol ProjectFilterSelectionViewListDelegate <NSObject>
- (void)selectedItem:(NSDictionary *)dict;
@end

@interface ProjectFilterSelectionViewList : BaseViewClass
@property (nonatomic,assign) id <ProjectFilterSelectionViewListDelegate> projectFilterSelectionViewListDelegate;
@property (nonatomic,strong) NSDictionary *dataSelected;
- (void)setInfo:(NSArray *)item;

@end

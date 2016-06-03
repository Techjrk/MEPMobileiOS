//
//  ProjectSortView.h
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"



typedef enum  {
    ProjectSortBidDate = 0,
    ProjectSortLastUpdated = 1,
    ProjectSortDateAdded = 2,
    ProjectSortHightToLow = 3,
    ProjectSortLowToHigh = 4,
    
} ProjectSortItems;


@protocol ProjectSortViewDelegate <NSObject>

@required
-(void)selectedProjectSort:(ProjectSortItems)projectSortItem;

@end


@interface ProjectSortView : BaseViewClass
@property (nonatomic,assign) id<ProjectSortViewDelegate> projectSortViewDelegate;

@end

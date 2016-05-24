//
//  DropDownProjectList.h
//  lecet
//
//  Created by Get Devs on 20/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"


typedef enum  {
    DropDownProjectTrainAndMetros = 0,
    DropDownProjectRailways = 1,
    DropDownProjectAnotherList = 2,
    DropDownProjectHighValues = 3,
} DropDownProjectListItem;


@protocol DropDownProjectListDelegate <NSObject>

@required
- (void)tappedDropDownProjectList:(DropDownProjectListItem)projectListItem;

@end


@interface DropDownProjectList : BaseViewClass


@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfProjectsTrainsAndMetros;

@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfProjectsRailways;

@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfProjectsAnotherList;

@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfProjectHighValues;

@property (nonatomic,assign) id<DropDownProjectListDelegate> dropDownProjectListDelegate;




@end

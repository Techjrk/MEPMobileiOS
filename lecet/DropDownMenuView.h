//
//  DropDownMenuView.h
//  lecet
//
//  Created by Get Devs on 18/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"


typedef enum  {
    DropDownMenuMyProfile = 0,
    DropDownMenuHiddenProjects = 1,
    DropDownMenuSettings = 2,
} DropDownMenuItem;




@protocol DropDownMenuDelegate <NSObject>
@required
- (void)tappedDropDownMenu:(DropDownMenuItem)menuDropDownItem;

@end


@interface DropDownMenuView : BaseViewClass



@property (nonatomic,assign) id<DropDownMenuDelegate> dropDownMenuDelegate;

@end






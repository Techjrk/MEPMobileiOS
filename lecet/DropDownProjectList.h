//
//  DropDownProjectList.h
//  lecet
//
//  Created by Get Devs on 20/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol DropDownProjectListDelegate <NSObject>

@required
-(void)selectedDropDownProjectList:(NSIndexPath *)indexPath;
@end

@interface DropDownProjectList : BaseViewClass
@property (nonatomic,assign) id<DropDownProjectListDelegate> dropDownProjectListDelegate;
- (void)reloadData;



@end

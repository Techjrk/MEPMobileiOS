//
//  ProjectDetailStateView.h
//  lecet
//
//  Created by Michael San Minay on 24/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"


typedef enum  {
    ProjectDetailStateHideProject = 0,
    ProjectDetailStateCancel = 1,
} ProjectDetailStateItem;




@protocol ProjectDetailStateDelegate <NSObject>
@required
- (void)tappedProjectDetailState:(ProjectDetailStateItem)projectDetailStteItem;

@end


@interface ProjectDetailStateView : BaseViewClass
@property (nonatomic,assign) id<ProjectDetailStateDelegate> projectDetailStateDelegate;



@end

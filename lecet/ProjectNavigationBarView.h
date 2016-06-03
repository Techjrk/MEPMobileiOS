//
//  ProjectNavigationBarView.h
//  lecet
//
//  Created by Michael San Minay on 03/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"


typedef enum  {
    ProjectNavBackButton = 0,
    ProjectNavReOrder = 1,
} ProjectNavItem;

@protocol ProjectNavViewDelegate <NSObject>

@required
-(void)tappedProjectNav:(ProjectNavItem)projectNavItem;

@end
@interface ProjectNavigationBarView : BaseViewClass

- (void)setContractorName:(NSString *)contractorName;
- (void)setProjectTitle:(NSString *)projectTitle;
@property (nonatomic,assign) id<ProjectNavViewDelegate> projectNavViewDelegate;

@end

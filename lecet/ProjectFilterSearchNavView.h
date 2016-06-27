//
//  ProjectFilterSearchNavView.h
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum {
    ProjectFilterSearchNavItemBack = 0,
    ProjectFilterSearchNavItemApply =1,
}ProjectFilterSearchNavItem;

@protocol ProjectFilterSearchNavViewDelegate <NSObject>
- (void)tappedFilterSearchNavButton:(ProjectFilterSearchNavItem)item;
@end

@interface ProjectFilterSearchNavView : BaseViewClass
@property (nonatomic,assign) id <ProjectFilterSearchNavViewDelegate> projectFilterSearchNavViewDelegate;

@end

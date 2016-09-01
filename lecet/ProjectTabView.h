//
//  ProjectTabView.h
//  lecet
//
//  Created by Michael San Minay on 03/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum  {
    ProjectTabUpcoming = 0,
    ProjectTabPast = 1,
} ProjectTabItem;



@protocol ProjectTabViewDelegate <NSObject>

@required
-(void)tappedProjectTab:(ProjectTabItem)projectTabItem;

@end

@interface ProjectTabView : BaseViewClass
@property (nonatomic,assign) id<ProjectTabViewDelegate> projectTabViewDelegate;
- (void)setCounts:(NSUInteger)upcoming past:(NSUInteger)past;
@end

//
//  ProjectTrackItemView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol ProjectTrackItemViewDelegate <NSObject>
- (void)tappedButtonExpand:(id)object view:(id)view;

@end
#define kStateData                  @"kStateData"
#define kStateStatus                @"kStateStatus"
#define kStateSelected              @"kStateSelected"
#define kStateUpdateType            @"kStateUpdateType"
#define kStateExpanded              @"kStateExpanded"
#define kStateShowUpdate            @"kStateShowUpdate"

typedef enum : NSUInteger {
    ProjectTrackUpdateTypeNone = 0,
    ProjectTrackUpdateTypeNewBid = 2,
    ProjectTrackUpdateTypeNewNote = 3,
} ProjectTrackUpdateType;


@interface ProjectTrackItemView : BaseViewClass
@property (strong, nonatomic) id<ProjectTrackItemViewDelegate>projectTrackItemViewDelegate;
- (void)setInfo:(id)info;
@end

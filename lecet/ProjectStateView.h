//
//  ProjectStateView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum {
    StateViewTrack = 0,
    StateViewShare = 1,
    StateViewHide = 2
} StateView;

@protocol ProjectStateViewDelegate <NSObject>
- (void)selectedStateViewItem:(StateView)stateView;
@end

@interface ProjectStateView : BaseViewClass
@property (strong, nonatomic) id<ProjectStateViewDelegate>projectStateViewDelegate;
- (void)clearSelection;

@end

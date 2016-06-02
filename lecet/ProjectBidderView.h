//
//  ProjectBidderView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol ProjectBidderDelegate <NSObject>
- (void)tappedProjectBidder:(id)object;
- (void)tappedProjectBidSeeAll:(id)object;
@end

@interface ProjectBidderView : BaseViewClass
@property (strong, nonatomic) id<ProjectBidderDelegate>projectBidderDelegate;
- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
- (void)setItems:(NSMutableArray*)items;
@end

//
//  ProjectBidListView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol ProjectBidListDelegate <NSObject>
- (void)tappedProjectItemBidder:(id)object;
- (void)tappedProjectItemBidSeeAll:(id)object;
- (UIViewController*)itemParentController;
@end

@interface ProjectBidListView : BaseViewClass
@property (strong, nonatomic) id<ProjectBidListDelegate>projectBidListDelegate;
- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
- (void)setItems:(NSMutableArray*)items;
@end

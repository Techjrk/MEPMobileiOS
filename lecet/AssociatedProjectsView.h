//
//  AssociatedProjectsView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol AssociatedProjectDelegate <NSObject>
@required
- (void)tappededSeeAllAssociateProject;

@end


@interface AssociatedProjectsView : BaseViewClass
- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
- (void)setItems:(NSMutableArray*)items;

@property (nonatomic,assign) id<AssociatedProjectDelegate> associatedProjectDelegate;

@end

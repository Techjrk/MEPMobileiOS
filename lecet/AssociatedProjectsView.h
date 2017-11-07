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
- (void)tappedAssociatedProject:(id)object;
- (UIViewController*)parentController;
@end


@interface AssociatedProjectsView : BaseViewClass
@property (nonatomic,assign) id<AssociatedProjectDelegate> associatedProjectDelegate;

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
- (void)setItems:(NSMutableArray*)items;
@end

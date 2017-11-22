//
//  ActionView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 10/26/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol ActionViewDelegate
- (void)didSelectItem:(id)sender;
- (void)didTrackItem:(id)sender;
- (void)didShareItem:(id)sender;
- (void)didHideItem:(id)sender;
- (void)didExpand:(id)sender;
- (void)undoHide:(id)sender;
@end

@interface ActionView : BaseViewClass {
}
@property (strong, nonatomic) id<ActionViewDelegate> actionViewDelegate;
@property (strong, nonatomic) NSLayoutConstraint *constraintHorizontal;
@property (strong, nonatomic) UIView *viewContainer;
- (void)swipeExpand:(UISwipeGestureRecognizerDirection)direction;
- (void)itemHidden:(BOOL)hidden;
- (UIView*)trackButton;
- (UIView*)shareButton;
- (void)resetStatus;
- (void)setUndoLabelTextColor:(UIColor*)color;
- (void)disableHide;
@end

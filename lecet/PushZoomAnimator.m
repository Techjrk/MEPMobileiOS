//
//  PushZoomAnimator.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/19/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "PushZoomAnimator.h"

@implementation PushZoomAnimator
@synthesize startRect;
@synthesize endRect;
@synthesize willPop;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    [transitionContext containerView].bounds = [[UIScreen mainScreen] bounds];
    UIViewController *controller;
    if (!willPop) {
        controller = toViewController;
        [[transitionContext containerView] addSubview:fromViewController.view];
        [[transitionContext containerView] addSubview:controller.view];
        [controller.view setClipsToBounds:YES];
        controller.view.frame = startRect;
    } else {
        controller = fromViewController;
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] addSubview:controller.view];
        controller.view.frame = startRect;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        controller.view.frame = endRect;
        
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
        if (finished) {
            [transitionContext completeTransition:finished];
        }
        
    }];
    
    
}

@end

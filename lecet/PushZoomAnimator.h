//
//  PushZoomAnimator.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/19/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PushZoomAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic) CGRect startRect;
@property (nonatomic) CGRect endRect;
@property (nonatomic) BOOL willPop;
@end

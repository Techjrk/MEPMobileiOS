//
//  DMDViewerController.h
//
//  Created by AMS on 10/16/13.
//  Copyright (c) 2013 Dermandar. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class EAGLView;

@interface DMDViewerController : UIViewController <UIGestureRecognizerDelegate>
{
@private
    CADisplayLink *displayLink;
	NSMutableArray *curTouches;

    BOOL animating;
	BOOL initAfterLoading;
	BOOL allowmove,loadingInProgress,blocked;
	CGFloat fov_scale,idst,cdst;
	NSInteger ntouches,aT;
    int w,h,mts;
    float sc;
}

@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) NSString *text;

- (void)startAnimation;
- (void)stopAnimation;

+ (EAGLContext*)defaultContext;

- (bool)loadPanoramaFromUIImage:(UIImage*)image;                        // fovx will be estimated.
- (bool)loadPanoramaFromUIImage:(UIImage*)image fovx:(int)fx;           // to use a specific fovx.
- (bool)loadSphericalPanoramaFromUIImage:(UIImage*)image;

@end

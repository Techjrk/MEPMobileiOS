//
//  CustomCameraViewController.h
//  lecet
//
//  Created by Michael San Minay on 16/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraControlListViewItem.h"

@protocol CustomCameraViewControllerDelegate <NSObject>
@required
- (void)tapppedTakePhoto;
- (void)tappedCameraSwitch;
- (void)tappedFlash;
- (void)tappedCancel;
- (void)customCameraControlListDidSelect:(id)info;
- (void)customCameraPhotoLibDidSelect:(UIImage*)image;
- (void)customPanoImageTaken:(UIImage*)image;
@end

@interface CustomCameraViewController : UIViewController
@property (strong,nonatomic) id<CustomCameraViewControllerDelegate> customCameraViewControllerDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage;
@property (strong,nonatomic) UIViewController *controller;
- (void)setFlashOn:(BOOL)on;
@end

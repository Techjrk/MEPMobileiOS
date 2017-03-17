//
//  CustomCamera.m
//  lecet
//
//  Created by Michael San Minay on 16/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CustomCamera.h"
#import "CustomCameraViewController.h"

static CustomCamera *_instance = nil;
@interface CustomCamera() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *picker;
@end

@implementation CustomCamera

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
   
    //[self.layer setOpaque:YES];
    
    return self;
}

- (void)showCamera{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    
   
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.extendedLayoutIncludesOpaqueBars = YES;
    self.picker.edgesForExtendedLayout = YES;
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
    self.picker.cameraViewTransform = translate;
    
    //picker.cameraViewTransform = CGAffineTransformMakeScale(1.0, 1.03);
    /*
     CGSize screenSize = [[UIScreen mainScreen] bounds].size;
     int heightOffset = 0;
     float cameraAspectRatio = 4.0 / 3.0; //! Note: 4.0 and 4.0 works
     float imageWidth = floorf(screenSize.width * cameraAspectRatio);
     float scale = ceilf(((screenSize.height + heightOffset) / imageWidth) * 10.0) / 10.0;
     picker.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
     */
    
    CustomCameraViewController *ccController =  [CustomCameraViewController new];
    UIView *customView = ccController.view;
    customView.frame = self.picker.view.frame;
    self.picker.cameraOverlayView = customView;
    self.picker.delegate = self;
    [self presentImagePickerController:self.picker];

}

- (void)presentImagePickerController:(UIViewController *)pickerController
{
    if (self.controller.presentedViewController) {
        [self.controller.presentedViewController presentViewController:pickerController animated:YES completion:^{}];
    } else {
        [self.controller.navigationController presentViewController:pickerController animated:YES completion:^{}];
    }
}




@end

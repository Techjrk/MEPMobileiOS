//
//  CustomCamera.m
//  lecet
//
//  Created by Michael San Minay on 15/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CustomCamera.h"

static CustomCamera *_instance = nil;

@interface CustomCamera ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
    
    [self.layer setOpaque:NO];
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.showsCameraControls = NO;
    self.picker.cameraOverlayView = self;
    self.picker.delegate = self;
    
    return self;
}

- (void)captureCamera {
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self.controller.navigationController presentViewController:self.picker animated:YES completion:nil];
}


@end

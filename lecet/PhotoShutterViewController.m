//
//  PhotoShutterViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/11/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "PhotoShutterViewController.h"

#import "DMD_LITE.h"
#import "CustomCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PanoramaSceneViewController.h"
#import "CustomLandscapeNavigationViewController.h"
#import <Photos/Photos.h>

@class PHLivePhotoView;

@interface PhotoShutterViewController ()<MonitorDelegate,PanoramaSceneViewControllerDelegate>{
    BOOL is360Selected;
    UIImage *capturedImage;
}

@property (nonatomic) BOOL isFlashOn;
@property (nonatomic) NSInteger maxFrame;
@property (nonatomic) NSInteger frameCount;
@property (strong, nonatomic) NSNumber *mode;
@property (strong, nonatomic) IBOutlet ShooterView *shooterView;
@property (strong, nonatomic) CustomLandscapeNavigationViewController *navPanoramaViewer;

@end

@implementation PhotoShutterViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFlashOn = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartShutterNotification:) name:RESTART_SHUTTER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopShutterNotification:) name:STOP_SHUTTER object:nil];
    self.maxFrame =is360Selected?12:6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [self restart];
    [super viewDidAppear:animated];
}

- (void)loadView {

    [Monitor instance].delegate = self;
    
    CGRect frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    UIView *aView = [[UIView alloc] initWithFrame:frame];
    aView.backgroundColor = [UIColor blackColor];
    self.view = aView;
    
    self.shooterView = [[ShooterView alloc] initWithFrame:frame];
    [aView addSubview:self.shooterView];

    NSArray *flashControls = [self.shooterView subviews];
    [self.shooterView setFlashOff:nil];
    for (UIView *view in flashControls) {
        view.hidden = YES;
    }
    
}

- (void)restartShutterNotification:(NSNotification*)notification {
    if (!self.view.hidden) {
        [self restart];
    }
}

- (void)stopShutterNotification:(NSNotification*)notification {
    if (!self.view.hidden) {
        [self stopShutter];
    }
}

- (void)savePhoto {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *imageName = [dateFormatter stringFromDate:[NSDate date]];
    [[NSFileManager defaultManager] createDirectoryAtPath:TMP_DIR withIntermediateDirectories:YES attributes:nil error:NULL];

    NSString *ename = [TMP_DIR stringByAppendingPathComponent:[imageName stringByAppendingString:@".jpeg"]];
   
    [[Monitor instance] genEquiAt:ename withHeight:kDeviceHeight andWidth:0 andMaxWidth:0];
    
    __block PHObjectPlaceholder *placeholder;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:ename]]];
        placeholder = [createAssetRequest placeholderForCreatedAsset];
        
    } completionHandler:^(BOOL success, NSError *error) {
        if (success)
        {
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO],];
            
            PHFetchResult<PHAsset *>  *assets = [PHAsset fetchAssetsWithOptions:options];
            PHCachingImageManager *imageManager = [PHCachingImageManager new];
            PHAsset *assetTemp = assets[0];
            
            [imageManager requestImageForAsset:assetTemp targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                capturedImage  = result;
            }];
        
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
    
}

- (void)setIs360Selected:(BOOL)selected {
    is360Selected = selected;
    self.maxFrame =is360Selected?12:6;
    self.frameCount = 0;
    [self restart];
}

#pragma mark - MonitorDelegate

- (void)preparingToShoot {
    
}

- (void)canceledPreparingToShoot {

}

- (void)takingPhoto {
    
    UIView *camView = self.view;
    self.view.window.backgroundColor = [UIColor whiteColor];
    camView.alpha = 0.1f;
    [UIView animateWithDuration:0.6 animations:^{
        camView.alpha = 1.f;
    } completion:^(BOOL finished) {
        self.view.window.backgroundColor = [UIColor blackColor];
    }];
     
}

- (void)photoTaken {
    self.frameCount++;
    if (self.frameCount == self.maxFrame) {
        [self finishCapturing];
    }
}

- (void)stitchingCompleted:(NSDictionary *)dict {
    [self savePhoto];
    
    PanoramaSceneViewController *controller = [PanoramaSceneViewController new];
    controller.panoramaViewerViewControllerDelegate = self;
    CustomLandscapeNavigationViewController *nav = [[CustomLandscapeNavigationViewController alloc] initWithRootViewController:controller];
    nav.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    self.navPanoramaViewer = nav;
    [self.controller.view addSubview:self.navPanoramaViewer.view];
    [self.controller.view bringSubviewToFront:self.navPanoramaViewer.view];
}

- (void)shootingCompleted {
}

- (void)deviceVerticalityChanged:(NSNumber *)isVertical {
}

- (void)compassEvent:(NSDictionary *)info {
}

#pragma mark - SDK Interaction
- (void)restart {
    [[Monitor instance] restart];
}

#pragma mark - CustomCameraViewControllerDelegate
- (void)stopCapture {
    [[Monitor instance] stopShooting];
}

- (void)finishCapturing {
    if (self.frameCount == self.maxFrame) {
        [[Monitor instance] finishShooting];
    }
}

- (void)tappedTakePanoramaPhoto {
    [[Monitor instance] startShooting];
}

- (void)startShutter {
    [self restart];
}

- (void)stopShutter {
    [self stopCapture];
}


#pragma mark - PanoramaViewerViewControllerDelegate
- (void)tappedDoneButtonPanoramaViewer {
    [self.navPanoramaViewer.view removeFromSuperview];
    __weak __typeof(self)wSelf = self;
    [wSelf.photoShutterViewControllerDelegate photoTaken:capturedImage];
}
@end

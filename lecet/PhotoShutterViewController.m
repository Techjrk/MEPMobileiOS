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
#import "PanoramaViewerViewController.h"
#import "CustomLandscapeNavigationViewController.h"

#define TMP_DIR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"DMD_tmp"]

@class PHLivePhotoView;

@interface PhotoShutterViewController ()<MonitorDelegate>{
    BOOL is360Selected;
}

@property (nonatomic) BOOL isFlashOn;
@property (nonatomic) NSInteger maxFrame;
@property (nonatomic) NSInteger frameCount;
@property (strong, nonatomic) NSNumber *mode;
@property (strong, nonatomic) IBOutlet ShooterView *shooterView;

@end

@implementation PhotoShutterViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFlashOn = NO;
    
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

- (void)savePhoto {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *imageName = [dateFormatter stringFromDate:[NSDate date]];
    [[NSFileManager defaultManager] createDirectoryAtPath:TMP_DIR withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString *ename = [TMP_DIR stringByAppendingPathComponent:imageName];
    [[Monitor instance] genEquiAt:ename withHeight:800 andWidth:0 andMaxWidth:0];

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:[NSData dataWithContentsOfFile:ename] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (assetURL)
        {
            __weak __typeof(self)wSelf = self;
            [self latestPhotoWithCompletion:^(UIImage *photo) {
                
                UIImageRenderingMode renderingMode = /* DISABLES CODE */ (YES) ? UIImageRenderingModeAlwaysOriginal : UIImageRenderingModeAlwaysTemplate;
                [wSelf.photoShutterViewControllerDelegate photoTaken:[photo imageWithRenderingMode:renderingMode]];
                
            }];
        }
        else if (error)
        {
            if (error.code == ALAssetsLibraryAccessUserDeniedError || error.code == ALAssetsLibraryAccessGloballyDeniedError)
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Permission needed to access camera roll." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
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
    //[self savePhoto];
    if (self.frameCount == self.maxFrame) {
        [self finishCapturing];
    }
    
}

- (void)stitchingCompleted:(NSDictionary *)dict {
    [self savePhoto];
    
    PanoramaViewerViewController *controller = [PanoramaViewerViewController new];
    UINavigationController *nav = [[CustomLandscapeNavigationViewController alloc] initWithRootViewController:controller];
    [self.controller presentViewController:nav animated:YES completion:nil];
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

#pragma mark - MISC
- (void)latestPhotoWithCompletion:(void (^)(UIImage *photo))completion
{
    
    ALAssetsLibrary *library=[[ALAssetsLibrary alloc] init];
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // For this example, we're only interested in the last item [group numberOfAssets]-1 = last.
        if ([group numberOfAssets] > 0) {
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:0
                                 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                     // The end of the enumeration is signaled by asset == nil.
                                     if (alAsset) {
                                         ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                         // Do something interesting with the AV asset.
                                         UIImage *img = [UIImage imageWithCGImage:[representation fullScreenImage]];
                                         
                                         // completion
                                         completion(img);
                                         
                                         // we only need the first (most recent) photo -- stop the enumeration
                                         *innerStop = YES;
                                     }
                                 }];
        }
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
    }];
    
    
}

@end

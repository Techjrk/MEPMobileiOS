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

@class PHLivePhotoView;

@interface PhotoShutterViewController ()<MonitorDelegate>

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
    
    self.frameCount =+ 1;
    
    if (self.frameCount>self.maxFrame) {
        [self stopCapture];
    }
    
}

- (void)stitchingCompleted:(NSDictionary *)dict {
    
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

- (void)tapppedTakePhoto {
    
    [[Monitor instance] startShooting];

}

- (void)startShutter {
    [self restart];
}

- (void)stopShutter {
    [self stopCapture];
}

@end

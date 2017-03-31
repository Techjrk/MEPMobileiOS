//
//  CustomCameraViewController.m
//  lecet
//
//  Created by Michael San Minay on 16/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CustomCameraViewController.h"
#import "CustomCameraCollectionViewCell.h"
#import "CameraControlListView.h"
#import "CustomPhotoLibView.h"
#import "CameraRadialView.h"
 
#pragma mark - FONT
#define FONT_NAV_TITLE_LABEL            fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define FONT_TILE                       fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define FONT_NAV_BUTTON                 fontNameWithSize(FONT_NAME_LATO_BOLD, 16)

#pragma mark - COLOR
#define COLOR_FONT_NAV_TITLE_LABEL      RGB(255,255,255)
#define COLOR_BG_NAV_VIEW               RGB(5, 35, 74)
#define COLORGRADIENT_BG_NAV_VIEW       @[(id)RGB(21, 78, 132).CGColor, (id)RGB(3, 35, 77).CGColor]
#define COLOR_FONT_TILE                 RGB(8, 73, 124)
#define COLOR_BG_BOTTOM_VIEW            RGB(5, 35, 74)
#define COLOR_FONT_NAV_BUTTON           RGB(168,195,230)

@interface CustomCameraViewController ()<CameraControlListViewDelegate,CustomPhotoLibViewDelegate>{
    BOOL isLibrarySelected;
    BOOL isPhotoSelected;
}
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraSwitchButton;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *navCancelButton;
@property (weak, nonatomic) IBOutlet CameraControlListView *cameraControlListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriantCollectionHeight;
@property (weak, nonatomic) IBOutlet UIView *customPhotoLibraryContainer;
@property (weak, nonatomic) IBOutlet CustomPhotoLibView *customPhotoLibView;
@property (weak, nonatomic) IBOutlet CameraRadialView *backgroundView;

@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navTitleLabel.text = NSLocalizedLanguage(@"CCVC_TITLE");
    self.navTitleLabel.font = FONT_NAV_TITLE_LABEL;
    self.navTitleLabel.textColor = COLOR_FONT_NAV_TITLE_LABEL;
    
    [self setNavBottomViewClearColor:NO];
    
    self.backgroundView.hidden = YES;
 
    [self.navCancelButton setTitle:NSLocalizedLanguage(@"CCVC_CANCEL") forState:UIControlStateNormal];
    self.navCancelButton.titleLabel.font = FONT_NAV_BUTTON;
    [self.navCancelButton setTitleColor:COLOR_FONT_NAV_BUTTON forState:UIControlStateNormal];
   
    NSArray *cameraItems = [self firstSetCameraItems];
    
    self.cameraControlListView.cameraControlListViewDelegate = self;
    self.cameraControlListView.focusOnItem = CameraControlListViewPhoto;
    [self.cameraControlListView setCameraItemsInfo:cameraItems hideLineView:YES];
    
    self.customPhotoLibView.customPhotoLibViewDelegate = self;
    self.customPhotoLibView.hidden = YES;
    self.customPhotoLibView.backgroundColor = [UIColor clearColor];
    
    self.capturedImage.hidden = YES;
    
    self.constriantCollectionHeight.constant = kDeviceHeight * 0.1;
    
    isLibrarySelected = NO;
    isPhotoSelected = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Camera Controls Button

- (void)hideDefaultCameraControl:(BOOL)hide {
    
    self.cameraSwitchButton.hidden = hide;
    self.flashButton.hidden = hide;
    self.takePhotoButton.hidden = hide;

    self.capturedImage.hidden = !hide;

    NSArray *cameraItems = hide?[self secondSetCameraItems]: [self firstSetCameraItems];
    self.cameraControlListView.isImageCaptured = hide;
    self.cameraControlListView.focusOnItem = hide?CameraControlListViewPreview:CameraControlListViewPhoto;
    [self.cameraControlListView setCameraItemsInfo:cameraItems hideLineView:hide?NO:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.constriantCollectionHeight.constant = hide?kDeviceHeight * 0.2:kDeviceHeight * 0.1;
        [self.view layoutIfNeeded];
    }];
    
}

- (void)hideLibraryControl:(BOOL)hide {
    self.cameraSwitchButton.hidden = hide?YES:NO;
    self.flashButton.hidden = hide?YES:NO;
    self.takePhotoButton.hidden = hide?YES:NO;
    
    self.capturedImage.hidden = hide;
    
    
    NSArray *cameraItems = hide?[self firstSetCameraItems]: [self itemsOnceImageSelected];
    self.cameraControlListView.isImageCaptured = !hide;
    self.cameraControlListView.focusOnItem = hide?CameraControlListViewLibrary:CameraControlListViewPreview;
    [self.cameraControlListView setCameraItemsInfo:cameraItems hideLineView:hide];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.constriantCollectionHeight.constant = !hide?kDeviceHeight * 0.2:kDeviceHeight * 0.1;
        [self.view layoutIfNeeded];
    }];
    
}

- (IBAction)tappedCancelButton:(id)sender {
    self.capturedImage.image = nil;
    self.capturedImage.hidden = YES;
    [self.customCameraViewControllerDelegate tappedCancel];
    [self removeFromParentViewController];
}

- (IBAction)tappedTakePhotoButton:(id)sender {
    [self.customCameraViewControllerDelegate tapppedTakePhoto];
    
    [self hideDefaultCameraControl:YES];
    
}
- (IBAction)tappedFlashButton:(id)sender {
    [self.customCameraViewControllerDelegate tappedFlash];
}
- (IBAction)tappedCameraSwitchButton:(id)sender {
    [self.customCameraViewControllerDelegate tappedCameraSwitch];
}

#pragma mark - CameraControlListDelegate
- (void)cameraControlListDidSelect:(id)info {
    
    if (info != nil && ![info isEqual:@""]) {
        CameraControlListViewItems items = (CameraControlListViewItems)[info[@"type"] intValue];
        switch (items) {
            case CameraControlListViewPreview : {
                isLibrarySelected = NO;
                isPhotoSelected = NO;
                [self setNavBottomViewClearColor:NO];
                break;
            }
            case CameraControlListViewUse: {
                isLibrarySelected = NO;
                isPhotoSelected = NO;
                [self setNavBottomViewClearColor:NO];
                break;
            }
            case CameraControlListViewRetake: {
                self.customPhotoLibView.hidden = NO;
                isLibrarySelected = NO;
                isPhotoSelected = NO;
                [self hideDefaultCameraControl:NO];
                [self setNavBottomViewClearColor:NO];
                break;
            }
            case CameraControlListViewPano: {
                isLibrarySelected = NO;
                isPhotoSelected = NO;
                [self setNavBottomViewClearColor:NO];
                break;
            }
            case CameraControlListViewPhoto: {
                if (!isPhotoSelected) {
                    self.customPhotoLibView.hidden = YES;
                    isLibrarySelected = NO;
                    isPhotoSelected = YES;
                    [self hideDefaultCameraControl:NO];
                    [self setNavBottomViewClearColor:NO];
                }
                break;
            }
            case CameraControlListViewLibrary: {
                if (!isLibrarySelected) {
                    self.customPhotoLibView.hidden = NO;
                    self.capturedImage.hidden = YES;
                    isLibrarySelected = YES;
                    isPhotoSelected = NO;
                    [self hideLibraryControl:YES];
                    [self setNavBottomViewClearColor:YES];
                }
                break;
            }
            case CameraControlListView360: {
                isLibrarySelected = NO;
                isPhotoSelected = NO;
                [self setNavBottomViewClearColor:NO];
                break;
            }
            default: {
               
                break;
            }
        }
    }
    
    [self.customCameraViewControllerDelegate customCameraControlListDidSelect:info];
}

#pragma mark - CustomPhotoLibDelegate
- (void)customPhotoLibDidSelect:(UIImage *)image {
    self.customPhotoLibView.hidden  = YES;
    self.capturedImage.hidden = NO;
    if (isLibrarySelected) {
        NSArray *cameraItems = [self itemsOnceImageSelected];
        self.cameraControlListView.isImageCaptured = YES;
        self.cameraControlListView.focusOnItem = CameraControlListViewPreview;
        [self.cameraControlListView setCameraItemsInfo:cameraItems hideLineView:NO];
    }
    [self.customCameraViewControllerDelegate customCameraPhotoLibDidSelect:image];
    [UIView animateWithDuration:0.5 animations:^{
        self.constriantCollectionHeight.constant = kDeviceHeight * 0.2;
        [self.view layoutIfNeeded];
    }];

    
    
}

#pragma mark - MISC Method
- (NSArray*)firstSetCameraItems {
    NSArray *cameraItems = @[@"",@{@"title":NSLocalizedLanguage(@"CCVC_LIBRARY"),@"type":@(CameraControlListViewLibrary)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_PHOTO"),@"type":@(CameraControlListViewPhoto)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_PANO"),@"type":@(CameraControlListViewPano)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_360"),@"type":@(CameraControlListView360)},@""];
    
    return cameraItems;
}

- (NSArray *)secondSetCameraItems {
    NSArray *cameraItems = @[
                             @{@"title":NSLocalizedLanguage(@"CCVC_RETAKE"),@"type":@(CameraControlListViewRetake)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_PREVIEW"),@"type":@(CameraControlListViewPreview)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_USE"),@"type":@(CameraControlListViewUse)}
                             ];
    
    return cameraItems;
    
}

- (NSArray *)itemsOnceImageSelected {
    NSArray *cameraItems = @[
                             @{@"title":NSLocalizedLanguage(@"CCVC_LIBRARY"),@"type":@(CameraControlListViewLibrary)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_PREVIEW"),@"type":@(CameraControlListViewPreview)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_USE"),@"type":@(CameraControlListViewUse)}
                             ];
    
    return cameraItems;

}

- (void)setNavBottomViewClearColor:(BOOL)clear {
    if (clear) {
        self.navView.backgroundColor = [UIColor clearColor];
        self.bottomView.backgroundColor = [UIColor clearColor];
        self.backgroundView.hidden = NO;
    } else {
        self.navView.backgroundColor = COLOR_BG_NAV_VIEW;
        self.bottomView.backgroundColor = COLOR_BG_BOTTOM_VIEW;
        self.backgroundView.hidden = YES;
    }
}

@end

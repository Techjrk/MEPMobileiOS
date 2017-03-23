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
 
#pragma mark - FONT
#define FONT_NAV_TITLE_LABEL            fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define FONT_TILE                       fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define FONT_NAV_BUTTON                 fontNameWithSize(FONT_NAME_LATO_BOLD, 16)

#pragma mark - COLOR
#define COLOR_FONT_NAV_TITLE_LABEL      RGB(184,184,184)
#define COLOR_BG_NAV_VIEW               RGB(5, 35, 74)
#define COLOR_FONT_TILE                 RGB(8, 73, 124)
#define COLOR_BG_BOTTOM_VIEW            RGB(5, 35, 74)
#define COLOR_FONT_NAV_BUTTON           RGB(168,195,230)

@interface CustomCameraViewController ()<CameraControlListViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraSwitchButton;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *navCancelButton;
@property (weak, nonatomic) IBOutlet CameraControlListView *cameraControlListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriantCollectionHeight;


@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navTitleLabel.text = NSLocalizedLanguage(@"CCVC_TITLE");
    self.navTitleLabel.font = FONT_NAV_TITLE_LABEL;
    self.navTitleLabel.textColor = COLOR_FONT_NAV_TITLE_LABEL;
    
    self.navView.backgroundColor = COLOR_BG_NAV_VIEW;
    self.bottomView.backgroundColor = COLOR_BG_BOTTOM_VIEW;
    
    [self.navCancelButton setTitle:NSLocalizedLanguage(@"CCVC_CANCEL") forState:UIControlStateNormal];
    self.navCancelButton.titleLabel.font = FONT_NAV_BUTTON;
    [self.navCancelButton setTitleColor:COLOR_FONT_NAV_BUTTON forState:UIControlStateNormal];
   
    NSArray *cameraItems = [self firstSetCameraItems];
    
    self.cameraControlListView.cameraControlListViewDelegate = self;
    self.cameraControlListView.focusOnItem = CameraControlListViewPhoto;
    [self.cameraControlListView setCameraItemsInfo:cameraItems];
    
    self.capturedImage.hidden = YES;
    
    self.constriantCollectionHeight.constant = kDeviceHeight * 0.1;
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
    self.constriantCollectionHeight.constant = hide?kDeviceHeight * 0.2:kDeviceHeight * 0.1;
    
    NSArray *cameraItems = hide?[self secondSetCameraItems]: [self firstSetCameraItems];
    self.cameraControlListView.isImageCaptured = hide;
    self.cameraControlListView.focusOnItem = hide?CameraControlListViewPreview:CameraControlListViewPhoto;
    [self.cameraControlListView setCameraItemsInfo:cameraItems];
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
                
                break;
            }
            case CameraControlListViewUse: {

                break;
            }
            case CameraControlListViewRetake: {
                [self hideDefaultCameraControl:NO];
                break;
            }
            case CameraControlListViewPano: {
                
                break;
            }
            case CameraControlListViewPhoto: {
                
                break;
            }
            case CameraControlListViewLibrary: {
                
                break;
            }
            case CameraControlListView360: {
                
                break;
            }
            default: {
               
                break;
            }
        }
    }
    
    [self.customCameraViewControllerDelegate customCameraControlListDidSelect:info];
}

#pragma mark - MISC Method

- (NSArray*)firstSetCameraItems {
    NSArray *cameraItems = @[@"",@{@"title":NSLocalizedLanguage(@"CCVC_LIBRARY"),@"type":@(CameraControlListViewLibrary)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_PHOTO"),@"type":@(CameraControlListViewPhoto)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_PANO"),@"type":@(CameraControlListViewPano)},
                             @{@"title":NSLocalizedLanguage(@"CCVC_360"),@"type":@(CameraControlListViewPano)},@""];
    
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

@end

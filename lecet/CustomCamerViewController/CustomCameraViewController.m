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

@interface CustomCameraViewController ()
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *splashButton;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *navCancelButton;
@property (weak, nonatomic) IBOutlet CameraControlListView *cameraControlListView;


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
    
    NSArray *cameraItems = @[@"",NSLocalizedLanguage(@"CCVC_LIBRARY"),NSLocalizedLanguage(@"CCVC_PHOTO"),NSLocalizedLanguage(@"CCVC_PANO"),NSLocalizedLanguage(@"CCVC_360"),@""];
    [self.cameraControlListView setCameraItemsInfo:cameraItems];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Camera Controls Button
- (IBAction)tappedCancelButton:(id)sender {
}

- (IBAction)tappedTakePhotoButton:(id)sender {
}
- (IBAction)tappedSplashButton:(id)sender {
}
@end

//
//  CustomPhotoLibraryViewController.m
//  lecet
//
//  Created by Michael San Minay on 23/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CustomPhotoLibraryViewController.h"
#import "CustomPhotoLibraryCollectionViewCell.h"
#import "CameraControlListView.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#define kCellIdentifier                     @"kCellIdentifier"

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

#define cellSpace                       kDeviceWidth * 0.05

@interface CustomPhotoLibraryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,CameraControlListViewDelegate,PHPhotoLibraryChangeObserver,CameraControlListViewDelegate>{
    BOOL isLibrarySelected;
}
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *navCancelButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet CameraControlListView *cameraControlListView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImageView;

@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *fetchresult;
@property (strong, nonatomic) PHCachingImageManager *imageManager;

@end

@implementation CustomPhotoLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerNib:[UINib nibWithNibName:[[CustomPhotoLibraryCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    self.navTitleLabel.text = NSLocalizedLanguage(@"CPLVC_TITLE");
    self.navTitleLabel.font = FONT_NAV_TITLE_LABEL;
    self.navTitleLabel.textColor = COLOR_FONT_NAV_TITLE_LABEL;
    
    self.navView.backgroundColor = [UIColor clearColor]; //COLOR_BG_NAV_VIEW;
    self.bottomView.backgroundColor = [UIColor clearColor]; //COLOR_BG_BOTTOM_VIEW;
    
    self.capturedImageView.hidden = YES;
    
    [self.navCancelButton setTitle:NSLocalizedLanguage(@"CPLVC_CANCEL") forState:UIControlStateNormal];
    self.navCancelButton.titleLabel.font = FONT_NAV_BUTTON;
    [self.navCancelButton setTitleColor:COLOR_FONT_NAV_BUTTON forState:UIControlStateNormal];
    
    NSArray *items = [self firstSetCameraItems];
    self.cameraControlListView.cameraControlListViewDelegate = self;
    self.cameraControlListView.focusOnItem = CameraControlListViewLibrary;
    [self.cameraControlListView setCameraItemsInfo:items hideLineView:NO];
    
    isLibrarySelected = NO;
    
    self.imageManager = [PHCachingImageManager new];

    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    if (self.fetchresult == nil) {
        PHFetchOptions *options = [PHFetchOptions new];
        //options.sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
        self.fetchresult = [PHAsset fetchAssetsWithOptions:options];
        [self.collectionView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBActions
- (IBAction)tappedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Photo LibraryDelegate
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
}


#pragma mark - UICollectionViewDelegate and DataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.fetchresult.count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomPhotoLibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.fetchresult[indexPath.row];
    CGSize size=CGSizeMake(90, 90);
    [self.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.imageView.image = result;
    }];
    
    //cell.imageView.image = [UIImage imageNamed:@"icon_app"];
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    CGFloat sizeAspectRatio = self.collectionView.frame.size.width * 0.25;
    size = CGSizeMake(sizeAspectRatio,sizeAspectRatio);
    return size;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(cellSpace,cellSpace,cellSpace,cellSpace);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return cellSpace;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.fetchresult[indexPath.row];

    CGRect imageFrame = self.capturedImageView.frame;
    CGSize size=CGSizeMake(imageFrame.size.width, imageFrame.size.height);
    [self.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *resultImage, NSDictionary *info) {
        self.capturedImageView.hidden = NO;
        self.capturedImageView.image = resultImage;
        
        NSArray *items = [self secondSetCameraItems];
        self.cameraControlListView.focusOnItem = CameraControlListViewPreview;
        [self.cameraControlListView setCameraItemsInfo:items hideLineView:NO];
        isLibrarySelected = NO;
        [self.customPhotoLibraryViewControllerDelegate customCameraPhotoLibDidSelect:resultImage];
    }];
}
#pragma mark - CameraControlListDelegate
- (void)cameraControlListDidSelect:(id)info{
    if (info != nil && ![info isEqual:@""]) {
        CameraControlListViewItems items = (CameraControlListViewItems)[info[@"type"] intValue];
        switch (items) {
            case CameraControlListViewPreview : {
                isLibrarySelected = NO;
                break;
            }
            case CameraControlListViewUse: {
                isLibrarySelected = NO;
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.customPhotoLibraryViewControllerDelegate customCameraControlListDidSelect:info];
                }];
                break;
            }
            case CameraControlListViewRetake: {
                isLibrarySelected = NO;
                break;
            }
            case CameraControlListViewPano: {
                isLibrarySelected = NO;
                break;
            }
            case CameraControlListViewPhoto: {
                isLibrarySelected = NO;
                break;
            }
            case CameraControlListViewLibrary: {
                if (!isLibrarySelected) {
                    self.capturedImageView.hidden = YES;
                    self.capturedImageView.image = nil;
                    
                    NSArray *items = [self firstSetCameraItems];
                    self.cameraControlListView.focusOnItem = CameraControlListViewLibrary;
                    [self.cameraControlListView setCameraItemsInfo:items hideLineView:NO];
                    isLibrarySelected = YES;
                    
                }
                
                break;
            }
            case CameraControlListView360: {
                isLibrarySelected = NO;
                break;
            }
            default: {
                
                break;
            }
        }
    }

}

#pragma mark - MISC Method

- (NSArray*)firstSetCameraItems {
    NSArray *cameraItems = @[@"",@{@"title":NSLocalizedLanguage(@"CPLVC_LIBRARY"),@"type":@(CameraControlListViewLibrary)},
                             @{@"title":NSLocalizedLanguage(@"CPLVC_PHOTO"),@"type":@(CameraControlListViewPhoto)},
                             @{@"title":NSLocalizedLanguage(@"CPLVC_PANO"),@"type":@(CameraControlListViewPano)},
                             @{@"title":NSLocalizedLanguage(@"CPLVC_360"),@"type":@(CameraControlListViewPano)},@""];
    
    return cameraItems;
}

- (NSArray *)secondSetCameraItems {
    NSArray *cameraItems = @[
                             @{@"title":NSLocalizedLanguage(@"CPLVC_LIBRARY"),@"type":@(CameraControlListViewLibrary)},
                             @{@"title":NSLocalizedLanguage(@"CPLVC_PREVIEW"),@"type":@(CameraControlListViewPreview)},
                             @{@"title":NSLocalizedLanguage(@"CPLVC_USE"),@"type":@(CameraControlListViewUse)}
                             ];
    
    return cameraItems;
    
}



@end

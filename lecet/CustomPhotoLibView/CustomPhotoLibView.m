//
//  CustomPhotoLibView.m
//  lecet
//
//  Created by Michael San Minay on 24/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CustomPhotoLibView.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "CustomPhotoLibraryCollectionViewCell.h"

#define kCellIdentifier                     @"kCellIdentifier"
#define cellSpace                           kDeviceWidth * 0.05

@interface CustomPhotoLibView ()<UICollectionViewDelegate, UICollectionViewDataSource,PHPhotoLibraryChangeObserver>
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *fetchresult;
@property (strong, nonatomic) PHCachingImageManager *imageManager;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation CustomPhotoLibView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:[[CustomPhotoLibraryCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    self.imageManager = [PHCachingImageManager new];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    if (self.fetchresult == nil) {
        PHFetchOptions *options = [PHFetchOptions new];
        //options.sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
        self.fetchresult = [PHAsset fetchAssetsWithOptions:options];
        [self.collectionView reloadData];
    }

    
}

#pragma mark - UICollectionView Delegate and Datasource
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
    
    CGRect imageFrame = self.frame;
    CGSize size=CGSizeMake(imageFrame.size.width, imageFrame.size.height);
    [self.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *resultImage, NSDictionary *info) {
//        self.capturedImageView.hidden = NO;
//        self.capturedImageView.image = resultImage;
//        
//        NSArray *items = [self secondSetCameraItems];
//        self.cameraControlListView.focusOnItem = CameraControlListViewPreview;
//        [self.cameraControlListView setCameraItemsInfo:items hideLineView:NO];
//        isLibrarySelected = NO;
        [self.customPhotoLibViewDelegate customPhotoLibDidSelect:resultImage];
    }];
}
    



@end

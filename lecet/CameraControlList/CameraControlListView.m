//
//  CameraControlListView.m
//  lecet
//
//  Created by Michael San Minay on 17/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CameraControlListView.h"
#import "CustomCameraCollectionViewCell.h"

#pragma mark - FONT
#define FONT_CELL_TITLE          fontNameWithSize(FONT_NAME_LATO_BOLD, 14)

#pragma mark - COLOR
#define COLOR_FONT_CELL_TITLE    RGB(255,255,255)

#define kCellIdentifier                     @"kCellIdentifier"
@interface CameraControlListView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *cameraItems;
@end

@implementation CameraControlListView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:[[CustomCameraCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
  
}

#pragma mark - UICollectionViewDelegate and DataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.cameraItems.count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCameraCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSString *title = self.cameraItems[indexPath.row];
    
    cell.titleLabel.font = FONT_CELL_TITLE;
    cell.titleLabel.textColor = COLOR_FONT_CELL_TITLE;
    
    cell.titleLabel.text = title;
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    size = CGSizeMake( (self.collectionView.frame.size.width * 0.35), self.collectionView.frame.size.height);
    
    return size;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake( 0, 0, 0, 0);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.cameraItems[indexPath.row];
    NSString *strip = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strip.length > 0) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    
}

#pragma mark - Misc Method
- (void)setCameraItemsInfo:(NSArray *)cameraItems {
    self.cameraItems = cameraItems;
    [self.collectionView reloadData];
}

@end

//
//  PanoramaIndicatorListView.m
//  lecet
//
//  Created by Michael San Minay on 18/04/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "PanoramaIndicatorListView.h"
#import "PanoIndiListCollectionViewCell.h"

#define kCellIdentifier                     @"kCellIdentifier"
#define cellSpace                           kDeviceWidth * 0.05

@interface PanoramaIndicatorListView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionItems;

@end

@implementation PanoramaIndicatorListView

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - UICollectionViewDelegate and DataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionItems.count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PanoIndiListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    CGFloat sizeAspectRatio = self.collectionView.frame.size.width * 0.25;
    size = CGSizeMake(sizeAspectRatio,sizeAspectRatio);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

@end

//
//  RecentSearchView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "RecentSearchView.h"
#import "RecentSearchItemCollectionViewCell.h"

@interface RecentSearchView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *items;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation RecentSearchView
#define kCellIdentifier                 @"kCellIdentifier"

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[RecentSearchItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    items = [NSMutableArray new];
    [[DataManager sharedManager] recentlyViewed:^(id object) {
    
        items = [object mutableCopy];
        [_collectionView reloadData];
        
    } failure:^(id object) {
        
    }];
    
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecentSearchItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell setInfo:items[indexPath.row]];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = items.count;
    
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellWidth =  kDeviceWidth * 0.27;
    CGFloat cellHeight = _collectionView.frame.size.height;
    size = CGSizeMake( cellWidth, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [[DataManager sharedManager] featureNotAvailable];

}

@end

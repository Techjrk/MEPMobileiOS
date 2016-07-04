//
//  CustomListView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomListView.h"

@interface CustomListView(){
    BOOL isNibRegistered;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation CustomListView
@synthesize customListViewDelegate;
@synthesize navigationController;

- (void)awakeFromNib {

    [super awakeFromNib];
    
}

- (void)registerListItemNib:(Class)objectClass {
    
    [_collectionView registerNib:[UINib nibWithNibName:[[objectClass class] description] bundle:nil] forCellWithReuseIdentifier:[objectClass description]];
    
}

- (ListItemCollectionViewCell *)dequeListItemCollectionViewCell:(NSString *)identifier indexPath:(NSIndexPath *)indexPath {
    return [_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData {
    
    [_collectionView reloadData];
}

- (void)reloadIndexPaths:(NSArray *)indexPaths {
    
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
    
}

- (NSArray *)visibleIndexPaths {
    return [_collectionView indexPathsForVisibleItems];
}

- (void)setListViewScrollable:(BOOL)scrollable {

    [_collectionView setScrollEnabled:scrollable];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isNibRegistered) {
        isNibRegistered = YES;
        [self.customListViewDelegate listViewRegisterNib:self];
    }
    
    UICollectionViewCell *cell = [self.customListViewDelegate listViewItemPrepareForUse:indexPath listView:self];
    
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.customListViewDelegate listViewItemCount];

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.customListViewDelegate listViewItemSize:indexPath];
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
    
}

@end

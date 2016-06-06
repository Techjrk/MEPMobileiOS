//
//  ContactDetailView.m
//  lecet
//
//  Created by Michael San Minay on 06/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactDetailView.h"
#import "ContactFieldCollectionViewCell.h"

@interface ContactDetailView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ContactDetailView
#define kCellIdentifier                 @"kCellIdentifier"

- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[ContactFieldCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
}

- (void)configureView:(UIView*)view {
    view.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds = YES;
}


- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    cellHeight = 0;
    constraintHeight.constant = 0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView reloadData];
}
#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactFieldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell setInfo:collectionItems[indexPath.row]];
    [self configureView:cell];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = collectionItems.count;
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    cellHeight = kDeviceHeight * 0.07;
    size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    
    return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);
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

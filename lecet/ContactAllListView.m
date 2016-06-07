//
//  ContactAllListView.m
//  lecet
//
//  Created by Michael San Minay on 05/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactAllListView.h"
#import "ContactItemCollectionViewCell.h"
#import "DB_CompanyContact.h"
#import "contactsConstants.h"
#import "DB_Company.h"

@interface ContactAllListView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ContactAllListView
#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    
    [_collectionView registerNib:[UINib nibWithNibName:[[ContactItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    constraintHeight.constant = 0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DB_CompanyContact *item = collectionItems[indexPath.row];
    
    [cell setItemInfo:@{CONTACT_NAME:item.name, CONTACT_COMPANY:item.relationshipCompany.name}];
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
    cellHeight = kDeviceHeight * 0.13;
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
    [[DataManager sharedManager] featureNotAvailable];
}





@end

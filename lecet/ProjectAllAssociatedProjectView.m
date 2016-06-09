//
//  ProjectAllAssociatedProjectView.m
//  lecet
//
//  Created by Michael San Minay on 05/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectAllAssociatedProjectView.h"
#import "AssociatedBidCollectionViewCell.h"
#import "associatedProjectsConstants.h"
#import "associatedBidConstants.h"
#import "DB_Project.h"

@interface ProjectAllAssociatedProjectView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ProjectAllAssociatedProjectView
@synthesize projectAllAssociatedProjectViewDelegate;

#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {

    [_collectionView registerNib:[UINib nibWithNibName:[[AssociatedBidCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
}


- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    constraintHeight.constant = 0;
    [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AssociatedBidCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
  
    DB_Project *project = collectionItems[indexPath.row];
    NSDictionary *dict = @{ASSOCIATED_BID_NAME:project.title, ASSOCIATED_BID_LOCATION:[project address], ASSOCIATED_BID_DESIGNATION:project.unionDesignation != nil?project.unionDesignation:@"", ASSOCIATED_BID_GEOCODE_LAT:project.geocodeLat, ASSOCIATED_BID_GEOCODE_LNG:project.geocodeLng};
    [cell setInfo:dict];
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
    
    cellHeight = kDeviceHeight * 0.148;
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
    [self.projectAllAssociatedProjectViewDelegate selectedAssociatedProjectItem:collectionItems[indexPath.row]];
}

@end

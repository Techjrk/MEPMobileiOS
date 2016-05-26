//
//  ProjectBidderView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBidderView.h"

#import "SectionTitleView.h"
#import "ProjectBiddersCollectionViewCell.h"

#import "DB_Bid.h"
#import "DB_Company.h"

@interface ProjectBidderView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSLayoutConstraint *constraintHeight;
    NSMutableArray *collectionItems;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet SectionTitleView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ProjectBidderView
@synthesize projectBidderDelegate;

#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    [super awakeFromNib];
    [_titleView setTitle:NSLocalizedLanguage(@"PROJECTBIDDER_VIEW_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;

    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectBiddersCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

}

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
}


#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectBiddersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DB_Bid *bidItem = collectionItems[indexPath.row];
    
    [cell setItem:@"$ 10,000" line1:bidItem.relationshipCompany.name line2:[bidItem.relationshipCompany address]];
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
    
    cellHeight = kDeviceHeight * 0.085;
    size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
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
    [self.projectBidderDelegate tappedProjectBidder:nil];
}

#pragma mark - View

- (void)layoutSubviews {
    if (cellHeight>0) {
        constraintHeight.constant = collectionItems.count * cellHeight + _titleView.frame.size.height;
    }
}

- (void)removeFromSuperview {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    [super removeFromSuperview];
}

@end

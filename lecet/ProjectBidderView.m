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
#import "projectBidderConstants.h"
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
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeAll;
- (IBAction)tappedButtonSeeAll:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintButtonSeeAll;
@end

@implementation ProjectBidderView
@synthesize projectBidderDelegate;

#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    [super awakeFromNib];
    [_titleView setTitle:NSLocalizedLanguage(@"PROJECTBIDDER_VIEW_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;

    [_buttonSeeAll setTitleColor:PROJECTBIDDERS_COLOR forState:UIControlStateNormal];
    _buttonSeeAll.titleLabel.font = PROJECTBIDDERS_FONT;

    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectBiddersCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

}

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _contraintButtonSeeAll.constant = items.count>3? (kDeviceHeight * 0.06):0;
    _buttonSeeAll.enabled = items.count>3;
    if (_buttonSeeAll.enabled) {
        [_buttonSeeAll setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"PROJECTBIDDER_VIEW_BIDDERS"), items.count ]forState:UIControlStateNormal];
    } else {
        _buttonSeeAll.hidden = YES;
    }

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
    return count>3?3:count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    cellHeight = kDeviceHeight * 0.1;
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
    [self.projectBidderDelegate tappedProjectBidder:collectionItems[indexPath.row]];
}

#pragma mark - View

- (void)layoutSubviews {
    
    if (collectionItems.count == 0) {
        constraintHeight.constant = 0;
    } else if (cellHeight>0) {
        
        NSInteger count = collectionItems.count>3?3:collectionItems.count;
        constraintHeight.constant = (count * cellHeight) + _titleView.frame.size.height + _buttonSeeAll.frame.size.height;
    }
}

- (void)removeFromSuperview {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    [super removeFromSuperview];
}

- (IBAction)tappedButtonSeeAll:(id)sender {
    [self.projectBidderDelegate tappedProjectBidSeeAll:self];
}

@end

//
//  AssociatedProjectsView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "AssociatedProjectsView.h"

#import "SectionTitleView.h"
#import "AssociatedBidCollectionViewCell.h"
#import "associatedProjectsConstants.h"
#import "associatedBidConstants.h"
#import "DB_Project.h"

@interface AssociatedProjectsView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet SectionTitleView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSpacerHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeAll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonSeeAll;
- (IBAction)tappedButtonSeeAll:(id)sender;
@end

@implementation AssociatedProjectsView
#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    [_titleView setTitle:NSLocalizedLanguage(@"ASSOCIATED_PROJECTS_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;
    _constraintSpacerHeight.constant = kDeviceHeight * 0.015;
    _constraintButtonSeeAll.constant = 0;
    [_buttonSeeAll setTitleColor:ASSOCIATED_PROJECTS_BUTTON_COLOR forState:UIControlStateNormal];
    _buttonSeeAll.titleLabel.font = ASSOCIATED_PROJECTS_BUTTON_FONT;
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
    _constraintButtonSeeAll.constant = items.count>3?(kDeviceHeight * 0.04):0;
    
    if (_constraintButtonSeeAll.constant == 0) {
        _buttonSeeAll.hidden = YES;
    } else {
        [_buttonSeeAll setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"ASSOCIATED_PROJECTS_ALL"), items.count ]forState:UIControlStateNormal];
    }

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
    
    NSInteger count = collectionItems.count>3?3:collectionItems.count;
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
    [[DataManager sharedManager] featureNotAvailable];
}

#pragma mark - View

- (void)layoutSubviews {
    if (cellHeight>0) {
        NSInteger itemCount = collectionItems.count>3?3:collectionItems.count;
        constraintHeight.constant = (itemCount * cellHeight) + _titleView.frame.size.height + _titleView.frame.origin.y + _constraintSpacerHeight.constant + _constraintButtonSeeAll.constant;
    }
}

- (IBAction)tappedButtonSeeAll:(id)sender {
    
    [_associatedProjectDelegate tappededSeeAllAssociateProject];
    
}

@end

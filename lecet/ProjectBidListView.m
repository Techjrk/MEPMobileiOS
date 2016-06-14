//
//  ProjectBidListView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBidListView.h"

#import "SectionTitleView.h"
#import "ProjectBidItemCollectionViewCell.h"
#import "projectBidListConstants.h"
#import "projectBidConstants.h"
#import "DB_Bid.h"
#import "DB_Project.h"

@interface ProjectBidListView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet SectionTitleView *titleView;
@property (weak, nonatomic) IBOutlet UIView *viewSpacer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSpacerHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeAll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonSeeAll;
- (IBAction)tappedButtonSeeAll:(id)sender;
@end

@implementation ProjectBidListView

#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    [_titleView setTitle:NSLocalizedLanguage(@"PROJECT_BIDS_VIEW_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;
    _constraintSpacerHeight.constant = kDeviceHeight * 0.015;
    
    [_buttonSeeAll setTitleColor:PROJECT_BID_LIST_BUTTON_COLOR forState:UIControlStateNormal];
    _buttonSeeAll.titleLabel.font = PROJECT_BID_LIST_BUTTON_FONT;

    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectBidItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

}

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    constraintHeight.constant = 0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _constraintButtonSeeAll.constant = items.count>3? (kDeviceHeight * 0.04):0;
    
    if (_constraintButtonSeeAll.constant == 0 ) {
        _buttonSeeAll.hidden = YES;
    } else {
        [_buttonSeeAll setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"PROJECT_BIDS_VIEW_ALL"), items.count ]forState:UIControlStateNormal];
    }
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectBidItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DB_Bid *bid = collectionItems[indexPath.row];
    DB_Project *project = bid.relationshipProject;
    
    
    NSDictionary *dict = @{PROJECT_BID_NAME:project.title, PROJECT_BID_LOCATION:[project address], PROJECT_BID_AMOUNT:[bid bidAmountWithCurrency], PROJECT_BID_DATE:[project bidDateString], PROJECT_BID_GEOCODE_LAT:project.geocodeLat, PROJECT_BID_GEOCODE_LNG:project.geocodeLng};

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
    
    cellHeight = kDeviceHeight * 0.15;
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
    [self.projectBidListDelegate tappedProjectItemBidder:collectionItems[indexPath.row]];
}

#pragma mark - View

- (void)layoutSubviews {
    
    cellHeight = kDeviceHeight * 0.15;

    if (cellHeight>0 & collectionItems.count>0) {
        NSInteger itemCount = collectionItems.count>3?3:collectionItems.count;
        constraintHeight.constant = (itemCount * cellHeight) + _titleView.frame.size.height + _titleView.frame.origin.y + _viewSpacer.frame.size.height + _buttonSeeAll.frame.size.height;
    } else {
        constraintHeight.constant = 0;
    }
}

- (IBAction)tappedButtonSeeAll:(id)sender {
    [self.projectBidListDelegate tappedProjectItemBidSeeAll:self];
}

@end

//
//  CompanyStateView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyStateView.h"

#import "companyStateConstants.h"
#import "ContactFieldCollectionViewCell.h"

@interface CompanyStateView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonTrack;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation CompanyStateView
#define kCellIdentifier                 @"kCellIdentifier"

- (void)awakeFromNib {
    self.layer.shadowColor = [COMPANY_STATE_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    
    _constraintButtonHeight.constant = kDeviceHeight * 0.055;
    [self configureView:_buttonTrack];
    [_buttonTrack setTitleColor:COMPANY_STATE_BUTTON_COLOR forState:UIControlStateNormal];
    [_buttonTrack setTitle:NSLocalizedLanguage(@"COMPANY_STATE_TRACK") forState:UIControlStateNormal];
    
    [self configureView:_buttonShare];
    [_buttonShare setTitleColor:COMPANY_STATE_BUTTON_COLOR forState:UIControlStateNormal];
    [_buttonShare setTitle:NSLocalizedLanguage(@"COMPANY_STATE_SHARE") forState:UIControlStateNormal];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[ContactFieldCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

}

- (void)configureView:(UIView*)view {
    view.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds = YES;
}

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    cellHeight = 0;
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
    
    NSInteger count = collectionItems.count>3?3:collectionItems.count;
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

#pragma mark - View

- (void)layoutSubviews {
    
    if (cellHeight == 0) {
        cellHeight = (collectionItems.count) * (kDeviceHeight * 0.07);
    }
    
    if (cellHeight>0) {
        NSInteger itemCount = collectionItems.count;
        
        CGFloat f = (itemCount * cellHeight) + _buttonTrack.frame.size.height;
        constraintHeight.constant = (itemCount * cellHeight) + _buttonTrack.frame.size.height;
        f = f;
    }
}

@end

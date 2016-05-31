//
//  ContactsListView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactsListView.h"

#import "SectionTitleView.h"
#import "ContactItemCollectionViewCell.h"
#import "DB_CompanyContact.h"
#import "contactsConstants.h"
#import "DB_Company.h"

@interface ContactsListView()<UICollectionViewDelegate, UICollectionViewDataSource>{
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSeeAllHeight;
- (IBAction)tappedButtonSeeAll:(id)sender;
@end

@implementation ContactsListView
#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    [_titleView setTitle:NSLocalizedLanguage(@"CONTACTS_VIEW_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;
    _constraintSpacerHeight.constant = kDeviceHeight * 0.015;
    [_collectionView registerNib:[UINib nibWithNibName:[[ContactItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    [_buttonSeeAll setTitleColor:CONTACTS_LIST_BUTTON_COLOR forState:UIControlStateNormal];
    _buttonSeeAll.titleLabel.font = CONTACTS_LIST_BUTTON_FONT;

}

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    constraintHeight.constant = 0;
    
    _constraintSeeAllHeight.constant = items.count>3? (kDeviceHeight * 0.04):0;
    
    if (_constraintSeeAllHeight.constant == 0) {
        _buttonSeeAll.hidden = YES;
    } else {
        [_buttonSeeAll setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"PROJECT_CONTACTS_VIEW_ALL"), items.count ]forState:UIControlStateNormal];
    }

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
    
    NSInteger count = collectionItems.count>3?3:collectionItems.count;
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

#pragma mark - View

- (void)layoutSubviews {
    if (cellHeight>0) {
        NSInteger count = collectionItems.count>3?3:collectionItems.count;
        constraintHeight.constant = (count * cellHeight) + _titleView.frame.size.height + _titleView.frame.origin.y + _viewSpacer.frame.size.height + _buttonSeeAll.frame.size.height;
    }
}

- (IBAction)tappedButtonSeeAll:(id)sender {
    [[DataManager sharedManager] featureNotAvailable];
}

@end

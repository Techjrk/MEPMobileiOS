//
//  PariticpantsView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "PariticpantsView.h"

#import "SectionTitleView.h"
#import "ParticipantCollectionViewCell.h"
#import "participantsConstants.h"
#import "DB_Participant.h"

@interface PariticpantsView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSLayoutConstraint *constraintHeight;
    NSMutableArray *collectionItems;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet SectionTitleView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeAll;
- (IBAction)tappedButtonSeeAll:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonSeeAll;
@end

@implementation PariticpantsView
@synthesize pariticipantsDelegate;

#define kCellIdentifier         @"kCellIdentifier"

- (void)awakeFromNib {
    [super awakeFromNib];
    [_titleView setTitle:NSLocalizedLanguage(@"PARTICIPANTS_VIEW_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;

    [_buttonSeeAll setTitleColor:PARTICIPANTS_COLOR forState:UIControlStateNormal];
    _buttonSeeAll.titleLabel.font = PARTICIPANTS_FONT;
    [_collectionView registerNib:[UINib nibWithNibName:[[ParticipantCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

}

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _constraintButtonSeeAll.constant = items.count>0? (kDeviceHeight * 0.06):0;
    _buttonSeeAll.enabled = items.count>3;
    if (_buttonSeeAll.enabled) {
        [_buttonSeeAll setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"PARTICIPANTS_VIEW_PARTICIPANTS"), items.count ]forState:UIControlStateNormal];
    }else {
        [_buttonSeeAll setTitle:@"" forState:UIControlStateNormal];
    }

    [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ParticipantCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DB_Participant *participantItem = collectionItems[indexPath.row];
    
    [cell setItem:participantItem.contactTypeGroup line1:participantItem.name line2:[participantItem address]];
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
    
    cellHeight = kDeviceHeight * 0.09;
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
    DB_Participant *participantItem = collectionItems[indexPath.row];

    [self.pariticipantsDelegate tappedParticipant:participantItem];
}

#pragma mark - View

- (void)layoutSubviews {
    if (cellHeight>0) {
        NSInteger count = collectionItems.count>3?3:collectionItems.count;
        constraintHeight.constant = count * cellHeight + _titleView.frame.size.height + _buttonSeeAll.frame.size.height;
    }
}

- (IBAction)tappedButtonSeeAll:(id)sender {
}
@end

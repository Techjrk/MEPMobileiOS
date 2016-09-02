//
//  ParticipantsListViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/9/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ParticipantsListViewController.h"

#import "ProjectNavigationBarView.h"
#import "ParticipantCollectionViewCell.h"
#import "CompanyDetailViewController.h"
#import "DB_Participant.h"

@interface ParticipantsListViewController ()<ProjectNavViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *topBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

#define PROJECT_PARTICIPANTS_CONTAINER_BG_COLOR           RGB(245, 245, 245)

@implementation ParticipantsListViewController
@synthesize collectionItems;
@synthesize projectName;

#define kCellIdentifier                 @"kCellIdentifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView registerNib:[UINib nibWithNibName:[[ParticipantCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    _collectionView.backgroundColor = PROJECT_PARTICIPANTS_CONTAINER_BG_COLOR;
    
    [_topBar setContractorName:self.projectName];
    [_topBar setProjectTitle:NSLocalizedLanguage(@"PARITICPANT_LIST_BOTTOM_LABEL")];
    [_topBar hideReorderButton:YES];
    _topBar.projectNavViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Delegates

- (void)tappedProjectNav:(ProjectNavItem)projectNavItem {
    
    if (projectNavItem == ProjectNavBackButton) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //[[DataManager sharedManager] featureNotAvailable];
    }
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
    
    return self.collectionItems.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellHeight = kDeviceHeight * 0.1;
    size = CGSizeMake( kDeviceWidth * 0.85, cellHeight);
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
   
    DB_Participant *record = self.collectionItems[indexPath.row];
    _collectionView.userInteractionEnabled = NO;
    [[DataManager sharedManager] companyDetail:record.companyId success:^(id object) {
        id returnObject = object;
        CompanyDetailViewController *controller = [CompanyDetailViewController new];
        controller.view.hidden = NO;
        [controller setInfo:returnObject];
        [self.navigationController pushViewController:controller animated:YES];
        _collectionView.userInteractionEnabled = YES;

    } failure:^(id object) {
        _collectionView.userInteractionEnabled = YES;
    }];
    
}

@end

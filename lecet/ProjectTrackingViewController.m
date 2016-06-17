//
//  ProjectTrackingViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTrackingViewController.h"

#import "ProjectNavigationBarView.h"
#import "PopupViewController.h"
#import "ProjectSortCVCell.h"
#import "SectionHeaderCollectionViewCell.h"
#import "ProjComTrackingTabView.h"
#import "ProjectTrackItemCollectionViewCell.h"

@interface ProjectTrackingViewController ()<ProjectNavViewDelegate,CustomCollectionViewDelegate,ProjComTrackingTabViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{
    NSArray *sortItems;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *topBar;
@property (weak, nonatomic) IBOutlet ProjComTrackingTabView *editView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEditViewHeight;
@end

@implementation ProjectTrackingViewController
@synthesize cargo;

#define kCellIdentifier             @"kCellIdentifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *projectIds = self.cargo[@"projectIds"];
    [_topBar setProjectTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"TRACK_ITEM_COUNT"), (long)projectIds.count]];
    [_topBar setContractorName:self.cargo[@"name"]];
    
    _topBar.projectNavViewDelegate = self;
    
    sortItems = @[NSLocalizedLanguage(@"PROJECTSORT_BID_DATE_TEXT"),
                NSLocalizedLanguage(@"PROJECTSORT_LAST_UPDATED_TEXT"),
                NSLocalizedLanguage(@"PROJECTSORT_DATE_ADDED_TEXT"),
                NSLocalizedLanguage(@"PROJECTSORT_HIGH_TO_LOW_TEXT"),
                NSLocalizedLanguage(@"PROJECTSORT_LOW_TO_HIGH_TEXT")];
    
    _constraintEditViewHeight.constant = 0;
    _editView.projComTrackingTabViewDelegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectTrackItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Custom Delegates

- (void)switchTabButtonStateChange:(BOOL)isOn {
    
}

- (void)editTabButtonTapped {
    _constraintEditViewHeight.constant = kDeviceHeight * 0.09;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)tappedProjectNav:(ProjectNavItem)projectNavItem {
    if (projectNavItem == ProjectNavBackButton) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([[DataManager sharedManager] isDebugMode]) {
            PopupViewController *controller = [PopupViewController new];
            CGRect rect = [controller getViewPositionFromViewController:[_topBar reOrderButton] controller:self];
            rect.size.height =  rect.size.height * 0.85;
            controller.popupRect = rect;
            controller.popupWidth = 0.98;
            controller.isGreyedBackground = YES;
            controller.customCollectionViewDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:NO completion:nil];
        } else {
            [[DataManager sharedManager] featureNotAvailable];
        }
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

#pragma mark - CustomCollectionView Delegate

- (void)collectionViewItemClassRegister:(id)customCollectionView {
    CustomCollectionView *collectionView = (CustomCollectionView*)customCollectionView;
    [collectionView registerCollectionItemClass:[ProjectSortCVCell class]];
    [collectionView registerCollectionItemClass:[SectionHeaderCollectionViewCell class]];
}

- (UICollectionViewCell*)collectionViewItemClassDeque:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView {
    return [collectionView dequeueReusableCellWithReuseIdentifier:indexPath.row == 0?[[SectionHeaderCollectionViewCell class] description]:[[ProjectSortCVCell class] description] forIndexPath:indexPath];
}

- (NSInteger)collectionViewItemCount {
    return 6;
}

- (NSInteger)collectionViewSectionCount {
    return 1;
}

- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath*)indexPath cargo:(id)cargo {
    return CGSizeMake(view.frame.size.width * (indexPath.row ==0 ?1:0.95), kDeviceHeight * (indexPath.row == 0?0.082:0.061));
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    [[DataManager sharedManager] featureNotAvailable];
}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[ProjectSortCVCell class]]) {
        ProjectSortCVCell *cellItem = (ProjectSortCVCell*)cell;
        cellItem.labelTitle.text = sortItems[indexPath.row-1];
    } else {
        SectionHeaderCollectionViewCell *cellItem = (SectionHeaderCollectionViewCell*)cell;
        [cellItem setTitle:NSLocalizedLanguage(@"PROJECTSORT_TITLE_LABEL_TEXT")];

    }
}

#pragma mark - UICollectionView Delegate

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectTrackItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];;
    
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellHeight = kDeviceHeight * 0.15;
    size = CGSizeMake( kDeviceWidth, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, kDeviceWidth * 0.025, 0, kDeviceWidth * 0.025);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceWidth * 0.025;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end

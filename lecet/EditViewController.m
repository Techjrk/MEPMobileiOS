//
//  EditViewController.m
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "EditViewController.h"
#import "ProjectNavigationBarView.h"
#import "EditTabView.h"
#import "SelectMoveView.h"
#import "PopupViewController.h"
#import "EditViewList.h"
#import "CompanySortViewController.h"
#import "ProjectSortCVCell.h"
#import "SectionHeaderCollectionViewCell.h"
#import "TrackingListCellCollectionViewCell.h"

typedef enum  {
    PopupModeSort,
    PopupModeMove,
} PopupMode;

@interface EditViewController ()<ProjectNavViewDelegate,SelectMoveViewDelegate,EditTabViewDelegate,EditViewListDelegate,CompanySortDelegate,CustomCollectionViewDelegate,TrackingListViewDelegate>{
    BOOL isInEditMode;;
    NSMutableArray *collectionDataItems;
    id trackingInfo;
    NSArray *selectedDataItems;
    PopupMode popupMode;
    NSArray *trackItemRecord;
    NSArray *sortItems;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomCollectionViewSpacing;
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *navView;
@property (weak, nonatomic) IBOutlet EditTabView *tabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEditViewHeight;
@property (weak, nonatomic) IBOutlet SelectMoveView *selectMoveView;
@property (weak, nonatomic) IBOutlet EditViewList *editViewList;

@end

@implementation EditViewController
#define BOTTOMVIEW_BG_COLOR RGB(5, 35, 74)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _constraintEditViewHeight.constant = 0;
    _navView.projectNavViewDelegate = self;
    _selectMoveView.selectMoveViewDelegate = self;
    _tabView.editTabViewDelegate = self;
    _editViewList.editViewListDelegate = self;
    
    [_selectMoveView setBackgroundColor:BOTTOMVIEW_BG_COLOR];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [_editViewList setInfo:collectionDataItems];
    [_navView setContractorName:trackingInfo[@"name"]];
    NSString *countString = [NSString stringWithFormat:@"%lu Companies",[trackingInfo[@"companyIds"] count]];
    [_navView setProjectTitle:countString];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(id)items {
    collectionDataItems = items;
    
}

#pragma mark - Nav Delegate
- (void)tappedProjectNav:(ProjectNavItem)projectNavItem {
    switch (projectNavItem) {
        case ProjectNavBackButton:{
            [self dismissViewControllerAnimated:NO completion:^{
                [_editViewControllerDelegate tappedCancelDoneButton:collectionDataItems];
                [_editViewControllerDelegate tappedBackButton];
                
            }];
            
            break;
        }
        case ProjectNavReOrder:{
            CompanySortViewController *controller = [[CompanySortViewController alloc] initWithNibName:@"CompanySortViewController" bundle:nil];
            controller.companySortDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:controller  animated:NO completion:nil];
            break;
        }
            
    }
}



#pragma mark - CustomCollectionView Delegate

#pragma mark - EdittabViewDelgate
- (void)selectedEditTabButton:(EditTabItem)item {

    [self dismissViewControllerAnimated:NO completion:^{
        [_editViewControllerDelegate tappedCancelDoneButton:collectionDataItems];
    }];

}



#pragma mark - Misc Method
- (void)chageEditMode:(BOOL)editMode count:(int)count{
    isInEditMode = editMode;
    

   
    if (!isInEditMode) {
        _constraintEditViewHeight.constant = 0;
        CGFloat heightPopUpView = kDeviceHeight * (count > 0?0.09:0);
        
        [UIView animateWithDuration:0.25 animations:^{
            _constraintEditViewHeight.constant = heightPopUpView;
            _constraintBottomCollectionViewSpacing.constant = heightPopUpView;
            
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

#pragma mark - EditViewListDelegate

- (void)selectedItem:(id)items {
    
    selectedDataItems = items;
    int count = (int)[items count];
    [_selectMoveView setSelectionCount:(NSInteger)count];
    [self chageEditMode:NO count:count];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - CompanySortDelegate
- (void)selectedSort:(CompanySortItem)item {
    switch (item) {
        case CompanySortItemLastUpdated: {
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
            collectionDataItems = [[collectionDataItems sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
            [_editViewList setInfoToReload:collectionDataItems];
           
            break;
        }
        case CompanySortItemLastAlphabetical: {
            
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            collectionDataItems = [[collectionDataItems sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
            [_editViewList setInfoToReload:collectionDataItems];
            
            break;
        }
            
    }
}

- (void)setTrackingInfo:(id)item {
    trackingInfo = item;
}


#pragma Custom Delegates

- (void)tappedMoveItem:(id)object shouldMove:(BOOL)shouldMove {
    
    if (shouldMove) {
        UIView *objectView = object;
        
        NSNumber *number = trackingInfo[@"userId"];
        [[DataManager sharedManager] userCompanyTrackingList:number success:^(id object) {
            popupMode = PopupModeMove;
            trackItemRecord = [self companyTrackingListToMove:object];
            PopupViewController *controller = [PopupViewController new];
            CGRect rect = [controller getViewPositionFromViewController:objectView controller:self];
            controller.popupPalcement = PopupPlacementBottom;
            controller.popupRect = rect;
            controller.popupWidth = 0.98;
            controller.isGreyedBackground = YES;
            controller.customCollectionViewDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:NO completion:nil];
            
        } failure:^(id object) {
            
        }];
    
        
    }
    
    
}

- (NSArray *)companyTrackingListToMove:(NSArray *)object {
    
    NSMutableArray *mutableObject = [object mutableCopy];
    [object enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
    
        if ([obj[@"companyIds"] containsObject:[selectedDataItems lastObject][@"id"]]) {
            
            [mutableObject removeObjectAtIndex:index];
        }
        
    }];
    
    return [mutableObject copy];
    
}

#pragma mark - CustomCollectionView Delegate

- (void)collectionViewItemClassRegister:(id)customCollectionView {
    
    CustomCollectionView *collectionView = (CustomCollectionView*)customCollectionView;
    
    switch (popupMode) {
            
        case PopupModeSort: {
            
            [collectionView registerCollectionItemClass:[ProjectSortCVCell class]];
            [collectionView registerCollectionItemClass:[SectionHeaderCollectionViewCell class]];
            break;
        }
            
        case PopupModeMove: {
            
            [collectionView registerCollectionItemClass:[TrackingListCellCollectionViewCell class]];
            break;
        }
            
    }
}

- (UICollectionViewCell*)collectionViewItemClassDeque:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView {
    
    switch (popupMode) {
            
        case PopupModeSort: {
            
            return [collectionView dequeueReusableCellWithReuseIdentifier:indexPath.row == 0?[[SectionHeaderCollectionViewCell class] description]:[[ProjectSortCVCell class] description] forIndexPath:indexPath];
            
            break;
        }
            
        case PopupModeMove: {
            
            return [collectionView dequeueReusableCellWithReuseIdentifier:[[TrackingListCellCollectionViewCell class] description]forIndexPath:indexPath];
            
            break;
        }
    }
    
    return nil;
}

- (NSInteger)collectionViewItemCount {
    
    switch (popupMode) {
            
        case PopupModeSort: {
            
            return sortItems.count + 1;
            
            break;
        }
            
        case PopupModeMove: {
            
            return 1;
            break;
        }
    }
    return 0;
}

- (NSInteger)collectionViewSectionCount {
    return 1;
}

- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath*)indexPath cargo:(id)cargo {
    switch (popupMode) {
        case PopupModeSort: {
            
            return CGSizeMake(view.frame.size.width * (indexPath.row ==0 ?1:0.95), kDeviceHeight * (indexPath.row == 0?0.082:0.061));
            
            break;
        }
            
        case PopupModeMove: {
            
            CGFloat defaultHeight = kDeviceHeight * 0.08;
            CGFloat cellHeight = kDeviceHeight * 0.06;
            defaultHeight = defaultHeight+ (trackItemRecord.count*cellHeight);
            return CGSizeMake(kDeviceWidth * 0.98, defaultHeight);
            
            break;
        }
    }
    
    return CGSizeZero;
    
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    
    if (indexPath.row>0) {
        
        ///BOOL isDesc = indexPath.row != 4;
        //NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kSortKey[indexPath.row-1] ascending:isDesc];
        
        //self.collectionItems = [self.collectionItems sortedArrayUsingDescriptors:@[descriptor]];
        //[_collectionView reloadData];
    }
}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[ProjectSortCVCell class]]) {
        ProjectSortCVCell *cellItem = (ProjectSortCVCell*)cell;
        cellItem.labelTitle.text = sortItems[indexPath.row-1];
    } else if([cell isKindOfClass:[SectionHeaderCollectionViewCell class]]){
        SectionHeaderCollectionViewCell *cellItem = (SectionHeaderCollectionViewCell*)cell;
        [cellItem setTitle:NSLocalizedLanguage(@"PROJECTSORT_TITLE_LABEL_TEXT")];
        
    } else if ([cell isKindOfClass:[TrackingListCellCollectionViewCell class]]) {
        
        TrackingListCellCollectionViewCell *cellItem = (TrackingListCellCollectionViewCell*)cell;
        cellItem.headerDisabled = YES;
        cellItem.trackingListViewDelegate = self;
        [cellItem setInfo:trackItemRecord withTitle:NSLocalizedLanguage(@"PROJECT_TRACKING_LIST")];
        
    }
    
}


#pragma mark - Tracking Delegate

- (void)tappedTrackingListItem:(id)object view:(UIView *)view {
    
}

@end

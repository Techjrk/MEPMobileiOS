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
#import "ProjectTrackItemView.h"
#import "ProjectTrackEditCollectionViewCell.h"
#import "EditTabView.h"
#import "SelectMoveView.h"
#import "TrackingListCellCollectionViewCell.h"

typedef enum  {
    PopupModeSort,
    PopupModeMove,
} PopupMode;

@interface ProjectTrackingViewController ()<ProjectNavViewDelegate,CustomCollectionViewDelegate,ProjComTrackingTabViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ProjectTrackItemViewDelegate, EditTabViewDelegate, SelectMoveViewDelegate, TrackingListViewDelegate>{
    NSArray *sortItems;
    NSMutableDictionary *collectionItemsState;
    BOOL isInEditMode;
    PopupMode popupMode;
    NSArray *trackItemRecord;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *topBar;
@property (weak, nonatomic) IBOutlet ProjComTrackingTabView *editView;
@property (weak, nonatomic) IBOutlet EditTabView *editModeView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet SelectMoveView *selectMoveView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEditViewHeight;
@end

@implementation ProjectTrackingViewController
@synthesize cargo;
@synthesize collectionItems;
#define kCellIdentifier                 @"kCellIdentifier"
#define kCellIdentifierEdit             @"kCellIdentifierEdit"
#define kStateIndex                     @"kStateIndex"
#define kSortKey                        @[@"bidDate", @"lastPublishDate", @"firstPublishDate", @"estLow", @"estLow"]

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
    _editModeView.editTabViewDelegate = self;
    _selectMoveView.selectMoveViewDelegate = self;
    
    [self prepareCollectionStates];
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectTrackItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
   
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectTrackEditCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierEdit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Sort States

- (void) prepareCollectionStates {
    if(collectionItemsState == nil) {
        collectionItemsState = [[NSMutableDictionary alloc]init];
    }
    
    for (NSDictionary *item in self.collectionItems) {
        NSMutableDictionary *status = [@{kStateSelected:[NSNumber numberWithBool:NO], kStateUpdateType:[NSNumber numberWithInt:ProjectTrackUpdateTypeNewBid], kStateShowUpdate:[NSNumber numberWithBool:YES], kStateExpanded:[NSNumber numberWithBool:NO]} mutableCopy];
        collectionItemsState[item[@"id"]] = [@{kStateData:item, kStateStatus:status} mutableCopy];
        
    }
}

#pragma Custom Delegates

- (void)tappedMoveItem:(id)object shouldMove:(BOOL)shouldMove {
    if (shouldMove) {
        UIView *objectView = object;
        
        NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
        
        [[DataManager sharedManager] userProjectTrackingList:[NSNumber numberWithInteger:userId.integerValue]  success:^(id object) {

            NSMutableArray *array = [object mutableCopy];
            
            [array removeObject:self.cargo];
            
            popupMode = PopupModeMove;
            trackItemRecord = array;
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

- (void)switchTabButtonStateChange:(BOOL)isOn {
    
    for (NSNumber *number in collectionItemsState.allKeys) {
        NSDictionary *item = collectionItemsState[number];
        NSMutableDictionary *status = item[kStateStatus];
        status[kStateShowUpdate] = [NSNumber numberWithBool:isOn];
    }
    [_collectionView reloadData];
}

- (void)editTabButtonTapped {
    [self chageEditMode:YES];
}

- (void)chageEditMode:(BOOL)editMode {
    isInEditMode = editMode;
    _editModeView.hidden = !isInEditMode;
    _editView.hidden = isInEditMode;
    _collectionView.backgroundColor = isInEditMode?[UIColor whiteColor]:[UIColor clearColor];
    [_collectionView reloadData];
    
    if (!isInEditMode) {
        _constraintEditViewHeight.constant = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)selectedEditTabButton:(EditTabItem)item {
    [self chageEditMode:NO];

    /*
    if (item == EditTabItemCancel) {
        
    } else {
        
        if (![self hasSelectedItemForEdit]) {
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"PROJECT_TRACK_SELECTION_NONE")];
            return;
        }
        
    }
    
*/
}

-(void)tappedProjectNav:(ProjectNavItem)projectNavItem {
    if (projectNavItem == ProjectNavBackButton) {

        [self.navigationController popViewControllerAnimated:YES];
    
    } else {
    
        popupMode = PopupModeSort;
        PopupViewController *controller = [PopupViewController new];
        CGRect rect = [controller getViewPositionFromViewController:[_topBar reOrderButton] controller:self];
        rect.size.height =  rect.size.height * 0.85;
        controller.popupRect = rect;
        controller.popupWidth = 0.98;
        controller.isGreyedBackground = YES;
        controller.customCollectionViewDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:NO completion:nil];
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

#pragma mark - ProjectTrackItemViewDelegate

-(void)tappedButtonExpand:(id)object view:(id)view{
  
    ProjectTrackItemCollectionViewCell *cell = (ProjectTrackItemCollectionViewCell*)view;
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];

}

-(void)tappedTrackingListItem:(id)object view:(UIView *)view {
    
    NSIndexPath *indexPath = object;
    NSMutableDictionary *track = [trackItemRecord[indexPath.row] mutableCopy];
    
    NSMutableArray *ids = [track[@"projectIds"] mutableCopy];
    [ids addObjectsFromArray:[self selectedItemForEdit]];
    track[@"projectIds"] = ids;
    
    [[DataManager sharedManager] projectTrackingMoveIds:track[@"id"] recordIds:track success:^(id object) {
        [[DataManager sharedManager] dismissPopup];
    } failure:^(id object) {
        
    }];
    
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
        
        BOOL isDesc = indexPath.row != 4;
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kSortKey[indexPath.row-1] ascending:isDesc];
        
        self.collectionItems = [self.collectionItems sortedArrayUsingDescriptors:@[descriptor]];
        [_collectionView reloadData];
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

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cellItem = nil;
    
    if (!isInEditMode) {
        
        ProjectTrackItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];;
        cell.projectTrackItemViewDelegate = self;
        [cell setInfo:collectionItemsState[ [self getProjectId:indexPath]]];
        cellItem = cell;
        
    } else {
        
        ProjectTrackEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierEdit forIndexPath:indexPath];;
        [cell setInfo:collectionItemsState[ [self getProjectId:indexPath]]];
        cellItem = cell;
        
    }
    [[cellItem contentView] setFrame:[cellItem bounds]];
    [[cellItem contentView] layoutIfNeeded];
    
    return cellItem;
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

    CGFloat cellHeight = 0;
    NSDictionary *state = collectionItemsState[ [self getProjectId:indexPath]][kStateStatus];

    if (!isInEditMode) {
        CGFloat multiplier = 0.134;
        
        if ([state[kStateShowUpdate] boolValue]) {
            
            if ([state[kStateUpdateType] integerValue] != ProjectTrackUpdateTypeNone) {
                multiplier = 0.21;
                if ([state[kStateExpanded] boolValue]) {
                    multiplier = 0.278;
                }
            }
        }
        
        cellHeight = kDeviceHeight * multiplier;
    } else {
        cellHeight = kDeviceHeight * 0.1;
    }
    
    size = CGSizeMake( kDeviceWidth * (!isInEditMode?0.97:1.0), cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return !isInEditMode?UIEdgeInsetsMake(kDeviceWidth * 0.025, 0, kDeviceWidth * 0.025, 0):UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceHeight * (isInEditMode?0:0.01);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isInEditMode) {
        
        NSMutableDictionary *item = collectionItemsState[ [self getProjectId:indexPath]];
        NSMutableDictionary *stateItem = item[kStateStatus];
        BOOL isSelected = [stateItem[kStateSelected] boolValue];
        stateItem[kStateSelected] = [NSNumber numberWithBool:!isSelected];
        
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
  
        NSArray *selectedItems = [self selectedItemForEdit];
        _constraintEditViewHeight.constant = kDeviceHeight * (selectedItems.count>0?0.09:0);
        
        [_selectMoveView setSelectionCount:selectedItems.count];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];

    }
}

#pragma mark - Misc Methods

- (NSArray*)selectedItemForEdit {
    NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
    
    for (NSNumber *number in collectionItemsState.allKeys) {
        NSDictionary *item = collectionItemsState[number];

        NSDictionary *data = item[kStateData];
        NSNumber *recordId = data[@"id"];
        
        NSMutableDictionary *status = item[kStateStatus];
        if ([status[kStateSelected] boolValue]) {
            [selectedItems addObject:recordId];
        } ;
    }

    return selectedItems;
}

- (NSNumber*)getProjectId:(NSIndexPath*)indexPath {
    NSDictionary *dict = self.collectionItems[indexPath.row];
    return (NSNumber*)dict[@"id"];
}
                                               
@end

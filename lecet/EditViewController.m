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
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *navView;
@property (weak, nonatomic) IBOutlet EditTabView *tabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEditViewHeight;
@property (weak, nonatomic) IBOutlet SelectMoveView *selectMoveView;
@property (weak, nonatomic) IBOutlet EditViewList *editViewList;

@end

@implementation EditViewController

#define BOTTOMVIEW_BG_COLOR RGB(5, 35, 74)
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:[[self class] description] bundle:nibBundleOrNil];
    return self;
}

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
    NSString *countString = [NSString stringWithFormat:@"%lu %@",(unsigned long)collectionDataItems.count,NSLocalizedLanguage(@"COMPANIES_COUNT_TITLE")];
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
            CompanySortViewController *controller = [CompanySortViewController new];
            controller.companySortDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:controller  animated:NO completion:nil];
            break;
        }
            
    }
}

#pragma mark - EdittabViewDelgate

- (void)selectedEditTabButton:(EditTabItem)item {

    
    switch (item) {
        case EditTabItemCancel:{
            [self unCheckedAllChekedBox];
            break;
        }
        case EditTabItemDone:{
            
            [self dismissViewControllerAnimated:NO completion:^{
                [_editViewControllerDelegate tappedCancelDoneButton:collectionDataItems];
            }];
            break;
        }
    }
    
    

}

- (void)unCheckedAllChekedBox {
    
    NSOperationQueue* queue= [NSOperationQueue new];
    queue.maxConcurrentOperationCount=1;
    [queue setSuspended: YES];
    
    NSMutableArray *tempArray = collectionDataItems;
    [collectionDataItems enumerateObjectsUsingBlock:^(id response,NSUInteger index,BOOL *stop){
        NSMutableDictionary *dict = [response mutableCopy];

        [dict setValue:@"0" forKey:COMPANYDATA_SELECTION_FLAG];
    
        NSBlockOperation* op=[NSBlockOperation blockOperationWithBlock: ^ (void)
                              {
                                  [tempArray replaceObjectAtIndex:index withObject:dict];
                                  
                              }];
        [queue addOperation: op];
        
        
    }];
    
    [queue setSuspended: NO];
    [queue waitUntilAllOperationsAreFinished];
    
    [_editViewList setInfoToReload:collectionDataItems];
    
    selectedDataItems = nil;
    [self chageEditMode:NO count:(int)selectedDataItems.count];
    
    
}

#pragma mark - Misc Method

- (void)chageEditMode:(BOOL)editMode count:(int)count{
    isInEditMode = editMode;
    

   
    if (!isInEditMode) {
        _constraintEditViewHeight.constant = 0;
        CGFloat heightPopUpView = kDeviceHeight * (count > 0?0.09:0);
        
        [UIView animateWithDuration:0.25 animations:^{
            _constraintEditViewHeight.constant = heightPopUpView;
            
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

#pragma mark - Custom Delegates

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
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:NSLocalizedLanguage(@"COMPANY_TRACK_SELECTION_REMOVE"), trackingInfo[@"name"]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_YES")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                              [self removeItem];
                                                              
                                                          }];
        
        [alert addAction:yesAction];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_NO")
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             
                                                         }];
        
        [alert addAction:noAction];
        
        [[DataManager sharedManager] dismissPopup];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}

- (void)removeItem {
    
    NSMutableDictionary *currentCargo = [trackingInfo mutableCopy];
    NSMutableArray *currentIds = [currentCargo[@"companyIds"] mutableCopy];
    [currentIds removeObjectsInArray:selectedDataItems];
    currentCargo[@"companyIds"] = currentIds;
    
    [[DataManager sharedManager] companyTrackingMoveIds:currentCargo[@"id"] recordIds:currentCargo success:^(id object) {
        
        NSMutableArray *movedItems = [[NSMutableArray alloc] init];
        
        [collectionDataItems enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
            NSNumber *recordID = obj[@"id"];
            if ([selectedDataItems containsObject:recordID]) {
                [movedItems addObject:obj];
            }
        }];
        
        if (movedItems.count > 0) {
            [collectionDataItems removeObjectsInArray:movedItems];
        }
        
        
         NSString *countString = [NSString stringWithFormat:@"%lu %@",(unsigned long)collectionDataItems.count,NSLocalizedLanguage(@"COMPANIES_COUNT_TITLE")];
        [_navView setProjectTitle:countString];
        [_editViewList setInfoToReload:collectionDataItems];
        [self chageEditMode:NO count:(int)collectionDataItems.count];
        
        
    } failure:^(id object) {
      
    }];
    
}

- (NSArray *)companyTrackingListToMove:(NSArray *)object {
    NSOperationQueue* queue= [NSOperationQueue new];
    queue.maxConcurrentOperationCount=1;
    [queue setSuspended: YES];
    NSMutableArray *mutableObject = [object mutableCopy];
    
    [mutableObject enumerateObjectsUsingBlock:^(id obj, NSUInteger index,BOOL *stop){
        
        if ([trackingInfo[@"id"] isEqual:obj[@"id" ]]) {
            
            NSBlockOperation* op =
            [NSBlockOperation blockOperationWithBlock: ^ (void) { [mutableObject removeObject:obj]; }];
            [queue addOperation: op];
            
        }
        
    }];
    
    [queue setSuspended: NO];
    [queue waitUntilAllOperationsAreFinished];
  
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
        [cellItem setInfo:trackItemRecord withTitle:NSLocalizedLanguage(@"COMPANY_TRACKING_LIST")];
        
    }
    
}


#pragma mark - Tracking Delegate

- (void)tappedTrackingListItem:(id)object view:(UIView *)view {
    
    NSIndexPath *indexPath = object;
    
    NSMutableDictionary *track = [trackItemRecord[indexPath.row] mutableCopy];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:NSLocalizedLanguage(@"COMPANY_TRACK_SELECTION_MOVE"), track[@"name"]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_YES")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          [self moveTrackListIds:indexPath];
                                                          
                                                      }];
    
    [alert addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_NO")
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction *action) {
                                                         
                                                     }];
    
    [alert addAction:noAction];
    
    [[DataManager sharedManager] dismissPopup];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)moveTrackListIds:(NSIndexPath*)indexPath {
 
    NSMutableDictionary *track = [trackItemRecord[indexPath.row] mutableCopy];
    NSMutableArray *ids = [track[@"companyIds"] mutableCopy];
    
    [selectedDataItems enumerateObjectsUsingBlock:^(id obj,NSUInteger countInt,BOOL *stop){
        
        if ([ids containsObject:obj]) {
            [ids removeObject:obj];
        }
        [ids addObject:obj];
        
        
    }];
    track[@"companyIds"] = ids;
    NSMutableDictionary *currentCargo = [trackingInfo mutableCopy];
    NSMutableArray *currentIds = [currentCargo[@"companyIds"] mutableCopy];
    [currentIds removeObjectsInArray:selectedDataItems];
    currentCargo[@"companyIds"] = currentIds;
    trackingInfo = currentCargo;
    
    [[DataManager sharedManager] companyTrackingMoveIds:track[@"id"] recordIds:track success:^(id object) {
        [[DataManager sharedManager] dismissPopup];
        
        [[DataManager sharedManager] companyTrackingMoveIds:currentCargo[@"id"] recordIds:currentCargo success:^(id object) {
            
            NSMutableArray *movedItems = [[NSMutableArray alloc] init];
            [collectionDataItems enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
                NSNumber *recordID = obj[@"id"];
                if ([selectedDataItems containsObject:recordID]) {
                    [movedItems addObject:obj];
                }
            }];
            
            if (movedItems.count > 0) {
                [collectionDataItems removeObjectsInArray:movedItems];
            }
            
            [_editViewList setInfoToReload:collectionDataItems];
            selectedDataItems = nil;
            [self chageEditMode:NO count:(int)selectedDataItems.count];

            
            [_navView setProjectTitle:[NSString stringWithFormat:@"%lu %@",(unsigned long)collectionDataItems.count,NSLocalizedLanguage(@"COMPANIES_COUNT_TITLE")]];
            
        } failure:^(id object) {
            
        }];

    } failure:^(id object) {
        
    }];

}

@end

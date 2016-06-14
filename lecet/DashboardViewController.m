//
//  DashboardViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DashboardViewController.h"

#import "dashboardConstants.h"
#import "CustomCalendar.h"
#import "CalendarItem.h"
#import "DB_BidSoon.h"
#import "DB_BidRecent.h"
#import "DB_Bid.h"
#import "DB_Project.h"
#import "MenuHeaderView.h"
#import "BidItemView.h"
#import "BidSoonItem.h"
#import "BidItemRecent.h"
#import "BidItemCollectionViewCell.h"
#import "BidSoonItemCollectionViewCell.h"
#import "CalendarItemCollectionViewCell.h"
#import "BitItemRecentCollectionViewCell.h"
#import "ProjectDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "PushZoomAnimator.h"
#import "ChartView.h"
#import "chartConstants.h"
#import "MoreMenuViewController.h"
#import "ProjectsNearMeViewController.h"
#import "SettingsViewController.h"
#import "MyProfileViewController.h"
#import "HiddenProjectsViewController.h"

@interface DashboardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,CustomCalendarDelegate, UIScrollViewDelegate, BidCollectionItemDelegate, BidSoonCollectionItemDelegate, MenuHeaderDelegate, UINavigationControllerDelegate, ChartViewDelegate, BitItemRecentDelegate,MoreMenuViewControllerDelegate, SettingsViewControllerDelegate>{

    NSDate *currentDate;
    NSInteger currentPage;
    NSMutableArray *bidItemsRecentlyMade;
    NSMutableArray *bidItemsHappeningSoon;
    NSMutableArray *bidItemsRecentlyAdded;
    NSMutableArray *bidItemsRecentlyUpdated;
    NSMutableArray *currentBidItems;
    NSMutableDictionary *bidMarker;
    BOOL shouldUsePushZoomAnimation;
    CGRect originatingFrame;
    NSDictionary *profileInfo;
    BOOL isDoneLoadingRecentlyAdded;
}
@property (weak, nonatomic) IBOutlet ChartView *chartRecentlyMade;
@property (weak, nonatomic) IBOutlet ChartView *chartRecentlyUpdated;
@property (weak, nonatomic) IBOutlet ChartView *chartRecentlyAdded;
@property (weak, nonatomic) IBOutlet UICollectionView *bidsCollectionView;
@property (weak, nonatomic) IBOutlet CustomCalendar *calendarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet MenuHeaderView *menuHeader;
@property (weak,nonatomic) IBOutlet UIView *dimDropDownMenuBackgroundView;
@end

@implementation DashboardViewController
#define kCellIdentifier         @"kCellIdentifier"
#define kCellIdentifierSoon     @"kCellIdentifierSoon"
#define kCellIdentifierRecent   @"kCellIdentifierRecent"
#define kCategory               @[@(101), @(102), @(103), @(105)]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bidItemsHappeningSoon = [NSMutableArray new];
    self.view.backgroundColor = DASHBOARD_BG_COLOR;
    
    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BidItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BidSoonItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierSoon];
    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BitItemRecentCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierRecent];
    _bidsCollectionView.backgroundColor = DASHBOARD_BIDS_BG_COLOR;
    
    currentDate = [DerivedNSManagedObject dateFromDayString:[DerivedNSManagedObject dateStringFromDateDay:[NSDate date]]];
    [_calendarView setCalendarDate:currentDate];
    
    currentPage = 0;
    _scrollPageView.delegate = self;
    _bidsCollectionView.delegate = self;
    _bidsCollectionView.dataSource = self;
    _chartRecentlyMade.chartViewDelegate = self;
    _chartRecentlyUpdated.chartViewDelegate = self;
    _chartRecentlyAdded.chartViewDelegate = self;

    currentBidItems = [self loadBidsRecentlyMade];
    [self requestBidsHappeningSoon];
    [self requestBidRecentlyUpdated];
    [self requestBidRecentlyAdded];
    
    [_menuHeader setTitleFromCount:currentBidItems.count title:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_MADE_TEXT")];
    [_bidsCollectionView reloadData];

    [_calendarView reloadData];
 
    _pageControl.numberOfPages = 4;
    _menuHeader.menuHeaderDelegate = self;
    
    [_chartRecentlyMade hideLeftButton:YES];
    [_chartRecentlyUpdated hideRightButton:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - CHART ROUTINES

- (void)createSegmentTagForChart:(NSMutableDictionary*)segment count:(NSInteger)count {
    for (NSString *key in segment.allKeys) {
        NSMutableDictionary *item = segment[key];
        NSNumber *number = item[CHART_SEGMENT_COUNT];
        switch (key.integerValue) {
            case 101:{
                item[CHART_SEGMENT_TAG] = kTagNameEngineering;
                item[CHART_SEGMENT_COLOR] = CHART_BUTTON_ENGINEERING_COLOR;;
                item[CHART_SEGMENT_IMAGE] = [UIImage imageNamed:@"icon_engineering"];
                break;
            }
            case 102: {
                item[CHART_SEGMENT_TAG] = kTagNameBuilding;
                item[CHART_SEGMENT_COLOR] = CHART_BUTTON_BUILDING_COLOR;;
                item[CHART_SEGMENT_IMAGE] = [UIImage imageNamed:@"icon_building"];
                break;
            }
            case 103: {
                item[CHART_SEGMENT_TAG] = kTagNameHousing;
                item[CHART_SEGMENT_COLOR] = CHART_BUTTON_HOUSING_COLOR;;
                item[CHART_SEGMENT_IMAGE] = [UIImage imageNamed:@"icon_housing"];
                break;
            }
            case 105: {
                item[CHART_SEGMENT_TAG] = kTagNameUtilities;
                item[CHART_SEGMENT_COLOR] = CHART_BUTTON_UTILITIES_COLOR;
                item[CHART_SEGMENT_IMAGE] = [UIImage imageNamed:@"icon_utilities"];
                break;
            }
        }
        
        NSNumber *percentage = @((number.floatValue/count)*100.0);
        item[CHART_SEGMENT_PERCENTAGE] = percentage;
    }
}

- (NSMutableArray*)loadBidsRecentlyMade {
    
    NSMutableDictionary *segment = [[NSMutableDictionary alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentMade == YES AND relationshipProject.projectGroupId IN %@", kCategory];
    bidItemsRecentlyMade = [[DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO] mutableCopy];
    
    for (DB_Bid *item in bidItemsRecentlyMade) {
        
        NSString *tag = [NSString stringWithFormat:@"%li", (long)item.relationshipProject.projectGroupId.integerValue];
        NSMutableDictionary *itemDict = segment[tag];
        
        if (itemDict == nil) {
            itemDict = [@{CHART_SEGMENT_COUNT:@(0)} mutableCopy];
        }
        NSNumber *number = itemDict[CHART_SEGMENT_COUNT];
        itemDict[CHART_SEGMENT_COUNT] = @(number.integerValue + 1);
        segment[tag] = itemDict;
        
    }
    
    [self createSegmentTagForChart:segment count:bidItemsRecentlyMade.count];
    [_chartRecentlyMade setSegmentItems:segment];

    return bidItemsRecentlyMade;
}

- (NSMutableArray*)requestBidsHappeningSoon {

    _calendarView.customCalendarDelegate = nil;

    [[DataManager sharedManager] bidsHappeningSoon:30 success:^(id object) {
        [self loadBidsHappeningSoon];
        _calendarView.customCalendarDelegate = self;
        [_calendarView reloadData];

    } failure:^(id object) {
        
    }];

    return bidItemsHappeningSoon;
}

- (NSMutableArray*)loadBidsHappeningSoon {
    
    if (bidMarker == nil) {
        bidMarker = [[NSMutableDictionary alloc] init];
    }
    [bidMarker removeAllObjects];
    [bidItemsHappeningSoon removeAllObjects];

    NSString *yearMonth = [DB_BidSoon yearMonthFromDate:currentDate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHappenSoon == YES AND bidYearMonth == %@",yearMonth];
    bidItemsHappeningSoon = [[DB_Project fetchObjectsForPredicate:predicate key:@"bidDate" ascending:NO] mutableCopy];
    
    for (DB_Project *item in bidItemsHappeningSoon) {
        bidMarker[item.bidYearMonthDay] = @"";
    }

    return bidItemsHappeningSoon;
}

- (void)requestBidRecentlyUpdated {
    
    [[DataManager sharedManager] bidsRecentlyUpdated:300 success:^(id object) {
        [self loadBidsRecentlyUpdated];
    } failure:^(id object) {
        
    }];
}

- (void)requestBidRecentlyAdded {
    
    isDoneLoadingRecentlyAdded = NO;
    [[DataManager sharedManager] bidsRecentlyAddedLimit:currentDate success:^(id object) {
        [self loadBidsRecentlyAdded];
        isDoneLoadingRecentlyAdded = YES;
        
        if (currentPage == 2) {
            [self pageChangedForced:YES];
        }
    } failure:^(id object) {
        
    }];
}


- (NSMutableArray*)loadBidsRecentlyUpdated {
    
    NSMutableDictionary *segment = [[NSMutableDictionary alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentUpdate == YES AND projectGroupId IN %@", kCategory];
    bidItemsRecentlyUpdated = [[DB_Project fetchObjectsForPredicate:predicate key:@"lastPublishDate" ascending:NO] mutableCopy];
    
    
    for (DB_Project *item in bidItemsRecentlyUpdated) {
        
        NSString *tag = [NSString stringWithFormat:@"%li", (long)item.projectGroupId.integerValue];
        NSMutableDictionary *itemDict = segment[tag];
        
        if (itemDict == nil) {
            itemDict = [@{CHART_SEGMENT_COUNT:@(0)} mutableCopy];
        }
        NSNumber *number = itemDict[CHART_SEGMENT_COUNT];
        itemDict[CHART_SEGMENT_COUNT] = @(number.integerValue + 1);
        segment[tag] = itemDict;
        
    }
    
    [self createSegmentTagForChart:segment count:bidItemsRecentlyUpdated.count];
    [_chartRecentlyUpdated setSegmentItems:segment];
    return bidItemsRecentlyUpdated;
}

- (NSMutableArray*)loadBidsRecentlyAdded {
    
    NSMutableDictionary *segment = [[NSMutableDictionary alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentAdded == YES AND projectGroupId IN %@", kCategory];
    bidItemsRecentlyAdded = [[DB_Project fetchObjectsForPredicate:predicate key:@"lastPublishDate" ascending:NO] mutableCopy];
    
    for (DB_Project *item in bidItemsRecentlyAdded) {
        
        NSString *tag = [NSString stringWithFormat:@"%li", (long)item.projectGroupId.integerValue];
        NSMutableDictionary *itemDict = segment[tag];
        
        if (itemDict == nil) {
            itemDict = [@{CHART_SEGMENT_COUNT:@(0)} mutableCopy];
        }
        NSNumber *number = itemDict[CHART_SEGMENT_COUNT];
        itemDict[CHART_SEGMENT_COUNT] = @(number.integerValue + 1);
        segment[tag] = itemDict;
        
    }
    
    [self createSegmentTagForChart:segment count:bidItemsRecentlyAdded.count];
    [_chartRecentlyAdded setSegmentItems:segment];
    return bidItemsRecentlyAdded;
}



#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    switch (currentPage) {
        case 0 : {
            BidItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
            
            NSMutableArray *array = (NSMutableArray*)currentBidItems;
            [cellItem setItemInfo:array[indexPath.row]];
            cellItem.bidCollectionitemDelegate = self;
            cell = cellItem;
            break;
        }
        case 1: {
            BidSoonItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierSoon forIndexPath:indexPath];
            
            NSMutableArray *array = (NSMutableArray*)currentBidItems;
            [cellItem setItemInfo:array[indexPath.row]];
            cellItem.bidSoonCollectionItemDelegate = self;
            cell = cellItem;
            break;
           break;
        }
        default: {
            BitItemRecentCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierRecent forIndexPath:indexPath];
            
            NSMutableArray *array = (NSMutableArray*)currentBidItems;
            [cellItem setInfo:array[indexPath.row]];
            cellItem.bitItemRecentDelegate = self;
            cell = cellItem;
            break;
        }
    }
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (currentBidItems != nil) {
        count = currentBidItems.count;
    }
    
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellWidth =  kDeviceWidth * 0.39;
    CGFloat cellHeight = _bidsCollectionView.frame.size.height - (_bidsCollectionView.frame.size.height * 0.06);
    size = CGSizeMake( cellWidth, cellHeight);
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

#pragma mark CustomCalendar Delegate

- (void)tappedItem:(id)object {
    CalendarItem *calendarItem = object;
    
    CalendarItemState state = [calendarItem getState] != CalendarItemStateSelected ? CalendarItemStateSelected : [calendarItem getInitialState];
    [_calendarView clearSelection];
    [calendarItem setItemState:state];

    NSString *itemtag = [calendarItem itemTag];
    
    if (state == CalendarItemStateSelected) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bidYearMonthDay == %@", itemtag];
        
        currentBidItems = [[DB_Project fetchObjectsForPredicate:predicate key:@"bidDate" ascending:YES] mutableCopy];

    } else {
        currentBidItems = bidItemsHappeningSoon;
    }
    
    [_bidsCollectionView reloadData];
}

- (void)calendarItemWillDisplay:(id)object {
    CalendarItem *item = object;
    
    NSString *itemTag = [item itemTag];
    if (itemTag != nil) {
        
        NSDictionary *bidDate = bidMarker[itemTag];
        
        [item setInitialState: bidDate!=nil?CalendarItemStateMarked:CalendarItemStateActive];
    }
}

#pragma mark ScrollView Delegate

- (void)pageChangedForced:(BOOL)forced{
    
    int page = _scrollPageView.contentOffset.x / _scrollPageView.frame.size.width;

    if ((page != currentPage) | forced) {
        currentPage = page;
        
        _pageControl.currentPage = currentPage;

        switch (currentPage) {
            case 0: {
                currentBidItems = bidItemsRecentlyMade;
                [_menuHeader setTitleFromCount:currentBidItems.count  title:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_MADE_TEXT")];
                break;
            }
            case 1: {
                [_calendarView clearSelection];
                
                [self loadBidsHappeningSoon];
                currentBidItems = bidItemsHappeningSoon;

                _calendarView.customCalendarDelegate = self;
                [_calendarView reloadData];

                [_menuHeader setTitleFromCount:currentBidItems.count title:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_SOON_TEXT")];
                break;
            }
            case 2: {
                
                if (bidItemsRecentlyAdded == nil) {
                    bidItemsRecentlyAdded = [NSMutableArray new];
                }
                currentBidItems = bidItemsRecentlyAdded;
                
                [_menuHeader setTitleFromCount:currentBidItems.count title:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_ADDED_TEXT")];
                
                break;
            }
            case 3: {
                currentBidItems = [self loadBidsRecentlyUpdated];
                
                [_menuHeader setTitleFromCount:currentBidItems.count title:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_UPDATED_TEXT")];
                
                break;
                
            }
        }
        
        [_bidsCollectionView reloadData];
        
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pageChangedForced:NO];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self pageChangedForced:NO];
}


# pragma mark - BID COLLECTION DELEGATE

- (void)tappedBidCollectionItem:(id)object {
    BidItemView *item = object;
    BidItemCollectionViewCell *cell = (BidItemCollectionViewCell*)[[item superview] superview];

    _bidsCollectionView.userInteractionEnabled = NO;
    [[DataManager sharedManager] projectDetail:[item getProjectRecordId] success:^(id object) {
        [self showProjectDetails:object fromRect:cell.frame];
        _bidsCollectionView.userInteractionEnabled = YES;
    } failure:^(id object) {
        _bidsCollectionView.userInteractionEnabled = YES;
    }];
}

- (void)tappedBidSoonCollectionItem:(id)object {
    BidSoonItem *item = object;
    BidSoonItemCollectionViewCell * cell = (BidSoonItemCollectionViewCell*)[[item superview] superview];
    
    _bidsCollectionView.userInteractionEnabled = NO;
    [[DataManager sharedManager] projectDetail:[item getRecordId] success:^(id object) {
        [self showProjectDetails:object fromRect:cell.frame];
        _bidsCollectionView.userInteractionEnabled = YES;
    } failure:^(id object) {
        _bidsCollectionView.userInteractionEnabled = YES;
    }];

}

- (void)showProjectDetails:(id)record fromRect:(CGRect)rect {
    
    CGRect collectionViewRect = _bidsCollectionView.frame;
    CGFloat offset = _bidsCollectionView.contentOffset.x;
    rect.origin.x -= offset;
    rect.origin.y += collectionViewRect.origin.y;
    
    shouldUsePushZoomAnimation = YES;
    originatingFrame = rect;

    ProjectDetailViewController *detail = [ProjectDetailViewController new];
    detail.view.hidden = NO;

    if ([record class] == [DB_Project class]) {
        [detail detailsFromProject:record];
    }
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

- (void)tappedMenu:(MenuHeaderItem)menuHeaderItem {
 
    switch (menuHeaderItem) {
        case MenuHeaderNear:{

            shouldUsePushZoomAnimation = NO;
            [self.navigationController pushViewController:[ProjectsNearMeViewController new] animated:YES];
            
            break;
        }
        case MenuHeaderTrack: {

            [[DataManager sharedManager] featureNotAvailable];
            break;
        
        }
        case MenuHeaderSearch:{
          
            [[DataManager sharedManager] featureNotAvailable];
            break;
        
        }
        case MenuHeaderMore:{
            
            [self showDropDownMenu];
            break;
        
        }
    }
}

- (void)tappedBitItemRecent:(id)object {
    BidItemRecent *item = object;
    BitItemRecentCollectionViewCell * cell = (BitItemRecentCollectionViewCell*)[[item superview] superview];
    
    _bidsCollectionView.userInteractionEnabled = NO;
    [[DataManager sharedManager] projectDetail:[item getRecordId] success:^(id object) {
        [self showProjectDetails:object fromRect:cell.frame];
        _bidsCollectionView.userInteractionEnabled = YES;
    } failure:^(id object) {
        _bidsCollectionView.userInteractionEnabled = YES;
    }];

}


#pragma mark - DropDown Menu More Delegate and Method
- (void)tappedDropDownMenu:(DropDownMenuItem)menuDropDownItem {

    shouldUsePushZoomAnimation = NO;
    
    switch (menuDropDownItem) {
            
        case DropDownMenuMyProfile:{
            
            MyProfileViewController *controller = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
            [controller setInfo:profileInfo];
            [self.navigationController pushViewController:controller animated:YES];
            break;
            
        }
            
        case DropDownMenuHiddenProjects: {
            
            HiddenProjectsViewController *controller = [HiddenProjectsViewController new];
            controller.collectionItems = [@[@"", @"", @"", @""] mutableCopy];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        
        }
            
        case DropDownMenuSettings:{
            SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            controller.settingsViewControllerDelegate = self;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
    }
    
}

- (void)showDropDownMenu{
    
    NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];

    [[DataManager sharedManager] userInformation:[NSNumber numberWithInteger:userId.integerValue] success:^(id object) {

        profileInfo = object;
        MoreMenuViewController *controller  = [MoreMenuViewController new];
        controller.moreMenuViewControllerDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [controller setInfo:profileInfo];
        [self presentViewController:controller  animated:NO completion:nil];
        
    } failure:^(id object) {
        
    }];

}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (id<UIViewControllerAnimatedTransitioning>)animationObjectForOperation:(UINavigationControllerOperation)operation {
    if (shouldUsePushZoomAnimation) {
        PushZoomAnimator *animator = [[PushZoomAnimator alloc] init];
        animator.willPop = operation!=UINavigationControllerOperationPush;
        if (!animator.willPop){
            animator.startRect = originatingFrame;
            animator.endRect = self.view.frame;
        } else {
            animator.startRect = self.view.frame;
            animator.endRect = originatingFrame;
        }
        return animator;
    }
    return nil;
}

#pragma mark - ChartView Delegate

- (void)displayChartItemsForRecentlyMade:(NSString*)itemTag hasFocus:(BOOL)hasFocus {
    if (itemTag != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentMade == YES"];
        
        if (hasFocus) {
            
            NSInteger category = 0;
            if([itemTag isEqualToString:@"01_HOUSING"]) {
                category = 103;
            } else if ([itemTag isEqualToString:@"02_ENGINEERING"]){
                category = 101;
            } else if ([itemTag isEqualToString:@"03_BUILDING"]){
                category = 102;
            } else if ([itemTag isEqualToString:@"04_UTILITIES"]){
                category = 105;
            }
            
            predicate = [NSPredicate predicateWithFormat:@"relationshipProject.projectGroupId == %li AND isRecentMade == YES", category];
        }
        
        bidItemsRecentlyMade = [[DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO] mutableCopy];
        
        currentBidItems = bidItemsRecentlyMade;
        
        [_bidsCollectionView reloadData];
    }
}

- (void)displayChartItemsForRecentlyUpdated:(NSString*)itemTag hasFocus:(BOOL)hasFocus {
    if (itemTag != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentUpdate == YES"];
        
        if (hasFocus) {
            
            NSInteger category = 0;
            if([itemTag isEqualToString:@"01_HOUSING"]) {
                category = 103;
            } else if ([itemTag isEqualToString:@"02_ENGINEERING"]){
                category = 101;
            } else if ([itemTag isEqualToString:@"03_BUILDING"]){
                category = 102;
            } else if ([itemTag isEqualToString:@"04_UTILITIES"]){
                category = 105;
            }
            
            predicate = [NSPredicate predicateWithFormat:@"projectGroupId == %li AND isRecentUpdate == YES", category];
        }
        
        bidItemsRecentlyUpdated = [[DB_Project fetchObjectsForPredicate:predicate key:@"lastPublishDate" ascending:NO] mutableCopy];
        
        currentBidItems = bidItemsRecentlyUpdated;
        
        [_bidsCollectionView reloadData];
    }
}

- (void)displayChartItemsForRecentlyAdded:(NSString*)itemTag hasFocus:(BOOL)hasFocus {
    if (itemTag != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentAdded == YES"];
        
        if (hasFocus) {
            
            NSInteger category = 0;
            if([itemTag isEqualToString:@"01_HOUSING"]) {
                category = 103;
            } else if ([itemTag isEqualToString:@"02_ENGINEERING"]){
                category = 101;
            } else if ([itemTag isEqualToString:@"03_BUILDING"]){
                category = 102;
            } else if ([itemTag isEqualToString:@"04_UTILITIES"]){
                category = 105;
            }
            
            predicate = [NSPredicate predicateWithFormat:@"projectGroupId == %li AND isRecentAdded == YES", category];
        }
        
        bidItemsRecentlyAdded = [[DB_Project fetchObjectsForPredicate:predicate key:@"lastPublishDate" ascending:NO] mutableCopy];
        
        currentBidItems = bidItemsRecentlyAdded;
        
        [_bidsCollectionView reloadData];
    }
}

- (void)selectedItemChart:(NSString *)itemTag chart:(id)chart hasfocus:(BOOL)hasFocus {
    
    if ([chart isEqual:_chartRecentlyMade]) {
        [self displayChartItemsForRecentlyMade:itemTag hasFocus:hasFocus];
    } else if([chart isEqual:_chartRecentlyUpdated]) {
        [self displayChartItemsForRecentlyUpdated:itemTag hasFocus:hasFocus];
    } else {
        [self displayChartItemsForRecentlyAdded:itemTag hasFocus:hasFocus];
    }
}

- (void)tappedChartNavButton:(ChartButton)charButton {
    [self scrollDisplayView:charButton == ChartButtonLeft];
}

- (void)tappedCalendarNavButton:(CalendarButton)calendarButton {
    [self scrollDisplayView:calendarButton == CalendarButtonLeft];
}

- (void)scrollDisplayView:(BOOL)isLeft {

    NSInteger currentPageOffset = _scrollPageView.contentOffset.x;
    if (isLeft) {
        if (currentPageOffset>=kDeviceWidth) {
            [_scrollPageView scrollRectToVisible:CGRectMake(currentPageOffset-kDeviceWidth, 0, kDeviceWidth, _scrollPageView.frame.size.height) animated:YES];
        }
    } else {
        if (currentPageOffset<_scrollPageView.contentSize.width) {
            [_scrollPageView scrollRectToVisible:CGRectMake(currentPageOffset+kDeviceWidth, 0, kDeviceWidth, _scrollPageView.frame.size.height) animated:YES];
        }
    }
}

- (void)tappedLogout {  
    [self.dashboardViewControllerDelegate logout];
}

@end

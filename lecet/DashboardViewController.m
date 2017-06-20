//
//  DashboardViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DashboardViewController.h"

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
#import "MoreMenuViewController.h"
#import "ProjectsNearMeViewController.h"
#import "SettingsViewController.h"
#import "MyProfileViewController.h"
#import "HiddenProjectsViewController.h"
#import "PopupViewController.h"
#import "CustomCollectionView.h"
#import "TrackingListCellCollectionViewCell.h"
#import "TrackingListView.h"
#import "ProjectTrackingViewController.h"
#import "CompanyTrackingListViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "CustomActivityIndicatorView.h"

#define DASHBOARD_BG_COLOR                      RGB(9, 49, 97)
#define DASHBOARD_BIDS_BG_COLOR                 RGB(245, 245, 245)

@interface DashboardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,CustomCalendarDelegate, UIScrollViewDelegate, BidCollectionItemDelegate, BidSoonCollectionItemDelegate, MenuHeaderDelegate, UINavigationControllerDelegate, ChartViewDelegate, BitItemRecentDelegate,MoreMenuViewControllerDelegate, SettingsViewControllerDelegate, CustomCollectionViewDelegate, TrackingListViewDelegate>{

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
    NSMutableDictionary *trackingListInfo;
    TrackingListCellCollectionViewCell *trackList[2];
    
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
@property (weak, nonatomic) IBOutlet CustomActivityIndicatorView *customLoadingIndicator;

@end

@implementation DashboardViewController
#define kCellIdentifier         @"kCellIdentifier"
#define kCellIdentifierSoon     @"kCellIdentifierSoon"
#define kCellIdentifierRecent   @"kCellIdentifierRecent"
#define kTrackListProject       @"kTrackListProject"
#define kTrackListCompany       @"kTrackListCompany"
#define kTrackList              @[kTrackListProject,kTrackListCompany]
#define kCategory               @[@(101), @(102), @(103), @(105)]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isLogged = YES;
    
    if([[DataManager sharedManager] locationManager].currentStatus == kCLAuthorizationStatusAuthorizedAlways) {
        
        [[[DataManager sharedManager] locationManager] startUpdatingLocation];
        
    } else {
        [[[DataManager sharedManager] locationManager] requestAlways];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReloadDashboard:) name:NOTIFICATION_RELOAD_DASHBOARD object:nil];
    
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
    
    if ([[DataManager sharedManager] isDebugMode]) {
    }
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateHome:) name:NOTIFICATION_HOME object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.customLoadingIndicator stopAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.notificationPayloadRecordID) {
        [[DataManager sharedManager] showProjectDetail:appDelegate.notificationPayloadRecordID];
        appDelegate.notificationPayloadRecordID = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)notificationReloadDashboard:(NSNotification*)notification {
    
    [self pageChangedForced:YES];
    
}

- (void)navigateHome:(NSNotification*)notification {

    [self.navigationController popToViewController:self animated:NO];
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentMade == YES AND relationshipProject.isHidden = NO AND relationshipProject.projectGroupId IN %@", kCategory];
    bidItemsRecentlyMade = [[DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO] mutableCopy];
    
    for (DB_Bid *item in bidItemsRecentlyMade) {
        
        NSString *tag = [NSString stringWithFormat:@"%li", (long)item.relationshipProject.projectGroupId.integerValue];
        
        if ([tag isEqualToString:@"103"]) {
            tag = @"102";
        }
        
        if ([tag isEqualToString:@"105"]) {
            DB_Project *project = item.relationshipProject;
            NSString *bh = project.primaryProjectTypeBuildingOrHighway;
            if ([bh isEqualToString:@"H"]) {
                tag = @"101";
            } else {
                tag = @"102";
            }
        }
        
        item.relationshipProject.projectGroupId = [NSNumber numberWithInteger:[tag integerValue]];
        
        NSMutableDictionary *itemDict = segment[tag];
        
        if (itemDict == nil) {
            itemDict = [@{CHART_SEGMENT_COUNT:@(0)} mutableCopy];
        }
        NSNumber *number = itemDict[CHART_SEGMENT_COUNT];
        itemDict[CHART_SEGMENT_COUNT] = @(number.integerValue + 1);
        segment[tag] = itemDict;
        
    }
    
    [[DataManager sharedManager] saveContext];
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHappenSoon == YES AND isHidden == NO AND bidYearMonth == %@",yearMonth];
    bidItemsHappeningSoon = [[DB_Project fetchObjectsForPredicate:predicate key:@"bidDate" ascending:YES] mutableCopy];
    
    for (DB_Project *item in bidItemsHappeningSoon) {
        bidMarker[item.bidYearMonthDay] = @"";
    }

    return bidItemsHappeningSoon;
}

- (void)requestBidRecentlyUpdated {
    
    [[DataManager sharedManager] bidsRecentlyUpdated:30 success:^(id object) {
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentUpdate == YES AND isHidden == NO AND projectGroupId IN %@", kCategory];
    bidItemsRecentlyUpdated = [[DB_Project fetchObjectsForPredicate:predicate key:@"lastPublishDate" ascending:NO] mutableCopy];
    
    
    for (DB_Project *item in bidItemsRecentlyUpdated) {
        
        NSString *tag = [NSString stringWithFormat:@"%li", (long)item.projectGroupId.integerValue];
        
        if ([tag isEqualToString:@"103"]) {
            tag = @"102";
        }
        
        if ([tag isEqualToString:@"105"]) {
            NSString *bh = item.primaryProjectTypeBuildingOrHighway;
            if ([bh isEqualToString:@"H"]) {
                tag = @"101";
            } else {
                tag = @"102";
            }
        }
        
        item.projectGroupId = [NSNumber numberWithInteger:[tag integerValue]];
        
        NSMutableDictionary *itemDict = segment[tag];
        
        if (itemDict == nil) {
            itemDict = [@{CHART_SEGMENT_COUNT:@(0)} mutableCopy];
        }
        NSNumber *number = itemDict[CHART_SEGMENT_COUNT];
        itemDict[CHART_SEGMENT_COUNT] = @(number.integerValue + 1);
        segment[tag] = itemDict;
        
    }
    [[DataManager sharedManager] saveContext];
    [self createSegmentTagForChart:segment count:bidItemsRecentlyUpdated.count];
    [_chartRecentlyUpdated setSegmentItems:segment];
    return bidItemsRecentlyUpdated;
}

- (NSMutableArray*)loadBidsRecentlyAdded {
    
    NSMutableDictionary *segment = [[NSMutableDictionary alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentAdded == YES AND isHidden == NO AND projectGroupId IN %@", kCategory];
    bidItemsRecentlyAdded = [[DB_Project fetchObjectsForPredicate:predicate key:@"lastPublishDate" ascending:NO] mutableCopy];
    
    for (DB_Project *item in bidItemsRecentlyAdded) {
        
        NSString *tag = [NSString stringWithFormat:@"%li", (long)item.projectGroupId.integerValue];
        
        if ([tag isEqualToString:@"103"]) {
            tag = @"102";
        }
        
        if ([tag isEqualToString:@"105"]) {
            DB_Project *project = item;
            NSString *bh = project.primaryProjectTypeBuildingOrHighway;
            if ([bh isEqualToString:@"H"]) {
                tag = @"101";
            } else {
                tag = @"102";
            }
        }
        
        item.projectGroupId = [NSNumber numberWithInteger:[tag integerValue]];
        
        NSMutableDictionary *itemDict = segment[tag];
        
        if (itemDict == nil) {
            itemDict = [@{CHART_SEGMENT_COUNT:@(0)} mutableCopy];
        }
        NSNumber *number = itemDict[CHART_SEGMENT_COUNT];
        itemDict[CHART_SEGMENT_COUNT] = @(number.integerValue + 1);
        segment[tag] = itemDict;
        
    }
    [[DataManager sharedManager] saveContext];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bidYearMonthDay == %@ AND isHidden = NO AND isHappenSoon == YES", itemtag];
        
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
                [self loadBidsRecentlyMade];
                currentBidItems = bidItemsRecentlyMade;
                [_menuHeader setTitleFromCount:currentBidItems.count  title:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_MADE_TEXT")];
                break;
            }
            case 1: {
                [[GAManager sharedManager] trackProjectsHappeningSoon];
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

    BOOL connected= [[BaseManager sharedManager] connected];
    _bidsCollectionView.userInteractionEnabled = connected?NO:YES;
    
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

    [[GAManager sharedManager] trackProjectCard];
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

- (NSDictionary*)createMockCompanyTrackList:(NSString*)trackName trackid:(NSNumber*)trackId companyIds:(NSArray*)companyIds {
    
    return @{@"name":trackName, @"id":trackId, @"userId":[NSNumber numberWithInt:5], @"companyIds":companyIds};
}

- (void)tappedMenu:(MenuHeaderItem)menuHeaderItem forView:(UIView *)view{
 
    switch (menuHeaderItem) {
        case MenuHeaderNear:{

            shouldUsePushZoomAnimation = NO;
            [[GAManager sharedManager] trackProjectsNearMe];
            [self.navigationController pushViewController:[ProjectsNearMeViewController new] animated:YES];
            
            break;
        }
        case MenuHeaderTrack: {

            trackList[0] = nil;
            trackList[1] = nil;
            
            if (trackingListInfo == nil) {
                trackingListInfo = [[NSMutableDictionary alloc] init];
            }
            
            [trackingListInfo removeAllObjects];
            
            NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
            [self.customLoadingIndicator startAnimating];
            [[DataManager sharedManager] userProjectTrackingList:[NSNumber numberWithInteger:userId.integerValue] success:^(id object) {
                
                trackingListInfo[kTrackList[0]] = [object mutableCopy];
                [[DataManager sharedManager] userCompanyTrackingList:[NSNumber numberWithInteger:userId.integerValue] success:^(id object) {
                    [self.customLoadingIndicator stopAnimating];
                    trackingListInfo[kTrackList[1]] = [object mutableCopy];
                    PopupViewController *controller = [PopupViewController new];
                    CGRect rect = [controller getViewPositionFromViewController:view controller:self];
                    rect.size.height =  rect.size.height * 0.85;
                    controller.popupRect = rect;
                    controller.popupWidth = 0.98;
                    controller.isGreyedBackground = YES;
                    controller.customCollectionViewDelegate = self;

                    [[GAManager sharedManager] trackTrackingListIcon];

                    controller.modalPresentationStyle = UIModalPresentationCustom;
                    [self presentViewController:controller animated:NO completion:nil];
                    
                } failure:^(id object) {
                    [self.customLoadingIndicator stopAnimating];
                }];
            } failure:^(id object) {
                [self.customLoadingIndicator stopAnimating];
            }];
            
            break;
        
        }
        case MenuHeaderSearch:{
            shouldUsePushZoomAnimation = NO;
            [[GAManager sharedManager] trackSearch];
            SearchViewController *controller = [SearchViewController new];
            [self.navigationController pushViewController:controller animated:YES];
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
            
            MyProfileViewController *controller = [MyProfileViewController new];
            [controller setInfo:profileInfo];
            [self.navigationController pushViewController:controller animated:YES];
            break;
            
        }
            
        case DropDownMenuHiddenProjects: {
            
            [[DataManager sharedManager] hiddentProjects:^(id object) {
                
                HiddenProjectsViewController *controller = [HiddenProjectsViewController new];
                controller.collectionItems = [object[@"hiddenProjects"] mutableCopy];
                [self.navigationController pushViewController:controller animated:YES];

            } failure:^(id object) {
                
            }];
            
            break;
        
        }
            
        case DropDownMenuSettings:{
            SettingsViewController *controller = [SettingsViewController new];
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
    
    ChartView *chartView = chart;
    if ([chart isEqual:_chartRecentlyMade]) {
        if (!chartView.isButton) {
            [[GAManager sharedManager] trackBidsRecentlyMadeGraph];
        } else {
            [[GAManager sharedManager] trackBidsRecentlyMadeButton];
        }
        chartView.isButton = NO;
        [self displayChartItemsForRecentlyMade:itemTag hasFocus:hasFocus];
    } else if([chart isEqual:_chartRecentlyUpdated]) {
        if (!chartView.isButton) {
            [[GAManager sharedManager] trackBidsRecentlyUpdatedGraph];
        } else {
            [[GAManager sharedManager] trackBidsRecentlyUpdatedButton];
        }
        chartView.isButton = NO;
        [self displayChartItemsForRecentlyUpdated:itemTag hasFocus:hasFocus];
    } else {
        if (!chartView.isButton) {
            [[GAManager sharedManager] trackBidsRecentlyAddedGraph];
        } else {
            [[GAManager sharedManager] trackBidsRecentlyAddedButton];
        }
        chartView.isButton = NO;
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

#pragma mark - TrackingListView Delegate

- (void)tappedTrackingListItem:(id)object view:(UIView *)view {
    
    [[DataManager sharedManager] dismissPopup];
    NSIndexPath *indexPath = object;
    
    BOOL isProject = [view isDescendantOfView:trackList[0]];
    
    NSArray *trackListArray = trackingListInfo[isProject ? kTrackListProject: kTrackListCompany];
    NSDictionary *trackItemInfo = trackListArray[indexPath.row];
    
    shouldUsePushZoomAnimation = NO;
    
    if (isProject) {
        [self.customLoadingIndicator startAnimating];
        [[DataManager sharedManager] projectTrackingList:trackItemInfo[@"id"] success:^(id object) {
            [self.customLoadingIndicator stopAnimating];
            [[GAManager sharedManager] trackProjectTrackingList];
            
            ProjectTrackingViewController *controller = [ProjectTrackingViewController new];
            controller.cargo = [trackItemInfo mutableCopy];
            controller.collectionItems = [(NSArray*)object mutableCopy] ;
            [self.navigationController pushViewController:controller animated:YES];
        } failure:^(id object) {
            [self.customLoadingIndicator stopAnimating];
        }];
    } else {
        [self.customLoadingIndicator startAnimating];
        [self companyTrackingListAndUpdatesFiltered:trackItemInfo success:^(id object){
            [self.customLoadingIndicator stopAnimating];
            [[GAManager sharedManager] trackCompanyTrackingList];
            CompanyTrackingListViewController *controller = [CompanyTrackingListViewController new];
            [controller setTrackingInfo:trackItemInfo];
            [controller setInfo:object];
            [self.navigationController pushViewController:controller animated:YES];
        }fail:^(id obj){
            [self.customLoadingIndicator stopAnimating];
        }];
        
    }
}

#pragma mark - CustomCollectionView Delegate

- (void)collectionViewItemClassRegister:(id)customCollectionView {
    CustomCollectionView *collectionView = (CustomCollectionView*)customCollectionView;
    [collectionView registerCollectionItemClass:[TrackingListCellCollectionViewCell class]];
    
}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[TrackingListCellCollectionViewCell class]]) {
    
        TrackingListCellCollectionViewCell *cellItem = (TrackingListCellCollectionViewCell*)cell;
        trackList[indexPath.row] = cellItem;
        cellItem.trackingListViewDelegate = self;
        [cellItem setInfo:trackingListInfo[indexPath.row ==0 ? kTrackListProject: kTrackListCompany] withTitle:NSLocalizedLanguage(indexPath.row ==0 ? @"PROJECT_TRACKING_LIST": @"COMPANY_TRACKING_LIST")];
    
    }
    
}

- (UICollectionViewCell *)collectionViewItemClassDeque:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView{
    return [collectionView dequeueReusableCellWithReuseIdentifier:[[TrackingListCellCollectionViewCell class] description] forIndexPath:indexPath];
}

- (NSInteger)collectionViewSectionCount {
    return 1;
}

- (NSInteger)collectionViewItemCount {
    return 2;
}

- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath *)indexPath cargo:(id)cargo{
    NSArray *item = trackingListInfo[kTrackList[indexPath.row]];
    
    TrackingListCellCollectionViewCell *cellItem = trackList[indexPath.row];
    CGFloat defaultHeight = kDeviceHeight * 0.08;
    BOOL isExpanded = YES;
    if (cellItem != nil) {
        isExpanded =  [[cellItem cargo] boolValue];
    }
    
    if (isExpanded) {
        CGFloat cellHeight = kDeviceHeight * 0.06;
        defaultHeight = defaultHeight+ ((item.count<4?item.count:4.25)*cellHeight);
    }
    
    return CGSizeMake(kDeviceWidth * 0.98, defaultHeight);
}

- (void)collectionViewDidSelectedItem:(NSIndexPath *)indexPath {
    
}

#pragma mark - CompanyTrackingListAndUpdates

- (void)companyTrackingListAndUpdatesFiltered:(id)trackItemInfo success:(APIBlock)success fail:(APIBlock)fail {
   
    [[DataManager sharedManager] companyTrackingList:trackItemInfo[@"id"] success:^(id companyListObj) {
       
        [[DataManager sharedManager] companyTrackingListUpdates:trackItemInfo[@"id"]  success:^(id updatesObj){
            
             NSMutableArray *companyListArry = [NSMutableArray new];
             
             for (id obj in companyListObj) {
                 NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"companyId == %@", [NSNumber numberWithInteger:[obj[@"id"] integerValue]]];
                 NSArray *filteredUpdates = [updatesObj filteredArrayUsingPredicate:resultPredicate];
                 NSMutableDictionary *dict = [obj mutableCopy];
                 
                 if (filteredUpdates.count > 0) {
                     [dict setValue:filteredUpdates[0] forKey:@"UPDATES"];
                 }
             
                 [companyListArry addObject:dict];
             }
            
            success(companyListArry);
            
            
        }failure:^(id failObj){
            
            fail(failObj);
        }];
    
    } failure:^(id object) {
        fail(object);
    }];

    
}

@end

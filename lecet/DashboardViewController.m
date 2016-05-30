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
#import "DropDownMenuView.h"

#import "BidItemCollectionViewCell.h"
#import "BidSoonItemCollectionViewCell.h"
#import "CalendarItemCollectionViewCell.h"
#import "BitItemRecentCollectionViewCell.h"

#import "ProjectDetailViewController.h"
#import "CompanyDetailViewController.h"

#import "PushZoomAnimator.h"
#import "ChartView.h"
#import "chartConstants.h"

@interface DashboardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,CustomCalendarDelegate, UIScrollViewDelegate, BidCollectionItemDelegate, BidSoonCollectionItemDelegate, MenuHeaderDelegate, UINavigationControllerDelegate, ChartViewDelegate,DropDownMenuDelegate, BitItemRecentDelegate>{

    NSDate *currentDate;
    NSInteger currentPage;
    NSMutableArray *bidItemsRecentlyMade;
    NSMutableArray *bidItemsHappeningSoon;
    NSMutableArray *bidItemsRecentlyAdded;
    NSMutableArray *bidItemsRecentlyUpdated;
    NSMutableArray *currentBidItems;
    NSMutableDictionary *bidMarker;
    BOOL isDropDownMenuMoreHidden;
    BOOL shouldUsePushZoomAnimation;
    CGRect originatingFrame;
}
@property (weak, nonatomic) IBOutlet ChartView *chartRecentlyMade;
@property (weak, nonatomic) IBOutlet ChartView *chartRecentlyUpdated;
@property (weak, nonatomic) IBOutlet ChartView *chartRecentlyAdded;
@property (weak, nonatomic) IBOutlet UICollectionView *bidsCollectionView;
@property (weak, nonatomic) IBOutlet CustomCalendar *calendarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet MenuHeaderView *menuHeader;

@property (weak,nonatomic) IBOutlet DropDownMenuView* dropDownMenu;

@property (weak,nonatomic) IBOutlet UIView *dimDropDownMenuBackgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownMenuViewHeight;

@end

@implementation DashboardViewController
#define kCellIdentifier         @"kCellIdentifier"
#define kCellIdentifierSoon     @"kCellIdentifierSoon"
#define kCellIdentifierRecent   @"kCellIdentifierRecent"
#define kCategory               @[@(101), @(102), @(103), @(105)]
static const float animationDurationForDropDowMenu = 1.0f;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    bidItemsHappeningSoon = [NSMutableArray new];
    self.view.backgroundColor = DASHBOARD_BG_COLOR;
    
    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BidItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BidSoonItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierSoon];
    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BitItemRecentCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierRecent];

    _bidsCollectionView.backgroundColor = DASHBOARD_BIDS_BG_COLOR;
    
    currentDate = [DerivedNSManagedObject dateFromDayString:@"2015-11-01"];
    [_calendarView setCalendarDate:currentDate];
    
    currentPage = 0;
    _scrollPageView.delegate = self;
    _bidsCollectionView.delegate = self;
    _bidsCollectionView.dataSource = self;
    _chartRecentlyMade.chartViewDelegate = self;
    _chartRecentlyUpdated.chartViewDelegate = self;

    currentBidItems = [self loadBidsRecentlyMade];
    [self requestBidsHappeningSoon];
    [self requestBidRecentlyUpdated];
    [self requestBidRecentlyAdded];
    
    [_menuHeader setTitleFromCount:currentBidItems.count title:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_MADE_TEXT")];
    [_bidsCollectionView reloadData];

    [_calendarView reloadData];
 
    _pageControl.numberOfPages = 4;
    _menuHeader.menuHeaderDelegate = self;
    
    //DropDownMenuMore
    _dropDownMenu.dropDownMenuDelegate = self;
    isDropDownMenuMoreHidden = YES;
    [self addTappedGestureForDimBackground];
    
    [self layoutDropDownMenuChange];
    
    [_chartRecentlyMade hideLeftButton:YES];
    [_chartRecentlyUpdated hideRightButton:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    [[DataManager sharedManager] bidsHappeningSoon:-300 success:^(id object) {
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
    [[DataManager sharedManager] bidsRecentlyAddedLimit:@(100) success:^(id object) {
        [self loadBidsRecentlyAdded];
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

- (void)pageChanged {
    
    int page = _scrollPageView.contentOffset.x / _scrollPageView.frame.size.width;

    if (page != currentPage) {
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
    [self pageChanged];
}

# pragma mark - BID COLLECTION DELEGATE

- (void)tappedBidCollectionItem:(id)object {
    BidItemView *item = object;
    BidItemCollectionViewCell *cell = (BidItemCollectionViewCell*)[[item superview] superview];

    [[DataManager sharedManager] projectDetail:[item getProjectRecordId] success:^(id object) {
        [self showProjectDetails:object fromRect:cell.frame];
    } failure:^(id object) {
        
    }];
}

- (void)tappedBidSoonCollectionItem:(id)object {
    BidSoonItem *item = object;
    BidSoonItemCollectionViewCell * cell = (BidSoonItemCollectionViewCell*)[[item superview] superview];
    
    [[DataManager sharedManager] projectDetail:[item getRecordId] success:^(id object) {
        [self showProjectDetails:object fromRect:cell.frame];
    } failure:^(id object) {
        
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
 
    if (menuHeaderItem == MenuHeaderMore) {
        [self showOrHideDropDownMenuMore];
    }
    
}

- (void)tappedBitItemRecent:(id)object {
    BidItemRecent *item = object;
    BitItemRecentCollectionViewCell * cell = (BitItemRecentCollectionViewCell*)[[item superview] superview];
    
    [[DataManager sharedManager] projectDetail:[item getRecordId] success:^(id object) {
        [self showProjectDetails:object fromRect:cell.frame];
    } failure:^(id object) {
        
    }];

}


#pragma mark - DropDown Menu More

- (void)showOrHideDropDownMenuMore{
    if (isDropDownMenuMoreHidden) {
        
        
        [_dropDownMenu setHidden:NO];
        [_dimDropDownMenuBackgroundView setHidden:NO];
        _dimDropDownMenuBackgroundView.alpha  = 0.0f;
        _dropDownMenu.alpha = 0.0f;
        
        [UIView animateWithDuration:1.0 animations:^{
            _dropDownMenu.alpha = 1.0f;
            _dimDropDownMenuBackgroundView.alpha  = 1.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                isDropDownMenuMoreHidden = NO;
                
            }
        }];
        
    }else{
        [self hideDropDownMenu];
        //[_dropDownMenu setHidden:YES];
        
    }
    
}

- (void)addTappedGestureForDimBackground{
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropDownMenu)];
    tapped.numberOfTapsRequired = 1;
    [_dimDropDownMenuBackgroundView addGestureRecognizer:tapped];
    
    
}


- (void)hideDropDownMenu{
    
    _dropDownMenu.alpha = 1.0f;
    
    [UIView animateWithDuration:animationDurationForDropDowMenu animations:^{
        _dropDownMenu.alpha = 0.0f;
        _dimDropDownMenuBackgroundView.alpha  = 0.0f;
        
    } completion:^(BOOL finished) {

        if (finished) {
            isDropDownMenuMoreHidden = YES;

        }
    }];
    //[UIView beginAnimations:@"fadeOut" context:nil];
    //[UIView setAnimationDuration:1.0];
    

}

#pragma mark - Drop Down Menu Delegate

- (void)tappedDropDownMenu:(DropDownMenuItem)menuDropDownItem{
    
    
    [[DataManager sharedManager] promptMessage:[NSString stringWithFormat:@"Tap Menu = %u",menuDropDownItem]];
    
    
}

- (void)layoutDropDownMenuChange{
    if (isiPhone5) {
        _dropDownMenuViewHeight.constant = 218;
    }
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
        NSPredicate *predicate =nil;
        
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
            
            predicate = [NSPredicate predicateWithFormat:@"relationshipProject.projectGroupId == %li", category];
        }
        
        bidItemsRecentlyMade = [[DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO] mutableCopy];
        
        currentBidItems = bidItemsRecentlyMade;
        
        [_bidsCollectionView reloadData];
    }
}

- (void)displayChartItemsForRecentlyUpdated:(NSString*)itemTag hasFocus:(BOOL)hasFocus {
    if (itemTag != nil) {
        NSPredicate *predicate =nil;
        
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
            
            predicate = [NSPredicate predicateWithFormat:@"projectGroupId == %li", category];
        }
        
        bidItemsRecentlyUpdated = [[DB_Project fetchObjectsForPredicate:predicate key:@"lastPublishDate" ascending:NO] mutableCopy];
        
        currentBidItems = bidItemsRecentlyUpdated;
        
        [_bidsCollectionView reloadData];
    }
}


- (void)selectedItemChart:(NSString *)itemTag chart:(id)chart hasfocus:(BOOL)hasFocus {
    
    if ([chart isEqual:_chartRecentlyMade]) {
        [self displayChartItemsForRecentlyMade:itemTag hasFocus:hasFocus];
    } else if([chart isEqual:_chartRecentlyUpdated]) {
        [self displayChartItemsForRecentlyUpdated:itemTag hasFocus:hasFocus];
    }
}


@end

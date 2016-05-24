//
//  DashboardViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DashboardViewController.h"

#import "dashboardConstants.h"
#import "BidItemCollectionViewCell.h"
#import "BidSoonItemCollectionViewCell.h"
#import "CustomCalendar.h"
#import "CalendarItem.h"
#import "CalendarItemCollectionViewCell.h"
#import "DB_BidSoon.h"
#import "DB_BidRecent.h"
#import "DB_Bid.h"
#import "DB_Project.h"
#import "MenuHeaderView.h"
#import "BidItemView.h"
#import "BidSoonItem.h"
#import "DropDownMenuView.h"


#import "ProjectDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "PushZoomAnimator.h"
#import "ChartView.h"
#import "chartConstants.h"

@interface DashboardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,CustomCalendarDelegate, UIScrollViewDelegate, BidCollectionItemDelegate, BidSoonCollectionItemDelegate, MenuHeaderDelegate, UINavigationControllerDelegate, ChartViewDelegate,DropDownMenuDelegate>{

    NSDate *currentDate;
    NSInteger currentPage;
    NSMutableArray *bidItemsSoon;
    NSMutableArray *bidItemsRecent;
    NSMutableArray *currentBidItems;
    NSMutableDictionary *bidMarker;
    BOOL isDropDownMenuMoreHidden;
    BOOL shouldUsePushZoomAnimation;
    CGRect originatingFrame;
}
@property (weak, nonatomic) IBOutlet ChartView *chartRecentlyMade;
@property (weak, nonatomic) IBOutlet UICollectionView *bidsCollectionView;
@property (weak, nonatomic) IBOutlet CustomCalendar *calendarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet MenuHeaderView *menuHeader;

@property (weak,nonatomic) IBOutlet DropDownMenuView* dropDownMenu;

@property (weak,nonatomic) IBOutlet UIView *dimDropDownMenuBackgroundView;



@end

@implementation DashboardViewController
#define kCellIdentifier         @"kCellIdentifier"
#define kCellIdentifierSoon     @"kCellIdentifierSoon"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DASHBOARD_BG_COLOR;
    
    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BidItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BidSoonItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierSoon];

    _bidsCollectionView.backgroundColor = DASHBOARD_BIDS_BG_COLOR;
    
    currentDate = [DerivedNSManagedObject dateFromDayString:@"2015-11-01"];
    [_calendarView setCalendarDate:currentDate];
    
    currentPage = 0;
    _scrollPageView.delegate = self;
    _bidsCollectionView.delegate = self;
    _bidsCollectionView.dataSource = self;
    _chartRecentlyMade.chartViewDelegate = self;
    
    NSMutableDictionary *segment = [[NSMutableDictionary alloc] init];
    [[DataManager sharedManager] bids:currentDate success:^(id object) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecent == YES AND relationshipProject.projectGroupId IN %@", @[@(101), @(102), @(103), @(105)]];
        bidItemsRecent = [[DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO] mutableCopy];
        
        currentBidItems = bidItemsRecent;
        
        for (DB_Bid *item in currentBidItems) {
            
            NSString *tag = [NSString stringWithFormat:@"%li", item.relationshipProject.projectGroupId.integerValue];
            NSMutableDictionary *itemDict = segment[tag];
            
            if (itemDict == nil) {
                itemDict = [@{CHART_SEGMENT_COUNT:@(0)} mutableCopy];
            }
            NSNumber *number = itemDict[CHART_SEGMENT_COUNT];
            itemDict[CHART_SEGMENT_COUNT] = @(number.integerValue + 1);
            segment[tag] = itemDict;
            
        }
        
        NSInteger itemCount = currentBidItems.count;
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
    
            NSNumber *percentage = @((number.floatValue/itemCount)*100.0);
            item[CHART_SEGMENT_PERCENTAGE] = percentage;
            
        }
        
        [_chartRecentlyMade setSegmentItems:segment];
        [_menuHeader setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_MADE_TEXT"), currentBidItems.count ]];

        [_bidsCollectionView reloadData];
    } failure:^(id object) {
        
    }];
     
    
    [_calendarView reloadData];
    
    [self loadBidItems];
 
    _pageControl.numberOfPages = 4;
    _menuHeader.menuHeaderDelegate = self;
    
    
    
    //DropDownMenuMore
    _dropDownMenu.dropDownMenuDelegate = self;
    isDropDownMenuMoreHidden = YES;
    [self addTappedGestureForDimBackground];

}

- (void)loadBidItems {

    _calendarView.customCalendarDelegate = nil;
    
    if (bidMarker == nil) {
        bidMarker = [[NSMutableDictionary alloc] init];
    }
    [bidMarker removeAllObjects];
    

    if (bidItemsSoon == nil) {
        bidItemsSoon = [[NSMutableArray alloc] init];
    }
    [bidItemsSoon removeAllObjects];

    [[DataManager sharedManager] happeningSoon:-300 success:^(id object) {
        
        NSString *yearMonth = [DB_BidSoon yearMonthFromDate:currentDate];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bidYearMonth == %@", yearMonth];

        bidItemsSoon = [[DB_BidSoon fetchObjectsForPredicate:predicate key:@"bidDate" ascending:YES] mutableCopy];
        
        
        for (DB_BidSoon *item in bidItemsSoon) {
            bidMarker[item.bidYearMonthDay] = @"";
        }

        _calendarView.customCalendarDelegate = self;

        [_calendarView reloadData];
        
        
    } failure:^(id object) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    switch (currentPage) {
        case 0 : case 2 :case 3: {
            BidItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
            
            NSMutableArray *array = (NSMutableArray*)currentBidItems;
            [cellItem setItemInfo:array[indexPath.row]];
            cellItem.bidCollectionitemDelegate = self;
            cell = cellItem;
            break;
        }
        default: {
            BidSoonItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierSoon forIndexPath:indexPath];
            
            NSMutableArray *array = (NSMutableArray*)currentBidItems;
            [cellItem setItemInfo:array[indexPath.row]];
            cellItem.bidSoonCollectionItemDelegate = self;
            cell = cellItem;
            break;
        }
    }
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    //[cell contentView].layer.shouldRasterize = YES;
    //cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
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
        
        currentBidItems = [[DB_BidSoon fetchObjectsForPredicate:predicate key:@"bidDate" ascending:YES] mutableCopy];

    } else {
        currentBidItems = bidItemsSoon;

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
                currentBidItems = bidItemsRecent;
                [_menuHeader setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_MADE_TEXT"), currentBidItems.count ]];
                break;
            }
            case 1: {
                [_calendarView clearSelection];
                currentBidItems = bidItemsSoon;
                [_menuHeader setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_SOON_TEXT"), currentBidItems.count ]];
                break;
            }
            case 2: {
                
                currentBidItems = bidItemsRecent;
                [_menuHeader setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_ADDED_TEXT"), currentBidItems.count ]];
                break;
            }
            case 3: {
                currentBidItems = bidItemsRecent;
                [_menuHeader setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_UPDATED_TEXT"), currentBidItems.count ]];
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
    //[self showProjectDetails:[item getRecordId] fromRect:cell.frame];
    /*
    CompanyDetailViewController *controller = [CompanyDetailViewController new];
    controller.view.hidden = NO;
    [controller setInfo:nil];
    shouldUsePushZoomAnimation = NO;
    [self.navigationController pushViewController:controller animated:YES];
     */

    [[DataManager sharedManager] featureNotAvailable:self];
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
    
    //shouldUsePushZoomAnimation = NO;
    /*
    detail.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    detail.view.hidden = YES;
    detail.previousRect = rect;
    
    [self.navigationController presentViewController:detail animated:NO completion:^{
        detail.view.frame = rect;
        detail.view.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            detail.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
            [detail.view setNeedsDisplay];
        } completion:^(BOOL finished) {
            
        }];
    }];
    */
    
}

- (void)tappedMenu:(MenuHeaderItem)menuHeaderItem {
 
    if (menuHeaderItem == MenuHeaderMore) {
        [self showOrHideDropDownMenuMore];
    }
    
}


#pragma mark - DropDown Menu More

- (void)showOrHideDropDownMenuMore{
    if (isDropDownMenuMoreHidden) {
        
        isDropDownMenuMoreHidden = NO;
        
        [_dropDownMenu setHidden:NO];
        [_dimDropDownMenuBackgroundView setHidden:NO];
        
        _dimDropDownMenuBackgroundView.alpha  = 0.0f;
        _dropDownMenu.alpha = 0.0f;
        [UIView beginAnimations:@"fadeIn" context:nil];
        [UIView setAnimationDuration:1.0];
        _dropDownMenu.alpha = 1.0f;
        _dimDropDownMenuBackgroundView.alpha  = 1.0f;
        
        
        
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
    
    
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:1.0];
    _dropDownMenu.alpha = 0.0f;
    _dimDropDownMenuBackgroundView.alpha  = 0.0f;
    
    isDropDownMenuMoreHidden = YES;

}

#pragma mark - Drop Down Menu Delegate

- (void)tappedDropDownMenu:(DropDownMenuItem)menuDropDownItem{
    
    
    
    
    
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

- (void)selectedItemChart:(NSString *)itemTag chart:(id)chart hasfocus:(BOOL)hasFocus {
    
    if ([chart isEqual:_chartRecentlyMade]) {
        
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
            
            bidItemsRecent = [[DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO] mutableCopy];
            
            currentBidItems = bidItemsRecent;
            
            [_bidsCollectionView reloadData];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"No record found!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction *action) {
                        
                                                   }];
            
            [alert addAction:closeAction];
            [self presentViewController:alert animated:YES completion:nil];
        }

    }
}


@end

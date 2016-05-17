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
#import "MenuHeaderView.h"
#import "BidItemView.h"
#import "BidSoonItem.h"
#import "ProjectDetailViewController.h"

#import "CompanyDetailViewController.h"

@interface DashboardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,CustomCalendarDelegate, UIScrollViewDelegate, BidCollectionItemDelegate, BidSoonCollectionItemDelegate, MenuHeaderDelegate>{
    NSDate *currentDate;
    NSInteger currentPage;
    NSMutableArray *bidItemsSoon;
    NSMutableArray *bidItemsRecent;
    NSMutableArray *currentBidItems;
    NSMutableDictionary *bidMarker;
}
@property (weak, nonatomic) IBOutlet UICollectionView *bidsCollectionView;
@property (weak, nonatomic) IBOutlet CustomCalendar *calendarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet MenuHeaderView *menuHeader;

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

    [[DataManager sharedManager] bids:currentDate success:^(id object) {
        
        bidItemsRecent = [[DB_BidRecent fetchObjectsForPredicate:nil key:@"bidCreateDate" ascending:YES] mutableCopy];
        
        currentBidItems = bidItemsRecent;
        
        [_menuHeader setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_MADE_TEXT"), currentBidItems.count ]];

        [_bidsCollectionView reloadData];
    } failure:^(id object) {
        
    }];
     
    
    [_calendarView reloadData];
    
    [self loadBidItems];
 
    _pageControl.numberOfPages = 4;
    _menuHeader.menuHeaderDelegate = self;
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

    [[DataManager sharedManager] bidDetail:[item getRecordId] success:^(id object) {
        [self showProjectDetails:object fromRect:cell.frame];
    } failure:^(id object) {
        
    }];
}

- (void)tappedBidSoonCollectionItem:(id)object {
    BidSoonItem *item = object;
    BidSoonItemCollectionViewCell * cell = (BidSoonItemCollectionViewCell*)[[item superview] superview];
    //[self showProjectDetails:[item getRecordId] fromRect:cell.frame];
    CompanyDetailViewController *controller = [CompanyDetailViewController new];
    [self.navigationController pushViewController:controller animated:NO];

}

- (void)showProjectDetails:(id)record fromRect:(CGRect)rect {
    
    CGRect collectionViewRect = _bidsCollectionView.frame;
    CGFloat offset = _bidsCollectionView.contentOffset.x;
    rect.origin.x -= offset;
    rect.origin.y += collectionViewRect.origin.y;

    ProjectDetailViewController *detail = [ProjectDetailViewController new];
    detail.view.hidden = NO;

    if ([record class] == [DB_BidRecent class]) {
        [detail detailsFromBid:record];
    }
    
    [self.navigationController pushViewController:detail animated:YES];
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
    
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

@end

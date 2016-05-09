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

@interface DashboardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,CustomCalendarDelegate, UIScrollViewDelegate>{
    NSDate *currentDate;
    NSInteger currentPage;
    NSMutableArray *bidItemsSoon;
    NSMutableArray *currentBidItems;
    NSMutableDictionary *bidMarker;
}
@property (weak, nonatomic) IBOutlet UICollectionView *bidsCollectionView;
@property (weak, nonatomic) IBOutlet CustomCalendar *calendarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

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
    
    currentDate = [DerivedNSManagedObject dateFromDayString:@"2015-12-01"];
    [_calendarView setCalendarDate:currentDate];
    
    currentPage = 0;
    _scrollPageView.delegate = self;
    _bidsCollectionView.delegate = self;
    _bidsCollectionView.dataSource = self;

    
    /*
    [[DataManager sharedManager] bids:currentDate success:^(id object) {
        
    } failure:^(id object) {
        
    }];
     */
    
    [_calendarView reloadData];
    
    [self loadBidItems];
 
    _pageControl.numberOfPages = 3;
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
        /*
        NSDictionary *bids = object[@"results"];
        
        for (NSDictionary *item in bids) {
            
            NSDate *bidDate = [DerivedNSManagedObject dateFromDateAndTimeString:item[@"bidDate"]];
            
            NSString *bidDateString = [DerivedNSManagedObject dateStringFromDateDay:bidDate];
            
            NSMutableArray *itemList = tempDictionary[bidDateString];
            
            if (itemList == nil) {
                itemList = [[NSMutableArray alloc] init];
            }
            
            [itemList addObject:item];

            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"bidDate" ascending:YES selector:@selector(localizedStandardCompare:)];
            
            NSMutableArray *sortedItems = [[itemList sortedArrayUsingDescriptors:@[ descriptor ]] mutableCopy];

            tempDictionary[bidDateString] = sortedItems;
        }
        
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES selector:@selector(localizedStandardCompare:)];
        
        NSMutableArray *keyItems = [[tempDictionary.allKeys sortedArrayUsingDescriptors:@[ descriptor ]] mutableCopy];
        
        for (NSString *key in keyItems) {
            bidItemsSoon[key] = tempDictionary[key];
        }
        
        //bidItemsSoon = tempDictionary;
        */
        
        currentBidItems = bidItemsSoon;
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
        case 0: {
            BidItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
            cell = cellItem;
            break;
        }
        default: {
            BidSoonItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierSoon forIndexPath:indexPath];
            
            NSMutableArray *array = (NSMutableArray*)currentBidItems;
            [cellItem setItemInfo:array[indexPath.row]];
            
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
                [_calendarView clearSelection];
                currentBidItems = [NSMutableArray new];
                break;
            }
            default: {
                [_calendarView clearSelection];
                currentBidItems = bidItemsSoon;
                break;
            }
        }
        
        [_bidsCollectionView reloadData];
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pageChanged];
}

@end

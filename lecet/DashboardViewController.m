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
#import "CustomCalendar.h"
#import "CalendarItem.h"

@interface DashboardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,CustomCalendarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *bidsCollectionView;
@property (weak, nonatomic) IBOutlet CustomCalendar *calendarView;

@end

@implementation DashboardViewController
#define kCellIdentifier     @"kCellIdentifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DASHBOARD_BG_COLOR;
    
    [_bidsCollectionView registerNib:[UINib nibWithNibName:[[BidItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    _bidsCollectionView.delegate = self;
    _bidsCollectionView.dataSource = self;
    _bidsCollectionView.backgroundColor = DASHBOARD_BIDS_BG_COLOR;
    
    [_calendarView setCalendarDate:[NSDate date]];
    _calendarView.customCalendarDelegate = self;
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
    
    BidItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
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

- (void)tappedItem:(id)object {
    CalendarItem *calendarItem = object;
    CalendarItemState state = [calendarItem getState] == CalendarItemStateActive ? CalendarItemStateSelected : CalendarItemStateActive;
    
    [calendarItem setItemState:state];

}

@end

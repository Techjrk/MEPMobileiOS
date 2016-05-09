//
//  CustomCalendar.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomCalendar.h"

#import "calendarConstants.h"
#import "CalendarItemCollectionViewCell.h"
#import "CalendarItem.h"
#import "DerivedNSManagedObject.h"

@interface CustomCalendar()<UICollectionViewDelegate, UICollectionViewDataSource, CalendarItemCollectionViewCellDelegate>{
    NSDate *currentDate;
    
    NSInteger day;
    NSInteger noOfDays;
    
    NSObject *dayArray[35];
}

@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labelMonth;
@property (weak, nonatomic) IBOutlet UIView *monthConatinerView;
@end

@implementation CustomCalendar

#define kCellIdentifier     @"kCellIdentifier"

-(void)awakeFromNib {
    [super awakeFromNib];
    
    _contentContainer.layer.cornerRadius = 4;
    _contentContainer.layer.masksToBounds = YES;
    _buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _buttonRight.imageView.contentMode = UIViewContentModeScaleAspectFit;

    _contentContainer.backgroundColor = CALENDAR_CONTENT_VIEW_BG_COLOR;
    _monthConatinerView.backgroundColor = CALENDAR_MONTH_CONTAINER_VIEW_BG_COLOR;
    
    _labelMonth.font = CALENDAR_LABEL_MONTH_TEXT_FONT;
    _labelMonth.textColor = CALENDAR_LABEL_MONTH_TEXT_COLOR;
    _labelMonth.text = @"April";
    
    [_collectionView registerNib:[UINib nibWithNibName:[[CalendarItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    

}

- (void)layoutSubviews {
    
}
#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.calendarItemCollectionViewCellDelegate = self;
    
    NSDictionary *itemDict = (NSDictionary*)dayArray[indexPath.row];
    
    BOOL isActive = [itemDict[kItemActive] boolValue];
    [cell setItemInfo:itemDict];
    
    
    [cell setItemState:isActive?CalendarItemStateActive:CalendarItemStateInActive];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];

    if(self.customCalendarDelegate != nil){
        [self.customCalendarDelegate calendarItemWillDisplay:[cell calendarItem]];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5 * 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellWidth =  collectionView.frame.size.width / 7;
    CGFloat cellHeight = collectionView.frame.size.height / 5;
    size = CGSizeMake( cellWidth, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)tappedCalendarItemCollectionViewCell:(id)calendarItem {
    [self.customCalendarDelegate tappedItem:calendarItem];
}


- (void)setCalendarDate:(NSDate *)calendarDate {
    
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;

    currentDate = calendarDate;
    
    NSDateComponents *componentsBase = [[DataManager sharedManager] getDateComponents:calendarDate];
    //[componentsBase setDay:1];

    NSDate *firstDayOfMonthDate = [[DataManager sharedManager] getDateFirstDay:calendarDate];
    //NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: componentsBase];
    
    NSDateComponents *componentsFirstDay = [[DataManager sharedManager] getDateComponents:firstDayOfMonthDate];
    NSInteger startDay = componentsFirstDay.weekday - 1;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(componentsFirstDay.month-1)];

    _labelMonth.text = monthName;
    
    NSDate *lastDayOfMonthDate = [[DataManager sharedManager] getDateLastDay:calendarDate];
    NSDateComponents *componentsLastDay = [[DataManager sharedManager] getDateComponents:lastDayOfMonthDate];
    NSInteger lastDay = componentsLastDay.day;
    NSInteger lastWeekRow = componentsLastDay.weekdayOrdinal;
    NSInteger lastWeekDay = componentsLastDay.weekday;
    
    int daysOver = 0;
    for (int i = 0; i< lastDay; i++) {
        
        NSString *yearMonthDay = [NSString stringWithFormat:@"%li-%02d-%02d",(long)componentsFirstDay.year, (int)componentsFirstDay.month, i +1 ];
        
        dayArray[i+startDay] = @{kItemActive:[NSNumber numberWithBool:YES], kItemDay:@(i + 1), kItemTag:yearMonthDay};
        daysOver = i;
    }
    
    NSInteger addedDay = 1;
    for (long i = (7*lastWeekRow)-(7-lastWeekDay) ; i<35; i++) {
        dayArray[i] = @{kItemActive:[NSNumber numberWithBool:NO], kItemDay:@( addedDay )};
        addedDay++;
    }
    
    if (startDay != 0) {
        [componentsFirstDay setMonth:[componentsBase month]];
        [componentsFirstDay setDay:0];
        NSDate *previousDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: componentsFirstDay];
        
        NSDateComponents *componentsPrevious = [[DataManager sharedManager] getDateComponents:previousDayOfMonthDate];

        for (int i=0; i<componentsPrevious.weekday; i++) {
            dayArray[componentsPrevious.weekday - (i+1)] = @{kItemActive:[NSNumber numberWithBool:NO], kItemDay:@( componentsPrevious.day - i )};
        }

    }
//    _collectionView.delegate = self;
//    _collectionView.dataSource = self;
//    [_collectionView reloadData];
}

- (void)reloadData {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
}

@end

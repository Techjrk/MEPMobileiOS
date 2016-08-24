//
//  CustomCalendar.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomCalendar.h"

#import "CalendarItemCollectionViewCell.h"
#import "CalendarItem.h"

#define CALENDAR_BG_COLOR                                       RGB(5, 35, 74)
#define CALENDAR_CONTENT_VIEW_BG_COLOR                          RGB(5, 35, 74)
#define CALENDAR_MONTH_CONTAINER_VIEW_BG_COLOR                  RGB(248, 152, 28)

#define CALENDAR_LABEL_MONTH_TEXT_COLOR                         RGB(255, 255, 255)
#define CALENDAR_LABEL_MONTH_TEXT_FONT                          fontNameWithSize(FONT_NAME_LATO_BLACK, 17)


@interface CustomCalendar()<UICollectionViewDelegate, UICollectionViewDataSource, CalendarItemCollectionViewCellDelegate>{
    NSDate *currentDate;
    
    NSInteger day;
    NSInteger noOfDays;
    
    NSObject *dayArray[6*7];
    NSInteger weeksCount;
}

@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labelMonth;
@property (weak, nonatomic) IBOutlet UIView *monthConatinerView;
- (IBAction)tappedButton:(id)sender;
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
    return weeksCount * 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellWidth =  collectionView.frame.size.width / 7;
    CGFloat cellHeight = collectionView.frame.size.height / weeksCount;
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
    
    NSDate *date = currentDate;
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange weekRange = [calender rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date];
    weeksCount=weekRange.length;

    
    NSDateComponents *componentsBase = [[DataManager sharedManager] getDateComponents:calendarDate];

    NSDate *firstDayOfMonthDate = [[DataManager sharedManager] getDateFirstDay:calendarDate];
    
    NSDateComponents *componentsFirstDay = [[DataManager sharedManager] getDateComponents:firstDayOfMonthDate];
    NSInteger startDay = componentsFirstDay.weekday - 1;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(componentsFirstDay.month-1)];

    _labelMonth.text = monthName;
    
    NSDate *lastDayOfMonthDate = [[DataManager sharedManager] getDateLastDay:calendarDate];
    NSDateComponents *componentsLastDay = [[DataManager sharedManager] getDateComponents:lastDayOfMonthDate];
    NSInteger lastDay = componentsLastDay.day;
    
    NSInteger nextStartDay = 0;
    for (int i = 0; i< lastDay; i++) {
        
        NSString *yearMonthDay = [NSString stringWithFormat:@"%li-%02d-%02d",(long)componentsFirstDay.year, (int)componentsFirstDay.month, i +1 ];
        
        dayArray[i+startDay] = @{kItemActive:[NSNumber numberWithBool:YES], kItemDay:@(i + 1), kItemTag:yearMonthDay};
        nextStartDay = i+startDay;
    }
    
    nextStartDay++;
    NSInteger addedDay = 1;
    for (long i = nextStartDay ; i<(weeksCount*7); i++) {
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
}

- (void)reloadData {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
}

- (void)clearSelection {
    [[NSNotificationCenter defaultCenter] postNotificationName:CALENDAR_CLEAR_SELECTION object:self];
}

- (IBAction)tappedButton:(id)sender {
    
    [self.customCalendarDelegate tappedCalendarNavButton:[sender isEqual:_buttonLeft]?CalendarButtonLeft:CalendarButtonRight];
}
@end

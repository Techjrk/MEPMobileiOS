//
//  CalendarItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CalendarItemCollectionViewCell.h"

@interface CalendarItemCollectionViewCell()<CalendarItemDelegate>
@property (weak, nonatomic) IBOutlet CalendarItem *calendarItem;
@end

@implementation CalendarItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _calendarItem.calendarItemDelegate = self;
}

- (void)setItemState:(CalendarItemState)itemState {
    _calendarItem.itemState = itemState;
}

- (void)calendarItemTapped:(id)calendarTime {
    [self.calendarItemCollectionViewCellDelegate tappedCalendarItemCollectionViewCell:calendarTime];
}

- (void)setItemInfo:(id)info {
    [_calendarItem setItemInfo:info];
}

- (NSString*)itemTag {
    return [_calendarItem itemTag];
}

- (CalendarItem *)calendarItem {
    return _calendarItem;
}

@end

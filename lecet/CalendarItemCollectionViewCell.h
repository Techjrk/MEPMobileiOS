//
//  CalendarItemCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalendarItem.h"

@protocol CalendarItemCollectionViewCellDelegate <NSObject>
- (void)tappedCalendarItemCollectionViewCell:(id)calendarItem;
@end

@interface CalendarItemCollectionViewCell : UICollectionViewCell
@property (nonatomic) CalendarItemState itemState;
@property (weak, nonatomic) id<CalendarItemCollectionViewCellDelegate> calendarItemCollectionViewCellDelegate;
- (void) setItemInfo:(id)info;
- (NSString*)itemTag;
- (CalendarItem*)calendarItem;
@end

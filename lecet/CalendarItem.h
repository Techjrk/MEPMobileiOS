//
//  CalendarItem.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum  {
    CalendarItemStateActive = 0,
    CalendarItemStateInActive = 1,
    CalendarItemStateSelected = 2,
    CalendarItemStateMarked = 3,
} CalendarItemState;

@protocol CalendarItemDelegate <NSObject>
- (void)calendarItemTapped:(id)calendarTime;
@end

@interface CalendarItem : BaseViewClass
@property (nonatomic) CalendarItemState itemState;
@property (weak, nonatomic) id<CalendarItemDelegate> calendarItemDelegate;
- (CalendarItemState)getState;
- (CalendarItemState)getInitialState;
- (NSString*)itemTag;
- (void)setItemInfo:(id)info;
-(void)setInitialState:(CalendarItemState)state;
@end

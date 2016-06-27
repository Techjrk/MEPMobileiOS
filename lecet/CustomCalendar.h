//
//  CustomCalendar.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#define kItemActive         @"kItemActive"
#define kItemDay            @"kItemDay"
#define kItemTag            @"kItemTag"

#define CALENDAR_CLEAR_SELECTION                                @"CALENDAR_CLEAR_SELECTION"

typedef enum : NSUInteger {
    CalendarButtonLeft = 0,
    CalendarButtonRight = 1,
} CalendarButton;

@protocol CustomCalendarDelegate<NSObject>
- (void)tappedItem:(id)object;
- (void)calendarItemWillDisplay:(id)object;
- (void)tappedCalendarNavButton:(CalendarButton)calendarButton;
@end

@interface CustomCalendar : BaseViewClass
@property (weak,nonatomic) id<CustomCalendarDelegate> customCalendarDelegate;
- (void)setCalendarDate:(NSDate*)calendarDate;
- (void)reloadData;
- (void)clearSelection;
@end

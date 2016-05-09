//
//  CustomCalendar.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol CustomCalendarDelegate<NSObject>
- (void)tappedItem:(id)object;
- (void)calendarItemWillDisplay:(id)object;
@end

@interface CustomCalendar : BaseViewClass
@property (weak,nonatomic) id<CustomCalendarDelegate> customCalendarDelegate;
- (void)setCalendarDate:(NSDate*)calendarDate;
- (void)reloadData;
@end

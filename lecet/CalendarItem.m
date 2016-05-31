//
//  CalendarItem.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CalendarItem.h"

#import "calendarItemConstants.h"
#import "calendarConstants.h"
#import "constants.h"

@interface CalendarItem(){
    CalendarItemState state;
    CalendarItemState previousState;
    NSString *tag;
}
@property (weak, nonatomic) IBOutlet UIView *contentRound;
@property (weak, nonatomic) IBOutlet UIView *contenInner;
@property (weak, nonatomic) IBOutlet UILabel *labelItem;
- (IBAction)tappedButtonItem:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@end

@implementation CalendarItem

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelItem.text = @"26";
    _labelItem.font = CALENDAR_ITEM_TEXT_FONT;
    state = CalendarItemStateInActive;
    previousState = CalendarItemStateInActive;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearSelection:) name:CALENDAR_CLEAR_SELECTION object:nil];
    tag = nil;
}

- (void)clearSelection:(NSNotification*)notification{
    
    if ([self isDescendantOfView:notification.object]) {
        state = previousState;
        [self setNeedsDisplay];
    }
}

- (IBAction)tappedButtonItem:(id)sender {
    [self.calendarItemDelegate calendarItemTapped:self];
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if(self.itemTag == nil){
        state = CalendarItemStateInActive;
    }
    
    if ((state == CalendarItemStateActive) | (state == CalendarItemStateInActive)) {
        if (state == CalendarItemStateActive) {
            _labelItem.textColor = CALENDAR_ITEM_TEXT_COLOR;
        } else {
            _labelItem.textColor = CALENDAR_ITEM_INDICATOR_INACTIVE_COLOR;
          
        }
    } else if ( (state == CalendarItemStateMarked) | (state == CalendarItemStateSelected)) {
        
        _labelItem.textColor = CALENDAR_ITEM_TEXT_COLOR;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) * 0.35;
        CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        
        UIGraphicsPushContext(context);
        
        CGContextBeginPath(context);
        
        if (state == CalendarItemStateMarked) {
            CGFloat _startAngle = 0;
            CGFloat _endAngle = 359.99;
            
            CGMutablePathRef arc = CGPathCreateMutable();
            
            CGPathAddArc(arc, NULL, center.x, center.y, radius, DEGREES_TO_RADIANS(_startAngle) ,  DEGREES_TO_RADIANS(_endAngle), NO);
            
            
            CGFloat lineWidth = 0.5;
            CGPathRef strokedArc =
            CGPathCreateCopyByStrokingPath(arc, NULL,
                                           lineWidth,
                                           kCGLineCapButt,
                                           kCGLineJoinMiter, // the default
                                           1);
            
            
            CGContextAddPath(context, strokedArc);
            
            CGContextSetFillColorWithColor(context, CALENDAR_ITEM_INDICATOR_MARKED_COLOR.CGColor);
            CGContextSetStrokeColorWithColor(context, CALENDAR_ITEM_INDICATOR_MARKED_COLOR.CGColor);
            CGContextDrawPath(context, kCGPathFillStroke);
            
            CGPathRelease(strokedArc);
            CGPathRelease(arc);
        } else {
            
            CGRect borderRect = CGRectMake(center.x - radius, center.y - radius, radius * 2.0, radius * 2.0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(context, CALENDAR_ITEM_INDICATOR_SELECTED_COLOR.CGColor);
            CGContextSetFillColorWithColor(context, CALENDAR_ITEM_INDICATOR_SELECTED_COLOR.CGColor);
            CGContextSetLineWidth(context, 1.0);
            CGContextFillEllipseInRect (context, borderRect);
            CGContextStrokeEllipseInRect(context, borderRect);
            CGContextFillPath(context);
        }
        
        UIGraphicsPopContext();
    }
    
}

- (void)setInitialState:(CalendarItemState)itemState {
    previousState = itemState;
    [self setItemState:previousState];
}

- (void)setItemState:(CalendarItemState)itemState {
    state = itemState;
    
    _itemButton.userInteractionEnabled = state != CalendarItemStateInActive;
    [self setNeedsDisplay];
}

-(CalendarItemState)getState {
    return state;
}

-(CalendarItemState)getInitialState {
    return previousState;
}

- (void)setItemInfo:(id)info {
    
    if (info != nil) {
        NSNumber *number = info[kItemDay];
        NSString *text = [NSString stringWithFormat:@"%li",(long)[number integerValue]];
        tag = info[kItemTag];
        
        _labelItem.text = text;
    } else {
        _labelItem.text = @"";
        tag = nil;
    }
}

- (NSString*)itemTag {
    return tag;
}

@end

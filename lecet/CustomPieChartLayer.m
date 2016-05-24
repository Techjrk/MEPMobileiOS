//
//  CustomPieChartLayer.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomPieChartLayer.h"
#import <UIKit/UIKit.h>

#import "constants.h"

@interface CustomPieChartLayer(){
    BOOL hasFocus;
    BOOL hasFocusSegment;
}
@end

@implementation CustomPieChartLayer
@synthesize startAngle;
@synthesize endAngle;
@synthesize layerColor;
@synthesize piePath;
@synthesize focusImage;
@synthesize focusImageView;
@synthesize tagName;
@synthesize customPieChartLayerDelegate;

#define kHAS_FOCUS_SEGMENT @"kHAS_FOCUS_SEGMENT"

- (instancetype)init{
    self = [super init];
    
    return self;
}

- (void) drawInContext:(CGContextRef)context
{
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) * 0.3;
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);
    
    CGFloat _startAngle = 360 - self.startAngle;
    CGFloat _endAngle = 360 - self.endAngle;
    
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGPathAddArc(arc, NULL, center.x, center.y, radius, DEGREES_TO_RADIANS(_startAngle),  DEGREES_TO_RADIANS(_endAngle), YES);
    
    CGFloat multiplier = 0.1;
    if (hasFocus) {
        multiplier = 0.15;
    } else if (hasFocusSegment) {
        multiplier = 0.06;
    }
    
    CGFloat lineWidth = kDeviceWidth * multiplier;
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   lineWidth,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter, // the default
                                   10);

    CGContextAddPath(context, strokedArc);
    
    CGContextSetFillColorWithColor(context, self.layerColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.layerColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
 
    UIGraphicsPopContext();

    
    self.piePath = arc;
    
    CGPathRelease(strokedArc);
 
}

- (void)layerTapped {
    
    hasFocus = !hasFocus;
    [self.customPieChartLayerDelegate tappedPieSegmentLayer:self hasFocus:hasFocus];

}

- (BOOL)segmentHasFocus {
    return hasFocus;
}

- (void)setSegmentFocus:(BOOL)focus hasLayerFocus:(BOOL)focusSegment{
    hasFocus = focus;
    hasFocusSegment = focusSegment;
    
    if (hasFocus) {
        self.focusImageView.image = self.focusImage;
    } else {
        self.focusImageView.image = nil;
    }
    [self setNeedsDisplay];

}

@end

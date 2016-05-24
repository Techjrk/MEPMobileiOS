//
//  ActivityView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView
@dynamic layerColor;
@dynamic startAngle;
@dynamic endAngle;
@dynamic currentAngle;

- (void)drawInContext:(CGContextRef)context {
    CGFloat radius = MIN(kDeviceWidth, kDeviceHeight) * 0.1;
    CGPoint center = CGPointMake(kDeviceWidth/2.0, kDeviceHeight/2.0);
    
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);
    
    CGFloat _startAngle = 360 - self.startAngle;
    CGFloat _endAngle = 360 - self.endAngle;
    
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGPathAddArc(arc, NULL, center.x, center.y, radius, DEGREES_TO_RADIANS(_startAngle),  DEGREES_TO_RADIANS(_endAngle), YES);
    
    CGFloat multiplier = 0.05;
    
    CGFloat lineWidth = kDeviceWidth * multiplier;
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   lineWidth,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter,
                                   10);
    
    CGContextAddPath(context, strokedArc);
    
    CGContextSetFillColorWithColor(context, self.layerColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.layerColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIGraphicsPopContext();
    
    CGPathRelease(strokedArc);

}

- (id<CAAction>)actionForKey:(NSString *)event {
    
    if ([event isEqualToString:@"endAngle"]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.duration = 3.0;
        animation.fromValue = @(self.endAngle);
        return animation;
    }
    
    return [super actionForKey:event];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([@"endAngle" isEqualToString:key])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)display {
    [super display];

}

@end

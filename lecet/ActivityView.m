//
//  ActivityView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ActivityView.h"

@interface ActivityView(){
}
@end

@implementation ActivityView
@dynamic layerColor;
@dynamic startAngle;
@dynamic endAngle;
@dynamic currentAngle;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}


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
    
    ;
    CGContextSetFillColorWithColor(context, self.layerColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.layerColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIGraphicsPopContext();
    
    CGPathRelease(strokedArc);

}

/*
- (id<CAAction>)actionForKey:(NSString *)event {
    
    if ([self presentationLayer]!= nil) {
        if ([event isEqualToString:@"layerColor"]) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
            animation.toValue = [[self presentationLayer] valueForKey:event];
            return animation;
        }
    }
    
    return [super actionForKey:event];
}
*/

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

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [super animationDidStop:anim finished:flag];
    self.endAngle = 360;
    [self setNeedsDisplay];
}
@end

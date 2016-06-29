//
//  TransparentView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "TransparentView.h"

@implementation TransparentView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat radius = MAX(self.bounds.size.width, self.bounds.size.height) * 0.7;
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);
    
    CGFloat _startAngle = 0;
    CGFloat _endAngle = 359.99;
    
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGPathAddArc(arc, NULL, center.x, center.y, radius, DEGREES_TO_RADIANS(_startAngle) ,  DEGREES_TO_RADIANS(_endAngle), NO);
    
    
    CGFloat lineWidth = radius * 0.66;
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   lineWidth,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter, // the default
                                   radius);
    
    
    CGContextAddPath(context, strokedArc);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPathRelease(strokedArc);
    CGPathRelease(arc);

}


@end

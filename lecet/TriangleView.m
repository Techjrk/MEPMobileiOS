//
//  TriangleView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/22/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "TriangleView.h"

@interface TriangleView(){
    UIColor *fillColor;
}
@end

@implementation TriangleView

- (void)drawRect:(CGRect)rect {
    
    if (fillColor != nil) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGFloat x1Pos = rect.size.width * 0.5;
        CGFloat x2Pos = rect.size.width;
        
        CGFloat y1Pos = 0;
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, x1Pos, y1Pos);
        y1Pos = rect.size.height;
        CGContextAddLineToPoint(ctx, x2Pos, y1Pos);
        CGContextAddLineToPoint(ctx, 0, y1Pos);
        CGContextClosePath(ctx);
        
        CGFloat red, green, blue, alpha;
        

        [fillColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBFillColor(ctx, red, green, blue, alpha);
        CGContextFillPath(ctx);
    }
}


- (void)setObjectColor:(UIColor *)color {
    fillColor = color;
    [self setNeedsDisplay];
}
@end



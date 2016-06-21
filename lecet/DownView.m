//
//  DownView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/21/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DownView.h"

@interface DownView(){
    UIColor *fillColor;
}
@end

@implementation DownView

- (void)drawRect:(CGRect)rect {
    
    if (fillColor != nil) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGFloat x1Pos = rect.size.width * 0.5;
        
        CGFloat y1Pos = rect.size.height;
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, x1Pos, y1Pos);
        y1Pos = 0;
        CGContextAddLineToPoint(ctx, rect.size.width, y1Pos);
        CGContextAddLineToPoint(ctx, 0, 0);
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

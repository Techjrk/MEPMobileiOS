//
//  RadialBackgroundView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "RadialBackgroundView.h"

@implementation RadialBackgroundView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = [NSArray arrayWithObjects:(id)RGB(21, 78, 132).CGColor, (id)RGB(0, 36, 82).CGColor, nil];

    CGGradientRef gradient =CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, gradLocations);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter= CGPointMake(rect.size.width/2, rect.size.height/4);
    float gradRadius = MIN(rect.size.width , rect.size.height) ;
    
    CGContextDrawRadialGradient (context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
}

@end

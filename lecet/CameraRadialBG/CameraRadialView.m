//
//  CameraRadialView.m
//  lecet
//
//  Created by Michael San Minay on 30/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CameraRadialView.h"

@interface CameraRadialView ()

@end

@implementation CameraRadialView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = [NSArray arrayWithObjects:(id)RGB(21, 78, 132).CGColor, (id)RGB(3, 35, 77).CGColor, nil];
    
    CGGradientRef gradient =CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, gradLocations);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter= CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    float gradRadius = MIN(rect.size.width * 0.7, rect.size.height * 0.7) ;
    
    CGContextDrawRadialGradient (context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end

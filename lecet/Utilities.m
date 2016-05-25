//
//  Utilities.m
//  lecet
//
//  Created by Get Devs on 22/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(id)sharedIntances{
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
    
    
}


-(CAShapeLayer *)drawDropDownTopTriangle:(float)trianglePlacementBasedOnScreenWidth backgroundColor:(UIColor *)bgColorOfTriangle triangleTopDirection:(int)triangleTopDirection heightPlacement:(int)heightPlacement sizeOfTriangle:(int)triangleSizeInt{
    
    
    
    CAShapeLayer *dropDownTopTriangleShape;
    
    dropDownTopTriangleShape = [CAShapeLayer layer];
    
    UIColor *bgColor = bgColorOfTriangle;
    
    float trianglePlacement= 0.87f;
    
    
    //Screen Size for Y axiz
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
   // CGFloat screenWidth = screenRect.size.width;
    
    int height = heightPlacement;
    
    //float widthNeedToAdd = screenWidth * 0.021f;
    
    //float widthNeedToAdd = screenWidth * trianglePlacementBasedOnPercentage;
    //float width = screenWidth + widthNeedToAdd;
    
    float width = trianglePlacementBasedOnScreenWidth;
    
  //  int triangleDirection = -1; // 1 for down, -1 for up.
    
    int triangleDirection = triangleTopDirection;
    int triangleSize =  triangleSizeInt;
    int trianglePosition = trianglePlacement*width;
    
    
    UIBezierPath *triangleShape = [[UIBezierPath alloc] init];
    [triangleShape moveToPoint:CGPointMake(trianglePosition, height)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition+triangleSize, height+triangleDirection*triangleSize)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition+2*triangleSize, height)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition, height)];
    
    [dropDownTopTriangleShape setPath:triangleShape.CGPath];
    [dropDownTopTriangleShape setFillColor:bgColor.CGColor];
    
    [dropDownTopTriangleShape setBounds:CGRectMake(0.0f, 0.0f, height+triangleSize, width)];
    [dropDownTopTriangleShape setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    

    return dropDownTopTriangleShape;

}

-(UIBezierPath *)drawShadowPath{
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect customDimRect = screenRect;
    
    customDimRect.size.width = screenRect.size.width + 100;
    
    customDimRect.size.height = screenRect.size.height + 100;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:customDimRect];
    
    
    return shadowPath;
    
}



-(UIBezierPath *)drawShadowPathFrame:(CGRect)frame{
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect customDimRect = screenRect;
    
    customDimRect.size.width = screenRect.size.width + 100;
    
    customDimRect.size.height = screenRect.size.height + 100;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:frame];
    
    
    return shadowPath;
    
}


// Add Gesture
- (void)addTappGesture:(SEL)sel numberOfTapped:(int)tapNumber targetView:(id)targetView target:(id)target{
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    tapped.numberOfTapsRequired = tapNumber;
    [targetView addGestureRecognizer:tapped];
}



@end

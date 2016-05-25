//
//  Utilities.h
//  lecet
//
//  Created by Get Devs on 22/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject



+ (id)sharedIntances;

//Draw Triangle
-(CAShapeLayer *)drawDropDownTopTriangle:(float)trianglePlacementBasedOnScreenWidth backgroundColor:(UIColor *)bgColorOfTriangle triangleTopDirection:(int)triangleTopDirection heightPlacement:(int)heightPlacement sizeOfTriangle:(int)triangleSizeInt;

//ShadowPath
-(UIBezierPath *)drawShadowPath;



//Add Gesture
- (void)addTappGesture:(SEL)sel numberOfTapped:(int)tapNumber targetView:(id)targetView target:(id)target;
@end

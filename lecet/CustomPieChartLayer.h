//
//  CustomPieChartLayer.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@protocol CustomPieChartLayerDelegate <NSObject>
- (void)tappedPieSegmentLayer:(id)object hasFocus:(BOOL)hasFocus;
@end

@interface CustomPieChartLayer : CALayer
@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (strong, nonatomic) UIColor *layerColor;
@property (nonatomic) CGPathRef piePath;
@property (strong, nonatomic) UIImage *focusImage;
@property (weak, nonatomic) UIImageView *focusImageView;
@property (weak, nonatomic) NSString* tagName;
@property (weak) id <CustomPieChartLayerDelegate> customPieChartLayerDelegate;
@property (strong, nonatomic) NSNumber *count;
- (void)layerTapped;
- (BOOL)segmentHasFocus;
- (void)setSegmentFocus:(BOOL)focus hasLayerFocus:(BOOL)focusSegment;
@end

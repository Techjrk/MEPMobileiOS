//
//  ActivityView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : CALayer
@property (strong, nonatomic) UIColor *layerColor;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, assign) CGFloat endAngle;
@end

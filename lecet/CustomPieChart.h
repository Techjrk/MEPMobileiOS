//
//  CustomPieChart.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol CustomPieChartDelegate <NSObject>
- (void)tappedPieSegment:(id)object;
@end

@interface CustomPieChart : BaseViewClass
@property (weak) id <CustomPieChartDelegate> customPieChartDelegate;
- (void)clearLegends;
- (void)addPieItem:(NSString*)tagItem percent:(NSNumber*)percent legendColor:(UIColor*)legendColor focusImage:(UIImage*)focusImage;
- (void)tappedPieSegmentByTagName:(NSString*)tagName;
@end

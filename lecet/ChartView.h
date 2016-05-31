//
//  ChartView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum : NSUInteger {
    ChartButtonLeft = 0,
    ChartButtonRight = 1,
} ChartButton;

@protocol ChartViewDelegate <NSObject>
- (void)selectedItemChart:(NSString*)itemTag chart:(id)chart hasfocus:(BOOL)hasFocus;
- (void)tappedChartNavButton:(ChartButton)charButton;
@end

@interface ChartView : BaseViewClass
@property (strong, nonatomic) id<ChartViewDelegate>chartViewDelegate;
- (void)setSegmentItems:(NSMutableDictionary*)items;
- (void)hideLeftButton:(BOOL)hide;
- (void)hideRightButton:(BOOL)hide;
@end

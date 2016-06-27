//
//  ChartView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#define CHART_BUTTON_GROUP_BG_COLOR                 RGB(5, 35, 74)
#define CHART_BUTTON_HOUSING_COLOR                  RGB(252, 183, 108)
#define CHART_BUTTON_ENGINEERING_COLOR              RGB(248, 152, 28)
#define CHART_BUTTON_BUILDING_COLOR                 RGB(168, 195, 230)
#define CHART_BUTTON_UTILITIES_COLOR                RGB(76, 145, 209)

#define CHART_SEGMENT_TAG                           @"CHART_SEGMENT_TAG"
#define CHART_SEGMENT_COUNT                         @"CHART_SEGMENT_COUNT"
#define CHART_SEGMENT_COLOR                         @"CHART_SEGMENT_COLOR"
#define CHART_SEGMENT_IMAGE                         @"CHART_SEGMENT_IMAGE"
#define CHART_SEGMENT_PERCENTAGE                    @"CHART_SEGMENT_PERCENTAGE"

#define kTagNameHousing                             @"01_HOUSING"
#define kTagNameEngineering                         @"02_ENGINEERING"
#define kTagNameBuilding                            @"03_BUILDING"
#define kTagNameUtilities                           @"04_UTILITIES"

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

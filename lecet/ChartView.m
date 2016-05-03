//
//  ChartView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ChartView.h"

#import "chartConstants.h"
#import "CustomPieChart.h"
#import "CustomPieChartLayer.h"

@interface ChartView()<CustomPieChartDelegate>
@property (weak, nonatomic) IBOutlet UIView *chartButtonGroup;
@property (weak, nonatomic) IBOutlet UILabel *labelHousing;
@property (weak, nonatomic) IBOutlet UILabel *labelEngineering;
@property (weak, nonatomic) IBOutlet UILabel *labelBuilding;
@property (weak, nonatomic) IBOutlet UILabel *labelUtilities;
@property (weak, nonatomic) IBOutlet CustomPieChart *piechart;
@property (weak, nonatomic) IBOutlet UIButton *buttonHousing;
@property (weak, nonatomic) IBOutlet UIButton *buttonEngineering;
@property (weak, nonatomic) IBOutlet UIButton *buttonBuilding;
@property (weak, nonatomic) IBOutlet UIButton *buttonUtilities;
- (IBAction)tappedButtonHousing:(id)sender;
- (IBAction)tappedButtonEngineering:(id)sender;
- (IBAction)tappedButtonBuilding:(id)sender;
- (IBAction)tappedButtonUtilities:(id)sender;
@end

@implementation ChartView

#define kTagNameHousing                 @"01_HOUSING"
#define kTagNameEngineering             @"02_ENGINEERING"
#define kTagNameBuilding                @"03_BUILDING"
#define kTagNameUtilities               @"04_UTILITIES"


-(void)awakeFromNib {

    [super awakeFromNib];
    
    _chartButtonGroup.backgroundColor = CHART_BUTTON_GROUP_BG_COLOR;
    _chartButtonGroup.layer.cornerRadius = 4.0;
    _chartButtonGroup.layer.masksToBounds = YES;
    
    _labelHousing.text = NSLocalizedLanguage(@"CHART_VIEW_LABEL_HOUSING");
    _labelHousing.font = CHART_BUTTON_GROUP_LABEL_FONT;
    _labelHousing.textColor = CHART_BUTTON_HOUSING_COLOR;
    
    _labelEngineering.text = NSLocalizedLanguage(@"CHART_VIEW_LABEL_ENGINEERING");
    _labelEngineering.font = CHART_BUTTON_GROUP_LABEL_FONT;
    _labelEngineering.textColor = CHART_BUTTON_ENGINEERING_COLOR;
    
    _labelBuilding.text = NSLocalizedLanguage(@"CHART_VIEW_LABEL_BUILDING");
    _labelBuilding.font = CHART_BUTTON_GROUP_LABEL_FONT;
    _labelBuilding.textColor = CHART_BUTTON_BUILDING_COLOR;

    _labelUtilities.text = NSLocalizedLanguage(@"CHART_VIEW_LABEL_UTILITIES");
    _labelUtilities.font = CHART_BUTTON_GROUP_LABEL_FONT;
    _labelUtilities.textColor = CHART_BUTTON_UTILITIES_COLOR;
    
    [_piechart addPieItem:kTagNameHousing percent:@(25) legendColor:CHART_BUTTON_HOUSING_COLOR focusImage:[UIImage imageNamed:@"icon_housing"] ];
    [_piechart addPieItem:kTagNameEngineering percent:@(25) legendColor:CHART_BUTTON_ENGINEERING_COLOR focusImage:[UIImage imageNamed:@"icon_engineering"] ];
    [_piechart addPieItem:kTagNameBuilding percent:@(25) legendColor:CHART_BUTTON_BUILDING_COLOR focusImage:[UIImage imageNamed:@"icon_building"] ];
    [_piechart addPieItem:kTagNameUtilities percent:@(25) legendColor:CHART_BUTTON_UTILITIES_COLOR focusImage:[UIImage imageNamed:@"icon_utilities"] ];
    
    _piechart.customPieChartDelegate = self;
    
}

- (IBAction)tappedButtonHousing:(id)sender {
    [_piechart tappedPieSegmentByTagName:kTagNameHousing];
}

- (IBAction)tappedButtonEngineering:(id)sender {
    [_piechart tappedPieSegmentByTagName:kTagNameEngineering];
}

- (IBAction)tappedButtonBuilding:(id)sender {
    [_piechart tappedPieSegmentByTagName:kTagNameBuilding];
}

- (IBAction)tappedButtonUtilities:(id)sender {
    [_piechart tappedPieSegmentByTagName:kTagNameUtilities];
}

- (void)tappedPieSegment:(id)object {
    CustomPieChartLayer *layer = object;
    NSLog(@"%@ HAS FOCUS %@", layer.tagName, [layer segmentHasFocus]?@"YES":@"NO");
    
    _buttonHousing.backgroundColor = [UIColor clearColor];
    _buttonEngineering.backgroundColor = [UIColor clearColor];
    _buttonBuilding.backgroundColor = [UIColor clearColor];
    _buttonUtilities.backgroundColor = [UIColor clearColor];
    if ([layer segmentHasFocus]) {
        NSString *tagName = layer.tagName;
        if ([tagName isEqualToString:kTagNameHousing]) {
            _buttonHousing.backgroundColor = CHART_BUTTON_SELECTED_COLOR;
        } else if([tagName isEqualToString:kTagNameEngineering]) {
            _buttonEngineering.backgroundColor = CHART_BUTTON_SELECTED_COLOR;
        } else if([tagName isEqualToString:kTagNameBuilding]) {
            _buttonBuilding.backgroundColor = CHART_BUTTON_SELECTED_COLOR;
        } else {
            _buttonUtilities.backgroundColor = CHART_BUTTON_SELECTED_COLOR;
        }
    }
}

@end

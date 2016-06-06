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
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
- (IBAction)tappedButtonHousing:(id)sender;
- (IBAction)tappedButtonEngineering:(id)sender;
- (IBAction)tappedButtonBuilding:(id)sender;
- (IBAction)tappedButtonUtilities:(id)sender;
- (IBAction)tappedButton:(id)sender;
@end

@implementation ChartView

-(void)awakeFromNib {

    [super awakeFromNib];
    
    _buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _buttonRight.imageView.contentMode = UIViewContentModeScaleAspectFit;

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
    
    _piechart.customPieChartDelegate = self;
    
}

- (void)enableButton:(UIButton*)button enabled:(BOOL)enabled {
    button.enabled = enabled;
    if (button.enabled) {
        button.backgroundColor = [UIColor clearColor];
    } else {
        button.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    }
}

- (void)setSegmentItems:(NSMutableDictionary*)items {
    [self enableButton:_buttonHousing enabled:NO];
    [self enableButton:_buttonBuilding enabled:NO];
    [self enableButton:_buttonEngineering enabled:NO];
    [self enableButton:_buttonUtilities enabled:NO];
    
    for (NSString *key in items) {
        NSDictionary *item = items[key];
        
        NSString *tag = item[CHART_SEGMENT_TAG];
        NSNumber *percent = item[CHART_SEGMENT_PERCENTAGE];
        
        if ([tag isEqualToString:kTagNameHousing]) {
            [self enableButton:_buttonHousing enabled:YES];
        } else if ([tag isEqualToString:kTagNameBuilding]) {
            [self enableButton:_buttonBuilding enabled:YES];
        } else if ([tag isEqualToString:kTagNameEngineering]) {
            [self enableButton:_buttonEngineering enabled:YES];
        } else {
            [self enableButton:_buttonUtilities enabled:YES];
        }
        
        [_piechart addPieItem:tag percent:percent legendColor:item[CHART_SEGMENT_COLOR] focusImage:item[CHART_SEGMENT_IMAGE] ];
        [_piechart setNeedsDisplay];
    }
    
    [self setNeedsLayout];
    [self setupButtonAlpha];
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

- (void)changeButtonAlpha:(UIButton*)button alhpa:(CGFloat)alpha {
    UIView *parentView = [button superview];
    UIImageView *imageView = [parentView viewWithTag:1];
    if (imageView != nil) {
        imageView.alpha = button.enabled?alpha:0.3;
    }
    
    UILabel *label = [parentView viewWithTag:2];
    if (label != nil) {
        label.alpha = button.enabled?alpha:0.3;
    }
}

- (void)setupButtonAlpha {
    [self changeButtonAlpha:_buttonHousing alhpa:1.0];
    [self changeButtonAlpha:_buttonEngineering alhpa:1.0];
    [self changeButtonAlpha:_buttonBuilding alhpa:1.0];
    [self changeButtonAlpha:_buttonUtilities alhpa:1.0];
}

- (void)tappedPieSegment:(id)object chartView:(id)charView{
    CustomPieChartLayer *layer = object;
    
    _buttonHousing.backgroundColor = _buttonHousing.enabled?[UIColor clearColor]:_buttonHousing.backgroundColor;
    _buttonEngineering.backgroundColor = _buttonEngineering.enabled?[UIColor clearColor]:_buttonEngineering.backgroundColor;
    _buttonBuilding.backgroundColor = _buttonBuilding.enabled?[UIColor clearColor]:_buttonBuilding.backgroundColor;
    _buttonUtilities.backgroundColor = _buttonUtilities.enabled?[UIColor clearColor]:_buttonUtilities.backgroundColor;
    
    
    if ([layer segmentHasFocus]) {
        
        CGFloat alpha = 0.3;
        [self changeButtonAlpha:_buttonHousing alhpa:alpha];
        [self changeButtonAlpha:_buttonEngineering alhpa:alpha];
        [self changeButtonAlpha:_buttonBuilding alhpa:alpha];
        [self changeButtonAlpha:_buttonUtilities alhpa:alpha];
        
        NSString *tagName = layer.tagName;
        if ([tagName isEqualToString:kTagNameHousing]) {
            [self changeButtonAlpha:_buttonHousing alhpa:1.0];
            _buttonHousing.backgroundColor = CHART_BUTTON_SELECTED_COLOR;
        } else if([tagName isEqualToString:kTagNameEngineering]) {
            [self changeButtonAlpha:_buttonEngineering alhpa:1.0];
            _buttonEngineering.backgroundColor = CHART_BUTTON_SELECTED_COLOR;
        } else if([tagName isEqualToString:kTagNameBuilding]) {
            [self changeButtonAlpha:_buttonBuilding alhpa:1.0];
            _buttonBuilding.backgroundColor = CHART_BUTTON_SELECTED_COLOR;
        } else {
            [self changeButtonAlpha:_buttonUtilities alhpa:1.0];
            _buttonUtilities.backgroundColor = CHART_BUTTON_SELECTED_COLOR;
        }
    } else {
        [self setupButtonAlpha];
    }
    
    [self.chartViewDelegate selectedItemChart:layer.tagName chart:self hasfocus:[layer segmentHasFocus]];
}

- (IBAction)tappedButton:(id)sender {
    
    [self.chartViewDelegate tappedChartNavButton:[sender isEqual:_buttonLeft]?ChartButtonLeft:ChartButtonRight];
    
}

- (void)hideLeftButton:(BOOL)hide {
    _buttonLeft.hidden = hide;
}

- (void)hideRightButton:(BOOL)hide {
    _buttonRight.hidden = hide;
}

@end

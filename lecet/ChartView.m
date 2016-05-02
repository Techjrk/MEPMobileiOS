//
//  ChartView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ChartView.h"

#import "chartConstants.h"

@interface ChartView()
@property (weak, nonatomic) IBOutlet UIView *chartButtonGroup;
@property (weak, nonatomic) IBOutlet UILabel *labelHousing;
@property (weak, nonatomic) IBOutlet UILabel *labelEngineering;
@property (weak, nonatomic) IBOutlet UILabel *labelBuilding;
@property (weak, nonatomic) IBOutlet UILabel *labelUtilities;
- (IBAction)tappedButtonHousing:(id)sender;
- (IBAction)tappedButtonEngineering:(id)sender;
- (IBAction)tappedButtonBuilding:(id)sender;
- (IBAction)tappedButtonUtilities:(id)sender;
@end

@implementation ChartView

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
}

- (IBAction)tappedButtonHousing:(id)sender {
}

- (IBAction)tappedButtonEngineering:(id)sender {
}

- (IBAction)tappedButtonBuilding:(id)sender {
}

- (IBAction)tappedButtonUtilities:(id)sender {
}
@end

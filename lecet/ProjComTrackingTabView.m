//
//  ProjComTrackingTabView.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjComTrackingTabView.h"

#define PROJCOMTRACKINGTAB_SWITCHBUTTON_BG_COLOR            RGB(168,195,230)
#define PROJCOMTRACKINGTAB_LABEL_FONT                       fontNameWithSize(FONT_NAME_LATO_BOLD, 10)
#define PROJCOMTRACKINGTAB_LABEL_FONT_COLOR                 RGB(255,255,255)

#define PROJCOMTRACKINGTAB_BUTTON_FONT                      fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define PROJCOMTRACKINGTAB_BUTTON_FONT_COLOR                RGB(168,195,230)

#define PROJCOMTRACKINGTAB_VIEW_BG_COLOR                    RGB(5, 35, 74)

@interface ProjComTrackingTabView ()
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation ProjComTrackingTabView

- (void)awakeFromNib {
    
    [_switchButton setOnTintColor:PROJCOMTRACKINGTAB_SWITCHBUTTON_BG_COLOR];
    _label.font = PROJCOMTRACKINGTAB_LABEL_FONT;
    _label.textColor = PROJCOMTRACKINGTAB_LABEL_FONT_COLOR;
    _rightButton.titleLabel.font = PROJCOMTRACKINGTAB_BUTTON_FONT;
    [_rightButton setTitleColor:PROJCOMTRACKINGTAB_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    [self.view setBackgroundColor:PROJCOMTRACKINGTAB_VIEW_BG_COLOR];
    
}

- (IBAction)switchButtonChanged:(id)sender {
    [_projComTrackingTabViewDelegate switchTabButtonStateChange:[_switchButton isOn]];
}
- (IBAction)tappedEditButton:(id)sender {
    [_projComTrackingTabViewDelegate editTabButtonTapped];
}


@end

//
//  HiddenProjectView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "HiddenProjectView.h"

#define HIDDEN_PROJECT_CELL_LINE_COLOR              RGB(193, 193, 193)

#define HIDDEN_PROJECT_TITLE_FONT                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define HIDDEN_PROJECT_TITLE_COLOR                  RGB(34, 34, 34)

#define HIDDEN_PROJECT_LOCATION_FONT                fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define HIDDEN_PROJECT_LOCATION_COLOR               RGB(159, 164, 166)

#define HIDDEN_PROJECT_HIDE_FONT                    fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define HIDDEN_PROJECT_UNHIDE_COLOR                 RGB(0, 63, 114)
#define HIDDEN_PROJECT_HIDE_COLOR                   RGB(168, 195, 230)

@interface HiddenProjectView()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonUnhide;
- (IBAction)tappedUnhideButton:(id)sender;
@end

@implementation HiddenProjectView

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.backgroundColor = HIDDEN_PROJECT_CELL_LINE_COLOR;
    
    _labelTitle.font = HIDDEN_PROJECT_TITLE_FONT;
    _labelTitle.textColor = HIDDEN_PROJECT_TITLE_COLOR;
    
    _labelLocation.font = HIDDEN_PROJECT_LOCATION_FONT;
    _labelLocation.textColor = HIDDEN_PROJECT_LOCATION_COLOR;
    
    _buttonUnhide.titleLabel.font = HIDDEN_PROJECT_HIDE_FONT;
    [_buttonUnhide setTitle:NSLocalizedLanguage(@"HIDDEN_PROJECT_UNHIDE") forState:UIControlStateNormal];
    [_buttonUnhide setTitleColor:HIDDEN_PROJECT_UNHIDE_COLOR forState:UIControlStateNormal];
    
    [_buttonUnhide setTitle:NSLocalizedLanguage(@"HIDDEN_PROJECT_HIDE") forState:UIControlStateSelected];
    [_buttonUnhide setTitleColor:HIDDEN_PROJECT_HIDE_COLOR forState:UIControlStateSelected];
    
    //_buttonUnhide.selected = YES;
}

- (void)setInfo:(id)info {
    
}

- (IBAction)tappedUnhideButton:(id)sender {
    [[DataManager sharedManager] featureNotAvailable];
}

@end

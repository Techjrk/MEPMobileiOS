//
//  ProjectStateView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectStateView.h"

#define PROJECT_STATE_BUTTON_TEXT_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)
#define PROJECT_STATE_BUTTON_SHADOW_COLOR           RGB(0, 0, 0)

#define PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE      RGB(0, 56, 114)
#define PROJECT_STATE_BUTTON_TEXT_COLOR_SELECTED    RGB(255, 255, 255)

#define PROJECT_STATE_BUTTON_BG_COLOR_ACTIVE        RGB(255, 255, 255)
#define PROJECT_STATE_BUTTON_BG_COLOR_SELECTED      RGB(0, 56, 114)

#define PROJECT_STATE_CARET_DOWN_TEXT               [NSString stringWithFormat:@"%C", 0xf0d7]
#define PROJECT_STATE_CARET_DOWN_FONT               fontNameWithSize(FONT_NAME_AWESOME, 11)

@interface ProjectStateView()
@property (weak, nonatomic) IBOutlet UIButton *buttonTrack;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIButton *buttonHide;
- (IBAction)tappedButton:(id)sender;
@end

@implementation ProjectStateView
@synthesize projectStateViewDelegate;

- (void)awakeFromNib {
    [self clearSelection];
    
    [_buttonShare setTitle:NSLocalizedLanguage(@"PROJECT_STATE_SHARE") forState:UIControlStateNormal];
    [_buttonHide setTitle:NSLocalizedLanguage(@"PROJECT_STATE_HIDE") forState:UIControlStateNormal];
    [_buttonTrack setTitle:NSLocalizedLanguage(@"PROJECT_STATE_TRACK") forState:UIControlStateNormal];
    
    
    self.layer.shadowColor = [PROJECT_STATE_BUTTON_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    
    _buttonTrack.tag = StateViewTrack;
    _buttonShare.tag = StateViewShare;
    _buttonHide.tag = StateViewHide;

}

- (void)clearSelection {
    _buttonTrack.selected = NO;
    _buttonShare.selected = NO;
    _buttonHide.selected = NO;
    [self setupSelection];
}

- (void)setupSelection {
    [self setupButton:_buttonTrack];
    [self setupButton:_buttonHide];
    [self setupButton:_buttonShare];
}

- (void)setupButton:(UIButton*)button {
    
    BOOL isSelected = button.selected;
    button.selected = NO;
    
    button.titleLabel.font = PROJECT_STATE_BUTTON_TEXT_FONT;
    if (!isSelected) {
        [button setTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE forState:UIControlStateNormal];
        button.backgroundColor = PROJECT_STATE_BUTTON_BG_COLOR_ACTIVE;
    } else {
        [button setTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_SELECTED forState:UIControlStateNormal];
        button.backgroundColor = PROJECT_STATE_BUTTON_BG_COLOR_SELECTED;
    }

    button.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    button.layer.borderWidth = 0.5;
    button.layer.masksToBounds = YES;
}

- (void)selectButton:(UIButton*)button {
    _buttonTrack.selected = [_buttonTrack isEqual:button];
    _buttonShare.selected = [_buttonShare isEqual:button];
    _buttonHide.selected = [_buttonHide isEqual:button];
  
    [self setupSelection];
    [self.projectStateViewDelegate selectedStateViewItem:(StateView)button.tag view:button];
    
}

- (IBAction)tappedButton:(id)sender {
    [self selectButton:sender];
}


@end

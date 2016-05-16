//
//  ProjectStateView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectStateView.h"
#import "projectStateConstants.h"

@interface ProjectStateView()
@property (weak, nonatomic) IBOutlet UIButton *buttonTrack;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIButton *buttonHide;
- (IBAction)tappedButton:(id)sender;
@end

@implementation ProjectStateView

- (void)awakeFromNib {
    [self clearSelection];
    
    [self setButtonTackTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE];
    [_buttonShare setTitle:NSLocalizedLanguage(@"PROJECT_STATE_SHARE") forState:UIControlStateNormal];
    [_buttonHide setTitle:NSLocalizedLanguage(@"PROJECT_STATE_HIDE") forState:UIControlStateNormal];
    
    self.layer.shadowColor = [PROJECT_STATE_BUTTON_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;

}

- (void)setButtonTackTitleColor:(UIColor*)color {
    
    [UIView performWithoutAnimation:^{
        NSAttributedString *caret = [[NSAttributedString alloc] initWithString:PROJECT_STATE_CARET_DOWN_TEXT attributes:@{NSFontAttributeName:PROJECT_STATE_CARET_DOWN_FONT, NSForegroundColorAttributeName:color}];
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",NSLocalizedLanguage(@"PROJECT_STATE_TRACK")] attributes:@{NSFontAttributeName: PROJECT_STATE_BUTTON_TEXT_FONT, NSForegroundColorAttributeName:color}];
        
        [title appendAttributedString:caret];
        
        [_buttonTrack setAttributedTitle:title forState:UIControlStateNormal];
        [_buttonTrack layoutIfNeeded];
    }];
    
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
    if (![button isEqual:_buttonTrack]) {
        button.titleLabel.font = PROJECT_STATE_BUTTON_TEXT_FONT;
        if (!isSelected) {
            [button setTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE forState:UIControlStateNormal];
            button.backgroundColor = PROJECT_STATE_BUTTON_BG_COLOR_ACTIVE;
        } else {
            [button setTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_SELECTED forState:UIControlStateNormal];
            button.backgroundColor = PROJECT_STATE_BUTTON_BG_COLOR_SELECTED;
        }
    } else {
        if (!isSelected) {
            [self setButtonTackTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE];
            button.backgroundColor = PROJECT_STATE_BUTTON_BG_COLOR_ACTIVE;
        } else {
            [self setButtonTackTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_SELECTED];
            button.backgroundColor = PROJECT_STATE_BUTTON_BG_COLOR_SELECTED;
        }
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
    
}

- (IBAction)tappedButton:(id)sender {
    [self selectButton:sender];
}


@end

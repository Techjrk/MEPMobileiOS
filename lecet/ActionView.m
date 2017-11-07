//
//  ActionView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 10/26/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ActionView.h"

#define colorButtonNormal                   RGB(8, 36, 75)
#define colorButtonTapped                   RGB(248, 153, 0)
#define colorButtonTitle                    RGB(248, 153, 0)

#define fontButton                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)

@interface ActionView() 
    @property (weak, nonatomic) IBOutlet UIButton *buttonTrack;
    @property (weak, nonatomic) IBOutlet UILabel *labelTrack;
    @property (weak, nonatomic) IBOutlet UIButton *buttonShare;
    @property (weak, nonatomic) IBOutlet UILabel *labelShare;
    @property (weak, nonatomic) IBOutlet UIButton *buttonHide;
    @property (weak, nonatomic) IBOutlet UILabel *labelHide;
    @property (weak, nonatomic) IBOutlet UIView *viewHide;
    @property (weak, nonatomic) IBOutlet UILabel *labelTextHide;
    @property (weak, nonatomic) IBOutlet UIView *viewAction;

@end

@implementation ActionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buttonTrack.backgroundColor = colorButtonNormal;
    self.buttonTrack.layer.cornerRadius = 5;
    self.labelTrack.textColor = [UIColor whiteColor];
    self.labelTrack.font = fontButton;
    self.labelTrack.text = NSLocalizedLanguage(@"PLC_TRACK");
    
    self.buttonShare.backgroundColor = colorButtonNormal;
    self.buttonShare.layer.cornerRadius = 5;
    self.labelShare.textColor = [UIColor whiteColor];
    self.labelShare.font = fontButton;
    self.labelShare.text = NSLocalizedLanguage(@"PLC_SHARE");
    
    self.buttonHide.backgroundColor = colorButtonNormal;
    self.buttonHide.layer.cornerRadius = 5;
    self.labelHide.textColor = [UIColor whiteColor];
    self.labelHide.font = fontButton;
    self.labelHide.text = NSLocalizedLanguage(@"PLC_HIDE");
    
    [self setUndoLabelTextColor:[UIColor whiteColor]];
    [self projectHidden:YES];
}

- (void)setUndoLabelTextColor:(UIColor*)color {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedLanguage(@"PLC_PROJECT_HIDDEN") attributes:@{NSFontAttributeName: fontButton, NSForegroundColorAttributeName: color}];
    
    NSAttributedString *undo = [[NSAttributedString alloc] initWithString:NSLocalizedLanguage(@"PLC_UNDO") attributes:@{NSFontAttributeName: fontButton, NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    
    [attributedString appendAttributedString:undo];
    
    self.labelTextHide.attributedText = attributedString;
}

- (void)swipeExpand:(UISwipeGestureRecognizerDirection)direction {
    
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        self.constraintHorizontal.constant = -(self.frame.size.width * 0.75);
    } else {
        self.constraintHorizontal.constant = 0;
    }
    
    [self.superview setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            if (self.constraintHorizontal.constant < 0) {
                if (self.actionViewDelegate) {
                    [self.actionViewDelegate didExpand:self];
                }
            }
        }
    }];
    
}

- (void)resetStatus {
    self.buttonTrack.backgroundColor = colorButtonNormal;
    self.buttonShare.backgroundColor = colorButtonNormal;
    self.buttonHide.backgroundColor = colorButtonNormal;
}

- (void)projectHidden:(BOOL)hidden {
    self.viewHide.hidden = !hidden;
    self.viewContainer.hidden = hidden;
    self.viewAction.hidden = hidden;
}

- (UIView*)trackButton {
    return self.buttonTrack;
}

- (UIView*)shareButton {
    return self.buttonShare;
}

#pragma mark - IBAction

- (IBAction)tappedButtonSelected:(id)sender {
    if (self.actionViewDelegate) {
        [self.actionViewDelegate didSelectItem:self];
    }
}

- (IBAction)tappedButtonTrack:(id)sender {
    if (self.actionViewDelegate) {
        self.buttonTrack.backgroundColor = colorButtonTapped;
        [self.actionViewDelegate didTrackItem:self];
    }
}

- (IBAction)tappedButtonShare:(id)sender {
    if (self.actionViewDelegate) {
        self.buttonShare.backgroundColor = colorButtonTapped;
        [self.actionViewDelegate didShareItem:self];
    }
}

- (IBAction)tappedButtonHide:(id)sender {
    if (self.actionViewDelegate) {
        [self.actionViewDelegate didHideItem:self];
    }
}

- (IBAction)tappedButtonUndo:(id)sender {
    if (self.actionViewDelegate) {
        [self.actionViewDelegate undoHide:self];
    }
}


@end

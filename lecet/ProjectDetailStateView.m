//
//  ProjectDetailStateView.m
//  lecet
//
//  Created by Michael San Minay on 24/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectDetailStateView.h"

#import "projectDetailStateConstants.h"


@interface ProjectDetailStateView ()
@property (weak, nonatomic) IBOutlet UIButton *buttonHideProject;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleForDetailState;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonHideProjectHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHideProjectLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCancelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCancelButtonBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHideButtom;

- (IBAction)tappedProjectDetailState:(id)sender;

@end

@implementation ProjectDetailStateView

- (void)awakeFromNib{
    
    
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    _buttonHideProject.tag = ProjectDetailStateHideProject;
    _buttonCancel.tag = ProjectDetailStateCancel;
    
    _buttonHideProject.backgroundColor = PROJECTDETAIL_HIDEPROJECT_BUTTON_BG_COLOR;
    
    [_buttonHideProject setTitleColor:PROJECTDETAIL_HIDEPROJECT_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    _buttonHideProject.titleLabel.font = PROJECTDETAIL_HIDEPROJECT_BUTTON_FONT;
    
    _buttonCancel.titleLabel.font = PROJECTDETAIL_CANCEL_BUTTON_FONT;
    [_buttonCancel setTitleColor:PROJECTDETAIL_CANCEL_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    
    [_buttonHideProject setTitle:NSLocalizedLanguage(@"PROJECTDETAILSATE_HIDEPROJECT_BUTTON_TEXT")  forState:UIControlStateNormal];
    [_buttonCancel setTitle:NSLocalizedLanguage(@"PROJECTDETAILSATE_CANCEL_BUTTON_TEXT") forState:UIControlStateNormal];
    
    _labelTitleForDetailState.textColor = PROJECTDETAIL_TITLE_LABEL_FONT_COLOR;
    _labelTitleForDetailState.font = PROJECTDETAIL_TITLE_LABEL_FONT;
    
    _labelTitleForDetailState.text = NSLocalizedLanguage(@"PROJECTDETAILSATE_TITLE_LABEL_TEXT");
    
    
    
    
      //[self drawShadow];
    
    
    [self setAutoLayoutInIncompatibleDevice];
}


- (void)drawShadow{
    
    
    CGRect screenRect = self.bounds;
    
    CGRect customDimRect = screenRect;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:customDimRect];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
    
    
    
    [self.view.layer setCornerRadius:5.0f];
    
}








- (IBAction)tappedProjectDetailState:(id)sender {
    
    UIButton *button = sender;
    
    [_projectDetailStateDelegate tappedProjectDetailState:(ProjectDetailStateItem)button.tag];
    
    
    
}



- (void)setAutoLayoutInIncompatibleDevice{
    if (isiPhone4) {
        
        _constraintButtonHideProjectHeight.constant = 25;
        _constraintHideProjectLeading.constant = 70;
        _constraintCancelHeight.constant = 27;
        _constraintCancelButtonBottom.constant = 5;
        _constraintHideButtom.constant = 10;
    }
    
    
    if (isiPhone5) {
        
        _constraintButtonHideProjectHeight.constant = 30;
        _constraintHideProjectLeading.constant = 60;
        _constraintCancelButtonBottom.constant = 12;
        _constraintCancelHeight.constant = 22;
    }
    
    
    
}


@end

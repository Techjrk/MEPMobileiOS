//
//  ProjectTabView.m
//  lecet
//
//  Created by Michael San Minay on 03/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTabView.h"
#import "projectTabConstant.h"

@interface ProjectTabView (){
    
    
    float originalConstantValue;
}
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeftSideLeadingSpace;

@property (weak, nonatomic) IBOutlet UIButton *buttonUpcoming;

@property (weak, nonatomic) IBOutlet UIButton *buttonPast;

@end




@implementation ProjectTabView

static const float animationDuration = 1.0f;

- (void)awakeFromNib {
    
    _buttonUpcoming.tag = ProjectTabUpcoming;
    _buttonPast.tag = ProjectTabPast;
    
    _buttonUpcoming.titleLabel.font = PRODJECT_TAB_BUTTON_FONT;
    [_buttonUpcoming setTitleColor:PRODJECT_TAB_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    _buttonPast.titleLabel.font = PRODJECT_TAB_BUTTON_FONT;
    [_buttonPast setTitleColor:PRODJECT_TAB_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    
    NSString *upcomingText = [NSString stringWithFormat:@"12 %@",NSLocalizedLanguage(@"PROJECTTAB_UPCOMING_TEXT")];
    NSString *pastText = [NSString stringWithFormat:@"64 %@",NSLocalizedLanguage(@"PROJECTTAB_PAST_TEXT")];
    [_buttonUpcoming setTitle:upcomingText forState:UIControlStateNormal];
    [_buttonPast setTitle:pastText forState:UIControlStateNormal];
    
    
    [_buttonUpcoming setBackgroundColor:[UIColor clearColor]];
    [_buttonPast setBackgroundColor:[UIColor clearColor]];
    [_bottomLineView setBackgroundColor:PROJECT_TAB_SLIDING_VIEW_BG_COLOR];
    [self.view setBackgroundColor:[PROJECT_TAB_VIEW_BG_COLOR colorWithAlphaComponent:45.0f]];
   
    originalConstantValue = _constraintLeftSideLeadingSpace.constant;
}



- (IBAction)tappedButton:(id)sender {


    UIButton *button = sender;
    
    float constantForConstraint = 0.0f;
    
    if (button.tag == ProjectTabPast) {
        
        CGRect frame = self.frame;
        CGRect frameButtonView = _buttonPast.frame;
        constantForConstraint = (frame.size.width/2) + ((frameButtonView.size.width/2) * 0.5f);
    }
    if (button.tag == ProjectTabUpcoming) {
        
        
        constantForConstraint = originalConstantValue;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        _constraintLeftSideLeadingSpace.constant = constantForConstraint;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [[DataManager sharedManager] featureNotAvailable];
        [_projectTabViewDelegate tappedProjectTab:(ProjectTabItem)button.tag];
    }];

    
}






@end

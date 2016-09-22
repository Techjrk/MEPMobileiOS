//
//  ProjectTabView.m
//  lecet
//
//  Created by Michael San Minay on 03/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTabView.h"

#define PRODJECT_TAB_BUTTON_FONT                    fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define PRODJECT_TAB_BUTTON_FONT_COLOR              RGB(255,255,255)

#define PROJECT_TAB_SLIDING_VIEW_BG_COLOR           RGB(248,152,28)
#define PROJECT_TAB_VIEW_BG_COLOR                   RGB(5, 35, 74)

@interface ProjectTabView (){
    BOOL isShown;
}
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeftSideLeadingSpace;
@property (weak, nonatomic) IBOutlet UIButton *buttonUpcoming;
@property (weak, nonatomic) IBOutlet UIButton *buttonPast;
@end

@implementation ProjectTabView

static const float animationDuration = 0.25f;

- (void)awakeFromNib {
    [super awakeFromNib];
    _buttonUpcoming.tag = ProjectTabUpcoming;
    _buttonPast.tag = ProjectTabPast;
    
    _buttonUpcoming.titleLabel.font = PRODJECT_TAB_BUTTON_FONT;
    [_buttonUpcoming setTitleColor:PRODJECT_TAB_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    _buttonPast.titleLabel.font = PRODJECT_TAB_BUTTON_FONT;
    [_buttonPast setTitleColor:PRODJECT_TAB_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    NSString *upcomingText = @"";
    NSString *pastText = @"";
    [_buttonUpcoming setTitle:upcomingText forState:UIControlStateNormal];
    [_buttonPast setTitle:pastText forState:UIControlStateNormal];
    
    
    [_buttonUpcoming setBackgroundColor:[UIColor clearColor]];
    [_buttonPast setBackgroundColor:[UIColor clearColor]];
    [_bottomLineView setBackgroundColor:PROJECT_TAB_SLIDING_VIEW_BG_COLOR];
    [self.view setBackgroundColor:[PROJECT_TAB_VIEW_BG_COLOR colorWithAlphaComponent:45.0f]];
   
}

- (void)setCounts:(NSUInteger)upcoming past:(NSUInteger)past {
    
    NSString *upcomingText = [NSString stringWithFormat:@"%li %@", (long)upcoming,NSLocalizedLanguage(@"PROJECTTAB_UPCOMING_TEXT")];
    NSString *pastText = [NSString stringWithFormat:@"%li %@", (long)past,NSLocalizedLanguage(@"PROJECTTAB_PAST_TEXT")];
    [_buttonUpcoming setTitle:upcomingText forState:UIControlStateNormal];
    [_buttonPast setTitle:pastText forState:UIControlStateNormal];

}

- (IBAction)tappedButton:(id)sender {

    UIButton *button = sender;
    
    CGRect buttonRect = button.frame;
    CGFloat lineWidth = _bottomLineView.frame.size.width;

    float constantForConstraint = buttonRect.origin.x + ((buttonRect.size.width - lineWidth)/2.0);
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        _constraintLeftSideLeadingSpace.constant = constantForConstraint;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (isShown) {
                [_projectTabViewDelegate tappedProjectTab:(ProjectTabItem)button.tag];
            }
        }
        
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!isShown) {
        [self tappedButton:_buttonUpcoming];
        isShown = YES;
    }
}


@end

//
//  ProjectNearMeListMe.m
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearMeListView.h"

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)

@interface ProjectNearMeListView ()
    @property (weak, nonatomic) IBOutlet UIButton *preBidButton;
    @property (weak, nonatomic) IBOutlet UIButton *postBidButton;
    @property (weak, nonatomic) IBOutlet UIView *topHeaderView;
    @property (weak, nonatomic) IBOutlet UIView *markerView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMarkerLeading;

@end

@implementation ProjectNearMeListView

    - (void)awakeFromNib {
        [super awakeFromNib];
        
        
        _topHeaderView.backgroundColor = TOP_HEADER_BG_COLOR;
        _markerView.backgroundColor = BUTTON_MARKER_COLOR;
        
        _preBidButton.titleLabel.font = BUTTON_FONT;
        [_preBidButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        [_preBidButton setTitle:NSLocalizedLanguage(@"Pre Bid") forState:UIControlStateNormal];
        
        _postBidButton.titleLabel.font = BUTTON_FONT;
        [_postBidButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        [_postBidButton setTitle:NSLocalizedLanguage(@"Post Bid") forState:UIControlStateNormal];
        
    }
    
- (IBAction)tappedButton:(id)sender {
    UIButton *button = sender;
    
    _constraintMarkerLeading.constant = button.frame.origin.x;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];

}

@end

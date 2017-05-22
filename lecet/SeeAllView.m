//
//  SeeAllView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SeeAllView.h"

#define SEE_ALL_ANGLE_FONT                      fontNameWithSize(FONT_NAME_AWESOME, 12)

#define SEE_ALL_ANGLE_DOWN_TEXT                 [NSString stringWithFormat:@"%C", 0xf107]
#define SEE_ALL_ANGLE_UP_TEXT                   [NSString stringWithFormat:@"%C", 0xf106]

#define SEE_ALL_BUTTON_TEXT_FONT                fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define SEE_ALL_BUTTON_TEXT_COLOR               RGB(121, 120, 120)

@interface SeeAllView()
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeAll;
- (IBAction)tappedButtonSeeAll:(id)sender;
@end

@implementation SeeAllView
@synthesize seeAllViewDelegate;
@synthesize isExpanded;

- (void)awakeFromNib {
    [super awakeFromNib];

    [self changeTitle:NO];
}

- (void)changeTitle:(BOOL)expand {
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedLanguage(expand?@"SEE_ALL_BUTTON_TITLE_HIDE" :@"SEE_ALL_BUTTON_TITLE_SEE") attributes:@{NSFontAttributeName:SEE_ALL_BUTTON_TEXT_FONT, NSForegroundColorAttributeName:SEE_ALL_BUTTON_TEXT_COLOR}];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", expand?SEE_ALL_ANGLE_UP_TEXT :SEE_ALL_ANGLE_DOWN_TEXT] attributes:@{NSFontAttributeName:SEE_ALL_ANGLE_FONT, NSForegroundColorAttributeName:SEE_ALL_BUTTON_TEXT_COLOR}]];
    
    [_buttonSeeAll setAttributedTitle:title forState:UIControlStateNormal];
}

- (IBAction)tappedButtonSeeAll:(id)sender {
    self.isExpanded = !self.isExpanded;
    [self changeTitle:self.isExpanded];
    [self.seeAllViewDelegate tappedSeeAllView:self];
}

@end

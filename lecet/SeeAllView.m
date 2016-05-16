//
//  SeeAllView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SeeAllView.h"

#import "seeAllConstants.h"

@interface SeeAllView()
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeAll;

@end

@implementation SeeAllView

- (void)awakeFromNib {
    [super awakeFromNib];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedLanguage(@"SEE_ALL_BUTTON_TITLE") attributes:@{NSFontAttributeName:SEE_ALL_BUTTON_TEXT_FONT, NSForegroundColorAttributeName:SEE_ALL_BUTTON_TEXT_COLOR}];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", SEE_ALL_ANGLE_DOWN_TEXT] attributes:@{NSFontAttributeName:SEE_ALL_ANGLE_DOWN_FONT, NSForegroundColorAttributeName:SEE_ALL_BUTTON_TEXT_COLOR}]];
    
    [_buttonSeeAll setAttributedTitle:title forState:UIControlStateNormal];
}
@end

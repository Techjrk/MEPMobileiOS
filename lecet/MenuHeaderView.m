//
//  MenuHeaderView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MenuHeaderView.h"

#import "menuHeaderConstants.h"

@interface MenuHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIButton *buttonNear;
@property (weak, nonatomic) IBOutlet UIButton *buttonTracking;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UIButton *buttonMore;
- (IBAction)tappedButtonMenu:(id)sender;

@end

@implementation MenuHeaderView

- (void)awakeFromNib {

    _labelHeader.font = MENUHEADER_LABEL_HEADER_FONT;
    _labelHeader.text = NSLocalizedLanguage(@"MENUHEADER_LABEL_HEADER_TEXT");
    _labelHeader.textColor = MENUHEADER_LABEL_HEADER_COLOR;

    _labelCount.font = MENUHEADER_LABEL_TEXT_FONT;
    _labelCount.textColor = MENUHEADER_LABEL_COUNT_COLOR;
    _labelCount.text = @"";
    
    _buttonNear.tag = MenuHeaderNear;
    _buttonTracking.tag = MenuHeaderTrack;
    _buttonSearch.tag = MenuHeaderSearch;
    _buttonMore.tag = MenuHeaderMore;

}

- (void)setTitleFromCount:(NSInteger)count title:(NSString*)title {
    NSMutableAttributedString *titleCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li ", (long)count] attributes:@{NSFontAttributeName:MENUHEADER_LABEL_NUMBER_FONT, NSForegroundColorAttributeName:MENUHEADER_LABEL_COUNT_COLOR}];
    
    [titleCount appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:MENUHEADER_LABEL_TEXT_FONT, NSForegroundColorAttributeName:MENUHEADER_LABEL_COUNT_COLOR}]];
    
    _labelCount.attributedText = titleCount;
    
}

- (IBAction)tappedButtonMenu:(id)sender {
    UIButton *button = sender;
    [self.menuHeaderDelegate tappedMenu:(MenuHeaderItem)button.tag forView:sender];
}

@end

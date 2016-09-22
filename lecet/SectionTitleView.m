//
//  SectionTitleView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SectionTitleView.h"

#define SECTION_TITLE_TEXT_FONT                 fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define SECTION_TITLE_TEXT_COLOR                RGB(34, 34, 34)
#define SECTION_TITLE_LINE_COLOR                RGB(8, 73, 124)

@interface SectionTitleView()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation SectionTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    _labelTitle.font = SECTION_TITLE_TEXT_FONT;
    _labelTitle.textColor = SECTION_TITLE_TEXT_COLOR;
    _lineView.backgroundColor = SECTION_TITLE_LINE_COLOR;
}

- (void)setTitle:(NSString*)title {
    _labelTitle.text = title;
}

@end

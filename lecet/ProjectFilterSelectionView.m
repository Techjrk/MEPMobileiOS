//
//  ProjectFilterSelectionView.m
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterSelectionView.h"

#define PROJECTFILTER_SELECT_LABEL_FONT                        fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define PROJECTFILTER_SELECT_LABEL_FONT_COLOR                  RGB(34, 34, 34)

@interface ProjectFilterSelectionView ()
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation ProjectFilterSelectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    _labelTitle.font = PROJECTFILTER_SELECT_LABEL_FONT;
    _labelTitle.textColor = PROJECTFILTER_SELECT_LABEL_FONT_COLOR;
    
}

- (void)setLabelTitleText:(NSString *)text {
    _labelTitle.text = text;
}

- (void)setCheckButtonSelected:(BOOL)selected {
    [_checkButton setSelected:selected];
}

- (void)setButtonTag:(int)tag {
    [_checkButton setTag:tag];
}
- (IBAction)tappedCheckButton:(id)sender {
    UIButton *button = sender;
    [_projectFilterSelectionViewDelegate tappedCheckButtonAtTag:(int)button.tag];
}

@end

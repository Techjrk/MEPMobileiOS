//
//  ProjectFilterCollapsibleView.m
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterCollapsibleView.h"

#define LABEL_FONT                        fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_FONT_COLOR                  RGB(34, 34, 34)
@interface ProjectFilterCollapsibleView ()
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

@end

@implementation ProjectFilterCollapsibleView

- (void)awakeFromNib {
    _labelTitle.font = LABEL_FONT;
    _labelTitle.textColor = LABEL_FONT_COLOR;
        
}

- (void)setLabelTitleText:(NSString *)text {
    _labelTitle.text = text;
}

- (void)setButtonTag:(int)tag {
    [_selectionButton setTag:tag];
    [_dropDownButton setTag:tag];
}

- (void)setSelectionButtonSelected:(BOOL)selected {
    [_selectionButton setSelected:selected];
}

- (void)setDropDonwSelected:(BOOL)selected {
    [_dropDownButton setSelected:selected];
}


- (IBAction)tappedSelecTionButton:(id)sender {
    UIButton *button = sender;
    [_projectFilterCollapsibleViewDelegate tappedSelectionButton:(int)button.tag];
    
}
- (IBAction)tappedDropDownButton:(id)sender {
    UIButton *button = sender;
    [_projectFilterCollapsibleViewDelegate tappedDropDownButton:(int)button.tag];
    
}

@end

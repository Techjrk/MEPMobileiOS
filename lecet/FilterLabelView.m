//
//  FilterLabelView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "FilterLabelView.h"

#import "CustomTitleLabel.h"

#define LABEL_FONT                        fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_COLOR                       RGB(34, 34, 34)

@interface FilterLabelView()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet CustomTitleLabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;
- (IBAction)tappedButton:(id)sender;
@end

@implementation FilterLabelView

- (void)awakeFromNib {
    [super awakeFromNib];

    _lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    _labelValue.font = LABEL_FONT;
    _labelValue.textColor = [LABEL_COLOR colorWithAlphaComponent:0.5];
    
    
}

- (void)setTitle:(NSString *)title {
    _labelTitle.text = title;
}

- (void)setValue:(NSString *)value {
    _labelValue.text = value;
}

- (IBAction)tappedButton:(id)sender {
}

@end

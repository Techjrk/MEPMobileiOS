//
//  FilterEntryCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 04/08/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "FilterEntryCollectionViewCell.h"

#define BG_COLOR        RGB(238,238,238)
#define BORDER_COLOR    RGB(224,224,224)


@interface FilterEntryCollectionViewCell ()


@end
@implementation FilterEntryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:BG_COLOR];
    [self.layer setCornerRadius:5.0f];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth=1.0f;
    self.layer.borderColor= BORDER_COLOR.CGColor;

}

- (void)setLabelAttributedText:(id)attriText {
    _label.attributedText = attriText;
}

@end

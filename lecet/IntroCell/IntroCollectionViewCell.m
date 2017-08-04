//
//  IntroCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 04/08/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "IntroCollectionViewCell.h"

#define FONT_CONTENT                       fontNameWithSize(FONT_NAME_LATO_BOLD, 11)
#define COLOR_FONT_CONTENT                 RGB(255, 255, 255)

@implementation IntroCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellContentLabel.font = FONT_CONTENT;
    self.cellContentLabel.textColor = COLOR_FONT_CONTENT;
    self.backgroundColor = [UIColor clearColor];
}

@end

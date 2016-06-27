//
//  CustomTitleLabel.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomTitleLabel.h"

#define LABEL_FONT                  fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define LABEL_COLOR                 RGB(8, 73, 124)


@implementation CustomTitleLabel

- (void)layoutSubviews {
    self.font = LABEL_FONT;
    self.textColor = LABEL_COLOR;
}

@end

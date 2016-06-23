//
//  SearchSectionCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchSectionCollectionViewCell.h"

@interface SearchSectionCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@end

#define HEADER_FONT                 fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define HEADER_COLOR                RGB(8, 73, 124)


@implementation SearchSectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _labelTitle.font = HEADER_FONT;
    _labelTitle.textColor = HEADER_COLOR;
}

- (void)setTitle:(NSString *)title {
    
    _labelTitle.text = title;
}

@end

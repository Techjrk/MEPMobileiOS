//
//  RecentSearchItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "RecentSearchItemCollectionViewCell.h"

#define TITLE_FONT                  fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)
#define TITLE_COLOR                 RGB(16, 16, 15)

@interface RecentSearchItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@end

@implementation RecentSearchItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelTitle.font = TITLE_FONT;
    _labelTitle.textColor = TITLE_COLOR;
}

@end

//
//  SectionHeaderCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SectionHeaderCollectionViewCell.h"
#import "projectSortConstant.h"

@interface SectionHeaderCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SectionHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_label setFont:PROJECTSORT_SORTTITLE_LABEL_FONT];
    [_label setTextColor:PROJECTSORT_SORTTITLE_LABEL_FONT_COLOR];
    self.backgroundColor = PROJECTSORT_TITLEVIEW_BG_COLOR;
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
}
@end

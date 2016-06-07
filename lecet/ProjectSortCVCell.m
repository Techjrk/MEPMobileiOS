//
//  ProjectSortCVCell.m
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectSortCVCell.h"
#import "projectSortConstant.h"

@interface ProjectSortCVCell ()

@end

@implementation ProjectSortCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:[UIColor whiteColor]];
    [_labelTitle setFont:PROJECTSORT_CELL_LABEL_FONT];
    [_labelTitle setTextColor:PROJECTSORT_CELL_LABEL_FONT_COLOR];
    
}

@end

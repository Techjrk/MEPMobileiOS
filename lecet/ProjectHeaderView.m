//
//  ProjectHeaderView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/12/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectHeaderView.h"

#import "projectHeaderConstants.h"

@interface ProjectHeaderView()
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@end

@implementation ProjectHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.view.backgroundColor = PROJECT_HEADER_BG_COLOR;
    _viewInfo.backgroundColor = PROJECT_HEADER_INFO_BG_COLOR;
    
    _labelTitle.font = PROJECT_HEADER_TITLE_TEXT_FONT;
    _labelTitle.textColor = PROJECT_HEADER_TITLE_TEXT_COLOR;
    _labelTitle.text = @"Metro Youth Service Center (Improvements)";
}

@end

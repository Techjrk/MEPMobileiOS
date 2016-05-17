//
//  AssociatedProjectsView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "AssociatedProjectsView.h"

#import "SectionTitleView.h"

@interface AssociatedProjectsView()
@property (weak, nonatomic) IBOutlet SectionTitleView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@end

@implementation AssociatedProjectsView

- (void)awakeFromNib {
    [_titleView setTitle:NSLocalizedLanguage(@"ASSOCIATED_PROJECTS_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;

}

@end

//
//  ProjectTrackItemView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTrackItemView.h"
@interface ProjectTrackItemView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSpaceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constaintContainerHeight;
@end

@implementation ProjectTrackItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _constraintSpaceTop.constant = kDeviceHeight * 0.02;
    _constaintContainerHeight.constant = kDeviceHeight * 0.15;
}

@end

//
//  ProjectTrackItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTrackItemCollectionViewCell.h"

@interface ProjectTrackItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet ProjectTrackItemView *item;
@end

@implementation ProjectTrackItemCollectionViewCell
@synthesize projectTrackItemViewDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = kDeviceWidth * 0.015;
    self.layer.masksToBounds = YES;
    _item.projectTrackItemViewDelegate = self;

}

- (void)setInfo:(id)info {
    [_item setInfo:info];
}

- (void)tappedButtonExpand:(id)object view:(id)view {
    [self.projectTrackItemViewDelegate tappedButtonExpand:object view:self];
}
@end

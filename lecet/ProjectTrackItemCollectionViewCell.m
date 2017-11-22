//
//  ProjectTrackItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTrackItemCollectionViewCell.h"

#import "ActionView.h"

@interface ProjectTrackItemCollectionViewCell()<ActionViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintExpand;
@property (weak, nonatomic) IBOutlet ProjectTrackItemView *item;
@property (strong, nonatomic)id<ActionViewDelegate> cellDelegate;
@end

@implementation ProjectTrackItemCollectionViewCell
@synthesize projectTrackItemViewDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.item.layer.cornerRadius = kDeviceWidth * 0.01;
    self.item.layer.masksToBounds = YES;
    _item.projectTrackItemViewDelegate = self;

}

- (void)setInfo:(id)info {
    self.actionView.constraintHorizontal = self.constraintExpand;
    [_item setInfo:info];
}

- (void)tappedButtonExpand:(id)object view:(id)view {
    [self.projectTrackItemViewDelegate tappedButtonExpand:object view:self];
}

#pragma mark - Delegate

- (void)setActionViewDelegate:(id<ActionViewDelegate>)actionViewDelegate {
    self.actionView.actionViewDelegate = self;
    self.cellDelegate = actionViewDelegate;
}

#pragma mark - ActionViewDelegate

- (void)didSelectItem:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didSelectItem:self];
    }
}

- (void)didTrackItem:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didTrackItem:self];
    }
}

- (void)didShareItem:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didShareItem:self];
    }
}

- (void)didHideItem:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didHideItem:self];
    }
}

- (void)didExpand:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didExpand:self];
    }
}

- (void)undoHide:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate undoHide:self];
    }
}

@end

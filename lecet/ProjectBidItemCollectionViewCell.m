//
//  ProjectBidItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBidItemCollectionViewCell.h"

#import "ProjectBidView.h"

@interface ProjectBidItemCollectionViewCell()<ActionViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintExpand;
@property (strong, nonatomic)id<ActionViewDelegate> cellDelegate;

@property (weak, nonatomic) IBOutlet ProjectBidView *item;
@end

@implementation ProjectBidItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(id)info {
    self.actionView.constraintHorizontal = self.contraintExpand;
    self.actionView.viewContainer = self.item;
    [_item setInfo:info];
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

//
//  AssociatedBidCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "AssociatedBidCollectionViewCell.h"

#import "AssociatedBidView.h"

@interface AssociatedBidCollectionViewCell()
@property (weak, nonatomic) IBOutlet AssociatedBidView *item;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintExpand;
@property (weak, nonatomic) IBOutlet ActionView *actionView;
@end

@implementation AssociatedBidCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setInfo:(id)info {
    [_item setInfo:info];
}

#pragma mark - Delegate

- (void)setActionViewDelegate:(id<ActionViewDelegate>)actionViewDelegate {
    self.actionView.actionViewDelegate = actionViewDelegate;
}

@end

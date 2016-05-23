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
@end

@implementation AssociatedBidCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setInfo:(id)info {
    [_item setInfo:info];
}
@end

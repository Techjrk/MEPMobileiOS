//
//  TrackingListCellCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "TrackingListCellCollectionViewCell.h"

#import "TrackingListView.h"

@interface TrackingListCellCollectionViewCell()
@property (weak, nonatomic) IBOutlet TrackingListView *listItem;
@end

@implementation TrackingListCellCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setInfo:(id)info {
    [_listItem setInfo:info];
}

@end

//
//  TrackingListCellCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "TrackingListCellCollectionViewCell.h"

@interface TrackingListCellCollectionViewCell()
@property (weak, nonatomic) IBOutlet TrackingListView *listItem;
@end

@implementation TrackingListCellCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setInfo:(id)info withTitle:(NSString *)title{
    _listItem.headerTitle = title;
    [_listItem setInfo:info];
}

- (CGFloat)cellHeight {
    return [_listItem viewHeight];
}

- (id)cargo {
    return [NSNumber numberWithBool:[_listItem isExpanded]];
}

- (void)setTrackingListViewDelegate:(id<TrackingListViewDelegate>)trackingListViewDelegate {
    _listItem.trackingListViewDelegate = trackingListViewDelegate;
}

- (void)setHeaderDisabled:(BOOL)headerDisabled {
    _listItem.isHeaderDisabled = headerDisabled;
}
@end

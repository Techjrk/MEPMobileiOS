//
//  TrackingItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "TrackingItemCollectionViewCell.h"

#import "trackingItemCollectionConstants.h"

@interface TrackingItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@end

@implementation TrackingItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    _lineView.backgroundColor = TRACKING_ITEM_LINE_COLOR;
}

- (void)setInfo:(id)info {
    
}
@end

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
    
    _labelTitle.font = TRACKING_ITEM_TITLE_FONT;
    _labelTitle.textColor = TRACKING_ITEM_TITLE_COLOR;
    
    _labelCount.font = TRACKING_ITEM_COUNT_FONT;
    _labelCount.textColor = TRACKING_ITEM_COUNT_COLOR;
}

- (void)setInfo:(id)info {
    _labelTitle.text = info[@"name"];
    NSArray *projects = info[@"projectIds"];
    
    if (projects == nil) {
        projects = info[@"companyIds"];
    }
    _labelCount.text = [NSString stringWithFormat:NSLocalizedLanguage(@"TRACK_ITEM_COUNT"),(long)projects.count];
}
@end

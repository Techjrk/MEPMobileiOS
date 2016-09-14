//
//  TrackingItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "TrackingItemCollectionViewCell.h"

#define TRACKING_ITEM_TITLE_FONT                    fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define TRACKING_ITEM_TITLE_COLOR                   RGB(72, 72, 72)

#define TRACKING_ITEM_COUNT_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define TRACKING_ITEM_COUNT_COLOR                   RGB(136, 136, 136)

#define TRACKING_ITEM_LINE_COLOR                    RGB(193, 193, 193)

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
    NSArray *projects = info[@"projects"];
    
    if (projects == nil) {
        projects = info[@"companies"];
        _labelCount.text = [NSString stringWithFormat:NSLocalizedLanguage(projects.count<=1?@"TRACK_ITEM_COMPANY_COUNT_SINGLE":@"TRACK_ITEM_COMPANY_COUNT_PLURAL"),(long)projects.count];
    } else {
        _labelCount.text = [NSString stringWithFormat:NSLocalizedLanguage(projects.count<=1?@"TRACK_ITEM_COUNT_SINGLE":@"TRACK_ITEM_COUNT_PLURAL"),(long)projects.count];
    }
}
@end

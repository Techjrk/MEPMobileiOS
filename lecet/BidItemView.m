//
//  BidItemView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidItemView.h"

#import "bidItemViewConstants.h"

@interface BidItemView()
@property (weak, nonatomic) IBOutlet UIView *groupDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelBidName;
@property (weak, nonatomic) IBOutlet UILabel *labelBidService;
@property (weak, nonatomic) IBOutlet UILabel *labelBidType;
@property (weak, nonatomic) IBOutlet UILabel *labelBidLocation;
@end

@implementation BidItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;

    self.view.backgroundColor = BID_ITEMVIEW_BG_COLOR;
    _groupDate.backgroundColor = BID_ITEMVIEW_GROUP_DATE_BG_COLOR;
    
    _labelDate.text = @"April 15";
    _labelDate.textColor = BID_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelDate.font = BID_ITEMVIEW_LABEL_DATE_FONT;
    
    _labelAmount.text = @"$1,082,100";
    _labelAmount.textColor = BID_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelAmount.font = BID_ITEMVIEW_LABEL_AMOUNT_FONT;

    _labelBidName.text = @"Northern Contracting Services";
    _labelBidName.textColor = BID_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelBidName.font = BID_ITEMVIEW_LABEL_BIDNAME_FONT;

    _labelBidService.text = @"Metro Youth Services";
    _labelBidService.textColor = BID_ITEMVIEW_LABEL_BIDSERVICE_COLOR;
    _labelBidService.font = BID_ITEMVIEW_LABEL_BIDSERVICE_FONT;
    
    _labelBidLocation.text = @"Boston, MA";
    _labelBidLocation.textColor = BID_ITEMVIEW_LABEL_BIDINFO_COLOR;
    _labelBidLocation.font = BID_ITEMVIEW_LABEL_BIDINFO_FONT;

    _labelBidType.text = @"Recreational, Alternative Living";
    _labelBidType.textColor = BID_ITEMVIEW_LABEL_BIDINFO_COLOR;
    _labelBidType.font = BID_ITEMVIEW_LABEL_BIDINFO_FONT;

}
@end

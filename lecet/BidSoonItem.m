//
//  BidSoonItem.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidSoonItem.h"

#import "bidSoonItemConstants.h"

@interface BidSoonItem()
@property (weak, nonatomic) IBOutlet UIView *groupDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelBidName;
@property (weak, nonatomic) IBOutlet UILabel *labelBidService;
@property (weak, nonatomic) IBOutlet UILabel *labelBidType;
@property (weak, nonatomic) IBOutlet UILabel *labelBidLocation;
@end

@implementation BidSoonItem

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    self.view.backgroundColor = BID_SOON_ITEMVIEW_BG_COLOR;
    _groupDate.backgroundColor = BID_SOON_ITEMVIEW_GROUP_DATE_BG_COLOR;
    
    _labelDate.text = @"April 1";
    _labelDate.textColor = BID_SOON_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelDate.font = BID_SOON_ITEMVIEW_LABEL_DATE_FONT;
    
    _labelAmount.text = @"11:30 AM";
    _labelAmount.textColor = BID_SOON_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelAmount.font = BID_SOON_ITEMVIEW_LABEL_TIME_FONT;
    
    _labelBidName.text = @"Northern Contracting Services";
    _labelBidName.textColor = BID_SOON_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelBidName.font = BID_SOON_ITEMVIEW_LABEL_BIDNAME_FONT;
    
    _labelBidService.text = @"Metro Youth Services";
    _labelBidService.textColor = BID_SOON_ITEMVIEW_LABEL_BIDSERVICE_COLOR;
    _labelBidService.font = BID_SOON_ITEMVIEW_LABEL_BIDSERVICE_FONT;
    
    _labelBidLocation.text = @"Boston, MA";
    _labelBidLocation.textColor = BID_SOON_ITEMVIEW_LABEL_BIDINFO_COLOR;
    _labelBidLocation.font = BID_SOON_ITEMVIEW_LABEL_BIDINFO_FONT;
    
    _labelBidType.text = @"Recreational, Alternative Living";
    _labelBidType.textColor = BID_SOON_ITEMVIEW_LABEL_BIDINFO_COLOR;
    _labelBidType.font = BID_SOON_ITEMVIEW_LABEL_BIDINFO_FONT;
    
}

@end

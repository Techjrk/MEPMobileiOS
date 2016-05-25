//
//  BitItemRecentCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BitItemRecentCollectionViewCell.h"
#import "BidItemRecent.h"
@interface BitItemRecentCollectionViewCell()
@property (weak, nonatomic) IBOutlet BidItemRecent *bidItem;

@end

@implementation BitItemRecentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.masksToBounds = NO;
}

- (void)setInfo:(id)info {
    [_bidItem setInfo:info];
}

- (void)setBitItemRecentDelegate:(id<BitItemRecentDelegate>)bitItemRecentDelegate {
    _bidItem.bitItemRecentDelegate = bitItemRecentDelegate;
}
@end

//
//  BidSoonItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/7/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidSoonItemCollectionViewCell.h"

#import "BidSoonItem.h"

@interface BidSoonItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet BidSoonItem *bidItemView;
@end

@implementation BidSoonItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.masksToBounds = NO;
}

@end

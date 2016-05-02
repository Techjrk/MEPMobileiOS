//
//  BidItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidItemCollectionViewCell.h"

#import "BidItemView.h"

@interface BidItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet BidItemView *bidItemVIew;

@end

@implementation BidItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.masksToBounds = NO;

}

@end

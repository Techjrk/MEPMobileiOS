//
//  ProjectBidItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBidItemCollectionViewCell.h"

#import "ProjectBidView.h"

@interface ProjectBidItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet ProjectBidView *item;
@end

@implementation ProjectBidItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(id)info {
    [_item setInfo:info];
}
@end

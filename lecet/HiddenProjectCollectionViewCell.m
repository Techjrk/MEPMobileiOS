//
//  HiddenProjectCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "HiddenProjectCollectionViewCell.h"

#import "HiddenProjectView.h"

@interface HiddenProjectCollectionViewCell()
@property (weak, nonatomic) IBOutlet HiddenProjectView *hiddenItem;
@end
@implementation HiddenProjectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setInfo:(id)info {
    [_hiddenItem setInfo:info];
}

@end

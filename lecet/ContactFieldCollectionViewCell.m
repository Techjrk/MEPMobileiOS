//
//  ContactFieldCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactFieldCollectionViewCell.h"

#import "ContactFieldView.h"

@interface ContactFieldCollectionViewCell()
@property (weak, nonatomic) IBOutlet ContactFieldView *fieldItem;
@end
@implementation ContactFieldCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(id)info {
    [_fieldItem setInfo:info];
}
@end

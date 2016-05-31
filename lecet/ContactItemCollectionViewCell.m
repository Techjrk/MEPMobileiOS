//
//  ContactItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactItemCollectionViewCell.h"
#import "ContactsView.h"

@interface ContactItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet ContactsView *contactView;
@end
@implementation ContactItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItemInfo:(id)info {
    [_contactView setInfo:info];
}

@end

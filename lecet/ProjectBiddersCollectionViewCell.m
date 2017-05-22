//
//  ProjectBiddersCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBiddersCollectionViewCell.h"

#import "CustomEntryField.h"

@interface ProjectBiddersCollectionViewCell()
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldItem;
@end

@implementation ProjectBiddersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(NSString*)title line1:(NSString*)line1 line2:(NSString*)line2 {
    [_fieldItem setTitle:title line1Text:line1 line2Text:line2];
}
@end

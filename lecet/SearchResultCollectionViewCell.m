//
//  SearchResultCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchResultCollectionViewCell.h"

#import "SearchResultView.h"

@interface SearchResultCollectionViewCell()
@property (weak, nonatomic) IBOutlet SearchResultView *cellItem;
@end

@implementation SearchResultCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCollectionItems:(NSMutableDictionary *)collectionItems tab:(NSInteger)tab {
 
    [_cellItem setCollectionItems:collectionItems tab:tab];
    
}

@end

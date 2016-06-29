//
//  SearchResultCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchResultCollectionViewCell.h"

@interface SearchResultCollectionViewCell()
@property (weak, nonatomic) IBOutlet SearchResultView *cellItem;
@end

@implementation SearchResultCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCollectionItems:(NSMutableDictionary *)collectionItems tab:(NSNumber*)tab {
 
    [_cellItem setCollectionItems:collectionItems tab:tab];
    
}

- (void)reloadData {
 
    [_cellItem reloadData];
    
}

- (void)setNavigationController:(UINavigationController *)navigationController {
    _cellItem.navigationController = navigationController;
}

- (void)setSearchResultViewDelegate:(id<SearchResultViewDelegate>)searchResultViewDelegate {
    _cellItem.searchResultViewDelegate = searchResultViewDelegate;
}
@end

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

- (void)setCollectionItems:(NSMutableDictionary *)collectionItems tab:(NSNumber*)tab fromSavedSearch:(BOOL)fromSavedSearch {
 
    [_cellItem setCollectionItems:collectionItems tab:tab fromSavedSearch:(BOOL)fromSavedSearch];
    
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

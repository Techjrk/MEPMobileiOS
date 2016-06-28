//
//  SearchResultCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) UINavigationController *navigationController;
- (void)setCollectionItems:(NSMutableDictionary*)collectionItems tab:(NSInteger)tab;
- (void)reloadData;
@end

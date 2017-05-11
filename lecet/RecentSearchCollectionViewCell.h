//
//  RecentSearchCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecentSearchCollectionViewCellDelegate <NSObject>
@optional
- (void)tappedRecentSearchView;
- (void)endRequestRecentSearchView;

@end

@interface RecentSearchCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<RecentSearchCollectionViewCellDelegate> recentSearchCollectionViewCellDelegate;
- (void)setInfo:(id)info;
@end

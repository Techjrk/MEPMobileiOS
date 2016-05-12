//
//  BidSoonItemCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/7/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BidSoonCollectionItemDelegate <NSObject>
- (void)tappedBidSoonCollectionItem:(id)object;
@end

@interface BidSoonItemCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<BidSoonCollectionItemDelegate>bidSoonCollectionItemDelegate;
- (void)setItemInfo:(id)info;
@end

//
//  BidItemCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BidCollectionItemDelegate <NSObject>
- (void)tappedBidCollectionItem:(id)object;
@end

@interface BidItemCollectionViewCell : UICollectionViewCell
@property (nonatomic) id<BidCollectionItemDelegate>bidCollectionitemDelegate;
- (void)setItemInfo:(id)info;
@end

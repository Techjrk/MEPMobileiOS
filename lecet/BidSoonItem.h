//
//  BidSoonItem.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#import "BidSoonItemCollectionViewCell.h"

@interface BidSoonItem : BaseViewClass
@property (strong, nonatomic) id<BidSoonCollectionItemDelegate>bidSoonCollectionItemDelegate;
- (void)setItemInfo:(id)info;
- (NSNumber*)getRecordId;
@end

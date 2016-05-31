//
//  BidItemView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#import "BidItemCollectionViewCell.h"

@interface BidItemView : BaseViewClass
@property (strong, nonatomic) id<BidCollectionItemDelegate>bidItemDelegate;
- (NSNumber*)getRecordId;
- (NSNumber *)getProjectRecordId;
- (void)setInfo:(id)info;
@end

//
//  BidItemRecent.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"
#import "BitItemRecentCollectionViewCell.h"

@interface BidItemRecent : BaseViewClass
@property (strong, nonatomic) id<BitItemRecentDelegate>bitItemRecentDelegate;
- (void)setInfo:(id)info;
- (NSNumber*)getRecordId;
@end

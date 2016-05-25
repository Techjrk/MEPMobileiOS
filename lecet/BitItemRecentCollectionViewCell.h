//
//  BitItemRecentCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BitItemRecentDelegate <NSObject>
- (void)tappedBitItemRecent:(id)object;
@end

@interface BitItemRecentCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<BitItemRecentDelegate>bitItemRecentDelegate;
- (void)setInfo:(id)info;
@end

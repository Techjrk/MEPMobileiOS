//
//  TrackingListCellCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrackingListView.h"

@interface TrackingListCellCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id<TrackingListViewDelegate>trackingListViewDelegate;
@property (nonatomic) BOOL headerDisabled;
- (CGFloat)cellHeight;
- (void)setInfo:(id)info withTitle:(NSString*)title;
- (id) cargo;
- (void)expanded:(BOOL)expanded;
@end

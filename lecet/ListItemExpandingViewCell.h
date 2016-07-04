//
//  ListItemExpandingViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListItemCollectionViewCell.h"

@protocol ListItemExpandingViewCellDelegate <NSObject>
- (void)listViewItemWillExpand:(ListItemCollectionViewCell*)listViewItem;
- (void)listViewItemDidExpand:(ListItemCollectionViewCell*)listViewItem;
- (NSArray*)listViewSubItems:(ListItemCollectionViewCell*)listViewItem;
@end

@interface ListItemExpandingViewCell : ListItemCollectionViewCell
@property (weak, nonatomic) id<ListItemExpandingViewCellDelegate>listItemExpandingViewCellDelegate;
@property (weak, nonatomic) id<ListItemCollectionViewCellDelegate>listItemCollectionViewCellDelegate;
+ (CGFloat)itemHeight;
- (void)reloadData;
@end

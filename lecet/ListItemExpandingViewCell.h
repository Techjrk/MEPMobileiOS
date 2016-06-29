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
@end

@interface ListItemExpandingViewCell : ListItemCollectionViewCell

@end

//
//  ListItemCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATUS_EXPAND                       @"EXPAND_STATUS"
#define STATUS_CHECK                        @"STATUS_CHECK"
#define LIST_VIEW_SUBITEMS                  @"LIST_VIEW_SUBITEMS"
#define LIST_VIEW_NAME                      @"LIST_VIEW_NAME"
#define LIST_VIEW_VALUE                     @"LIST_VIEW_VALUE"
#define LIST_VIEW_MODEL                     @"LIST_VIEW_MODEL"

@protocol ListItemCollectionViewCellDelegate <NSObject>
- (void)didChangeListViewItemSize;
@end

@interface ListItemCollectionViewCell : UICollectionViewCell{
    NSMutableDictionary *localItem;
}
@property (weak, nonatomic) id<ListItemCollectionViewCellDelegate>listItemCollectionViewCellDelegate;
@property (weak, nonatomic) NSNumber *level;
@property (weak, nonatomic) NSIndexPath *index;
+ (CGFloat)itemHeight;
+ (NSMutableDictionary*)createItem:(NSString*)name value:(NSString*)value model:(NSString*)model;
- (void)setItem:(NSMutableDictionary*)item;
- (id)parentListView;
@end

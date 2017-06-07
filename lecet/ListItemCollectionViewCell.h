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

@interface ListViewItemDictionary : NSMutableDictionary {
    NSMutableDictionary *proxy;
}
@property (weak, nonatomic) id parent;
- (void)clearSubItems;
- (void)filterSubItems:(NSString*)filter;
- (NSInteger)subItemCount;
@end

@interface ListViewItemArray : NSMutableArray {
    NSMutableArray *proxy;
    NSMutableArray *filteredProxy;
    BOOL isFiltered;
}
@property (weak, nonatomic) id parent;
- (void)addObject:(id)anObject;
- (void)filterSubItems:(NSString*)filter;
@end

@protocol ListItemCollectionViewCellDelegate <NSObject>
- (void)didChangeListViewItemSize;
- (BOOL)singleSelection;
@end

@interface ListItemCollectionViewCell : UICollectionViewCell{
    ListViewItemDictionary *localItem;
}
@property (weak, nonatomic) id<ListItemCollectionViewCellDelegate>listItemCollectionViewCellDelegate;
@property (weak, nonatomic) NSNumber *level;
@property (weak, nonatomic) NSIndexPath *index;
+ (CGFloat)itemHeight;
+ (ListViewItemDictionary*)createItem:(NSString*)name value:(NSString*)value model:(NSString*)model;
- (void)setItem:(ListViewItemDictionary*)item;
- (id)parentListView;
- (ListViewItemDictionary *)localItem;
@end

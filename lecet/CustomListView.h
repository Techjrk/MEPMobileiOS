//
//  CustomListView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"
#import "ListItemCollectionViewCell.h"

@class CustomListView;

@protocol CustomListViewDelegate <NSObject>
- (void)listViewRegisterNib:(CustomListView*)customListView;
- (NSInteger)listViewItemCount;
- (void)listViewItemDidSelected:(ListItemCollectionViewCell*)listViewItem;
- (ListItemCollectionViewCell*)listViewItemPrepareForUse:(NSIndexPath*)indexPath listView:(CustomListView*)listView;
- (CGSize)listViewItemSize:(NSIndexPath*)indexPath;
@end

@interface CustomListView : BaseViewClass
@property (weak, nonatomic) id<CustomListViewDelegate>customListViewDelegate;
@property (weak ,nonatomic) UINavigationController *navigationController;
- (void)registerListItemNib:(Class)objectClass;
- (ListItemCollectionViewCell*)dequeListItemCollectionViewCell:(NSString*)identifier indexPath:(NSIndexPath*)indexPath;
- (void)reloadData;
- (void)reloadIndexPaths:(NSArray*)indexPaths;
- (NSArray*)visibleIndexPaths;
- (void)setListViewScrollable:(BOOL)scrollable;
@end

//
//  FilterViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 7/1/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "FilterViewController.h"
#import "CustomListView.h"
#import "ListItemCollectionViewCell.h"
#import "ListItemExpandingViewCell.h"

@interface FilterViewController ()<CustomListViewDelegate, ListItemExpandingViewCellDelegate, ListItemCollectionViewCellDelegate>{
    NSMutableArray *localListViewItems;
}
@property (weak, nonatomic) IBOutlet UITextField *labelSearch;
@property (weak, nonatomic) IBOutlet CustomListView *listView;
- (IBAction)tappedBackButton:(id)sender;
@end

@implementation FilterViewController
@synthesize listViewItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _labelSearch.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _labelSearch.layer.cornerRadius = kDeviceWidth * 0.0106;
    _labelSearch.layer.masksToBounds = YES;

    localListViewItems = [NSMutableArray new];
    
    for (NSDictionary *item in self.listViewItems) {
        NSMutableDictionary *mutableItem = [item mutableCopy];
        mutableItem[STATUS_EXPAND] = [NSNumber numberWithBool:NO];
        mutableItem[STATUS_CHECK] = [NSNumber numberWithBool:NO];
        
        [localListViewItems addObject:mutableItem];
        
    }
    _listView.customListViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (IBAction)tappedBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Custom List View Delegate

- (void)listViewRegisterNib:(CustomListView *)customListView {
    [customListView registerListItemNib:[ListItemExpandingViewCell class]];
}

- (void)listViewItemDidSelected:(ListItemCollectionViewCell *)listViewItem {
    
}

- (NSInteger)listViewItemCount {

    return localListViewItems.count;
}

- (ListItemCollectionViewCell *)listViewItemPrepareForUse:(NSIndexPath *)indexPath listView:(CustomListView *)listView{
    
    ListItemExpandingViewCell *cell = (ListItemExpandingViewCell*)[listView dequeListItemCollectionViewCell:[[ListItemExpandingViewCell class] description] indexPath:indexPath];
    
    cell.level = [NSNumber numberWithInt:0];
    cell.index = indexPath;
    [cell setItem:localListViewItems[indexPath.row]];
    cell.listItemCollectionViewCellDelegate = self;
    cell.listItemExpandingViewCellDelegate = self;
    [cell reloadData];
    return cell;
}

- (CGSize)listViewItemSize:(NSIndexPath *)indexPath {
    
    CGFloat itemHeight = [ListItemExpandingViewCell itemHeight];
    NSMutableDictionary *item = localListViewItems[indexPath.row];
    NSNumber *expand = item[STATUS_EXPAND];
    
    if (expand.boolValue) {
        
        NSArray *subItems = item[LIST_VIEW_SUBITEMS];
        itemHeight = itemHeight + [self currentHeight:subItems];
        
    }
    
    return CGSizeMake(_listView.frame.size.width, itemHeight);
}

- (CGFloat)currentHeight:(NSArray*)subItems {
    
    CGFloat totalHeight = 0;
    
    for (NSMutableDictionary *item in subItems) {
        NSNumber *expand = item[STATUS_EXPAND];
        CGFloat itemHeight = [ListItemExpandingViewCell itemHeight];
        if (expand.boolValue) {
            NSArray *items = item[LIST_VIEW_SUBITEMS];
            totalHeight = totalHeight + itemHeight +[self currentHeight:items];
        } else {
            totalHeight = totalHeight + itemHeight;
        }
    }
    
    return totalHeight;
}

#pragma mark - ListItemExpandingViewCellDelegate

- (void)listViewItemDidExpand:(ListItemCollectionViewCell *)listViewItem {
    
}

- (void)listViewItemWillExpand:(ListItemCollectionViewCell *)listViewItem {

    NSIndexPath *indexPath = listViewItem.index;
    NSMutableDictionary *item = localListViewItems[indexPath.row];
    NSNumber *expand = item[STATUS_EXPAND];
    
    item[STATUS_EXPAND] =  [NSNumber numberWithBool:!expand.boolValue];
    
    [self didChangeListViewItemSize];
}

- (NSArray *)listViewSubItems:(ListItemCollectionViewCell *)listViewItem {
    
    NSIndexPath *indexPath = listViewItem.index;
    NSMutableDictionary *item = localListViewItems[indexPath.row];
    NSArray *subItems = item[LIST_VIEW_SUBITEMS];
    
    return subItems;
}

- (void)didChangeListViewItemSize {
 
    [_listView reloadData];
    
}

@end

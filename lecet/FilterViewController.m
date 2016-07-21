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

#define SEACRCH_TEXTFIELD_TEXT_FONT                     fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)

#define SEACRCH_PLACEHOLDER_FONT                        fontNameWithSize(FONT_NAME_AWESOME, 14)
#define SEACRCH_PLACEHOLDER_COLOR                       RGB(255, 255, 255)
#define SEACRCH_PLACEHOLDER_TEXT                        [NSString stringWithFormat:@"%C", 0xf002]

#define BUTTON_FILTER_FONT                              fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 14)
#define BUTTON_FILTER_COLOR                             RGB(168, 195, 230)

@interface FilterViewController ()<CustomListViewDelegate, ListItemExpandingViewCellDelegate, ListItemCollectionViewCellDelegate>{
    ListViewItemArray *localListViewItems;
    ListViewItemArray *tempLocalListViewItems;
    NSMutableArray *searchResultSubCat;
}
@property (weak, nonatomic) IBOutlet UITextField *labelSearch;
@property (weak, nonatomic) IBOutlet UIButton *buttonApply;
@property (weak, nonatomic) IBOutlet CustomListView *listView;
@property (weak, nonatomic) IBOutlet UIView *viewbackground;
- (IBAction)tappedBackButton:(id)sender;
@end

@implementation FilterViewController
@synthesize listViewItems;
@synthesize searchTitle;
@synthesize singleSelect;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self enableTapGesture:YES];
    
    [_buttonApply setTitleColor:BUTTON_FILTER_COLOR forState:UIControlStateNormal];
    _buttonApply.titleLabel.font = BUTTON_FILTER_FONT;
    [_buttonApply setTitle:NSLocalizedLanguage(@"FILTER_VIEW_APPLY") forState:UIControlStateNormal];

    _viewbackground.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _viewbackground.layer.cornerRadius = kDeviceWidth * 0.0106;
    _viewbackground.layer.masksToBounds = YES;

    localListViewItems = [ListViewItemArray new];
    
    for (NSDictionary *item in self.listViewItems) {
        NSMutableDictionary *mutableItem = [item mutableCopy];
        mutableItem[STATUS_EXPAND] = [NSNumber numberWithBool:NO];
        mutableItem[STATUS_CHECK] = [NSNumber numberWithBool:NO];
        [localListViewItems addObject:mutableItem];
    }
    tempLocalListViewItems = localListViewItems;
    
    _listView.customListViewDelegate = self;
    _listView.singleSelection = self.singleSelect;
    
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:SEACRCH_PLACEHOLDER_TEXT attributes:@{NSFontAttributeName:SEACRCH_PLACEHOLDER_FONT, NSForegroundColorAttributeName:SEACRCH_PLACEHOLDER_COLOR}];
    
    [placeHolder appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@ %@",NSLocalizedLanguage(@"FILTER_VIEW_SEARCH_FOR"),self.searchTitle] attributes:@{NSFontAttributeName:SEACRCH_TEXTFIELD_TEXT_FONT, NSForegroundColorAttributeName:SEACRCH_PLACEHOLDER_COLOR}]];
    _labelSearch.attributedPlaceholder = placeHolder;
    _labelSearch.textColor = [UIColor whiteColor];
    _labelSearch.tintColor = [UIColor whiteColor];
    
    [_labelSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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

- (BOOL)singleSelection {
    
    if (self.singleSelect) {
        
        [self uncheckItem:localListViewItems];
        
        [_listView reloadData];
    }
    
    return self.singleSelect;
}

- (void)uncheckItem:(ListViewItemArray*)items {

    for (ListViewItemDictionary *item in items) {
        item[STATUS_CHECK] = [NSNumber numberWithBool:NO];
        
        ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
        
        if (subItems) {
            [self uncheckItem:subItems];
        }
    }
    
}



#pragma mark - Search Function

-(void)textFieldDidChange :(UITextField *)textField{
    searchResultSubCat = [NSMutableArray new];
    
    if (textField.text.length > 0) {
        [self searchItem:tempLocalListViewItems search:textField.text parentItem:nil];
        localListViewItems = (ListViewItemArray *)[self expandSearchResult:(ListViewItemArray *)[searchResultSubCat mutableCopy]];
    }
    
    if (textField.text.length == 0) {
        
        localListViewItems = tempLocalListViewItems;
        [self unexpand:localListViewItems];
    }
    
    [_listView reloadData];
}

- (void)searchItem:(id)items search:(NSString *)sText parentItem:(id)pitem {
    
    NSString *searchText = [NSString stringWithFormat:@"%@*",sText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.LIST_VIEW_NAME like[cd] %@", searchText];
    NSArray *filteredFirstLayer = [[items copy] filteredArrayUsingPredicate:resultPredicate];
    
    if (filteredFirstLayer.count > 0) {
        
        if (pitem != nil) {
            [searchResultSubCat addObject:pitem];
        } else {
            searchResultSubCat = [filteredFirstLayer mutableCopy];
        }
        
    } else {
        
    
        for (ListViewItemDictionary *item in items) {
            ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
            
            if (subItems) {
                [self searchItem:subItems search:sText parentItem:item];
            }
        }
        
    }

}

- (NSMutableArray *)expandSearchResult:(ListViewItemArray*)items {
    for (ListViewItemDictionary *item in items) {
        item[STATUS_EXPAND] = [NSNumber numberWithBool:YES];
        ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
        if (subItems) {
            [self expandSearchResult:subItems];
        }
        
    }
    
    return items;
}

- (void)unexpand:(ListViewItemArray*)items {
    for (ListViewItemDictionary *item in items) {
        item[STATUS_EXPAND] = [NSNumber numberWithBool:NO];
         ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
         
         if (subItems) {
         [self uncheckItem:subItems];
         }
         
    }
    
    
}

@end

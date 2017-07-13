//
//  FilterViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 7/1/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "FilterViewController.h"
#import "CustomListView.h"
#import "ListItemExpandingViewCell.h"

#define SEACRCH_TEXTFIELD_TEXT_FONT                     fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)

#define SEACRCH_PLACEHOLDER_FONT                        fontNameWithSize(FONT_NAME_AWESOME, 14)
#define SEACRCH_PLACEHOLDER_COLOR                       RGB(255, 255, 255)
#define SEACRCH_PLACEHOLDER_TEXT                        [NSString stringWithFormat:@"%C", 0xf002]

#define BUTTON_FILTER_FONT                              fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 14)
#define BUTTON_FILTER_COLOR                             RGB(168, 195, 230)

@interface FilterViewController ()<CustomListViewDelegate, ListItemExpandingViewCellDelegate, ListItemCollectionViewCellDelegate>{
    ListViewItemArray *localListViewItems;
    NSMutableArray *checkedItems;
    NSMutableArray *checkedTitles;
    NSMutableArray *checkedNodes;
    NSMutableArray *idSelection;
}
@property (weak, nonatomic) IBOutlet UITextField *labelSearch;
@property (weak, nonatomic) IBOutlet UIButton *buttonApply;
@property (weak, nonatomic) IBOutlet CustomListView *listView;
@property (weak, nonatomic) IBOutlet UIView *viewbackground;
- (IBAction)tappedBackButton:(id)sender;
- (IBAction)tappedButtonApply:(id)sender;
@end

@implementation FilterViewController
@synthesize listViewItems;
@synthesize searchTitle;
@synthesize singleSelect;
@synthesize fieldValue;
@synthesize filterViewControllerDelegate;
@synthesize parentOnly;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self enableTapGesture:YES];
    
    checkedItems = [NSMutableArray new];
    checkedTitles = [NSMutableArray new];
    checkedNodes = [NSMutableArray new];
    
    [_buttonApply setTitleColor:BUTTON_FILTER_COLOR forState:UIControlStateNormal];
    _buttonApply.titleLabel.font = BUTTON_FILTER_FONT;
    [_buttonApply setTitle:NSLocalizedLanguage(@"FILTER_VIEW_APPLY") forState:UIControlStateNormal];

    _viewbackground.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _viewbackground.layer.cornerRadius = kDeviceWidth * 0.0106;
    _viewbackground.layer.masksToBounds = YES;

    localListViewItems = [ListViewItemArray new];
    
    for (ListViewItemDictionary *item in self.listViewItems) {
        ListViewItemDictionary *mutableItem = item;
        
        [item filterSubItems:nil];
        
        mutableItem[STATUS_EXPAND] = [NSNumber numberWithBool:NO];

        [localListViewItems addObject:mutableItem];
    }
    
    
    
    [self prepareListItem:localListViewItems];
    
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
    [self revertItems:localListViewItems];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedButtonApply:(id)sender {
    if (idSelection) {
        [idSelection removeAllObjects];
    } else {
        idSelection = [NSMutableArray new];
    }
    
    [self getCheckItems:localListViewItems includeChild:NO];

    if (checkedItems.count>0) {
        if (self.filterViewControllerDelegate) {
            
            [self.filterViewControllerDelegate tappedFilterViewControllerApply:idSelection key:self.fieldValue titles:checkedTitles nodes:checkedNodes];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[DataManager sharedManager] promptMessage:@"Please select an item from the list"];
    }

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
    cell.shouldOnlySelectChild = self.selectOnlyChild;
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
        
    }
    [_listView reloadData];
    
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

+ (void)getChildIds:(ListViewItemDictionary*)item list:(NSMutableArray*)list{
    
    ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
    if (subItems) {

        for (ListViewItemDictionary *item in subItems) {
            [self getChildIds:item list:list];
        }
        
    } else {

        id value = item[LIST_VIEW_VALUE];
        
        if (![list containsObject:value]) {
            [list addObject:value];
        }
        
    }

}

- (void)getCheckItems:(ListViewItemArray*)items includeChild:(BOOL)includeChild{
    
    BOOL includeSubChild = NO |includeChild;
    for (ListViewItemDictionary *item in items) {
        NSNumber *checkedItem = item[STATUS_CHECK];
  
        if (checkedItem.boolValue | includeChild) {
            [checkedItems addObject:item[LIST_VIEW_VALUE]];
            [checkedNodes addObject:item[LIST_VIEW_MODEL]];
            
            if (!self.parentOnly) {
                includeSubChild = YES;
            }
            if (checkedItem.boolValue) {
                [checkedTitles addObject:item[LIST_VIEW_NAME]];
            }

        }
        
        if (checkedItem.boolValue) {
            [FilterViewController getChildIds:item list:idSelection];
        } else {
            item[STATUS_PREV] = @(0);
        }
        
        if (item.subItemCount>0) {
            ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
            [self getCheckItems:subItems includeChild:includeSubChild];
        }
        
    }
}

+ (void)getCheckItems:(ListViewItemArray*)items includeChild:(BOOL)includeChild list:(NSMutableArray*)list{
    
    BOOL includeSubChild = NO |includeChild;
    for (ListViewItemDictionary *item in items) {
        NSNumber *checkedItem = item[STATUS_CHECK];
        
        if (checkedItem.boolValue) {
            [self getChildIds:item list:list];
        } else {
            item[STATUS_PREV] = @(0);
        }
        
        if (item.subItemCount>0) {
            ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
            [self getCheckItems:subItems includeChild:includeSubChild list:list];
        }
        
    }
}

- (void)revertItems:(ListViewItemArray*)items {
    
    for (ListViewItemDictionary *item in items) {
        
        NSNumber *prevStatus = item[STATUS_PREV];
        
        if (prevStatus) {
            item[STATUS_CHECK] = prevStatus;
        }
        
        if (item.subItemCount>0) {
            ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
            [self revertItems:subItems];
        }
        
    }
}

- (void)prepareListItem:(ListViewItemArray*)listItem {
    for (ListViewItemDictionary *item in listItem) {
        
        NSNumber *statusCheck = item[STATUS_CHECK];
        NSNumber *prevStatus = item[STATUS_PREV];
        
        if (prevStatus == nil) {
            item[STATUS_PREV] = @(0);
        } else {
            if (statusCheck.boolValue) {
                item[STATUS_CHECK] = @(1);
                item[STATUS_PREV] = @(1);
            }
        }
        
        if (item.subItemCount>0) {
            ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
            [self prepareListItem:subItems];
        }
        
    }
}

+ (NSMutableArray*)getCheckedTitles:(ListViewItemArray*)items list:(NSMutableArray*)list{
   
    NSMutableArray *array = list;
    
    if (list == nil) {
        array = [NSMutableArray new];
    }
    
    for (ListViewItemDictionary *item in items) {
        NSNumber *checkedItem = item[STATUS_CHECK];
        
        if (checkedItem.boolValue) {
            [array addObject:item[LIST_VIEW_NAME]];
        }
        
        if (item.subItemCount>0) {
            ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
            NSArray *subarray = [self getCheckedTitles:subItems list:list];
            
            if (subarray.count>0) {
                [array addObjectsFromArray:subarray];
            }
        }
    }
    
    return array;
}

+ (void)uncheckedTitles:(ListViewItemArray*)items list:(NSMutableArray*)list {
    
    for (ListViewItemDictionary *item in items) {
        NSNumber *checkedItem = item[STATUS_CHECK];
        
        if (checkedItem.boolValue) {
            
            NSString *title = item[LIST_VIEW_NAME];
            
            if (![list containsObject:title]) {
                [list removeObject:title];
                item[STATUS_CHECK] = @(0);
                item[STATUS_PREV] = @(0);
            }
            
        }
        
        if (item.subItemCount>0) {
            ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
            [self uncheckedTitles:subItems list:list];
        }
    }
    
    
}

#pragma mark - Search Function

-(void)textFieldDidChange :(UITextField *)textField{
    
    NSString *filter = textField.text;
    
    if ([filter isEqualToString:@""]) {
        filter = nil;
    }
    [localListViewItems filterSubItems:filter];
    [_listView reloadData];
     
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
         [self unexpand:subItems];
         }
         
    }

}

@end

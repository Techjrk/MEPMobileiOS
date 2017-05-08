//
//  ListItemExpandingViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ListItemExpandingViewCell.h"

#import "CustomListView.h"

#define EXPAND_FONT                         fontNameWithSize(FONT_NAME_AWESOME, 20)
#define EXPAND_COLOR                        RGB(72, 72, 74)
#define EXPAND_DOWN                         [NSString stringWithFormat:@"%C", 0xf107]
#define EXPAND_UP                           [NSString stringWithFormat:@"%C", 0xf106]

#define LABEL_FONT                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_COLOR                         RGB(34, 34, 34)

@interface ListItemExpandingViewCell()<CustomListViewDelegate, ListItemExpandingViewCellDelegate, ListItemCollectionViewCellDelegate>{
    ListViewItemArray *subItems;
}
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheck;
@property (weak, nonatomic) IBOutlet UIButton *buttonExpand;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonExpandWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonCheckWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintItemContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consstraintTralingWidth;
@property (weak, nonatomic) IBOutlet CustomListView *listView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageCheckView;
- (IBAction)tappedButtonCheck:(id)sender;
- (IBAction)tappedButtonExpand:(id)sender;
@end

@implementation ListItemExpandingViewCell
@synthesize listItemCollectionViewCellDelegate;
@synthesize listItemExpandingViewCellDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    _constraintItemContainerHeight.constant = [ListItemExpandingViewCell itemHeight];
    _consstraintTralingWidth.constant = kDeviceWidth * 0.04;
    _constraintButtonExpandWidth.constant = kDeviceWidth * 0.15;
    _constraintButtonCheckWidth.constant = kDeviceWidth * 0.112;
    _lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    _buttonCheck.contentMode = UIViewContentModeScaleAspectFit;
    
    [_buttonExpand setTitle:@"" forState:UIControlStateNormal];
    [_buttonExpand setTitleColor:EXPAND_COLOR forState:UIControlStateNormal];
    _buttonExpand.titleLabel.font = EXPAND_FONT;
    
    _listView.customListViewDelegate = self;
    
    _labelTitle.font = LABEL_FONT;
    _labelTitle.textColor = LABEL_COLOR;
    
    [_listView setListViewScrollable:NO];
    
}

- (void)setButtonExpanded:(BOOL)expanded {

    [UIView performWithoutAnimation:^{
        [_buttonExpand setTitle:expanded?EXPAND_UP:EXPAND_DOWN forState:UIControlStateNormal];
   }];
 
}

- (IBAction)tappedButtonCheck:(id)sender {
 
    NSNumber *checked = localItem[STATUS_CHECK];
    
    if([self.listItemCollectionViewCellDelegate singleSelection]) {
        
    };
    
    localItem[STATUS_CHECK] = [NSNumber numberWithBool:!checked.boolValue];
    [self setCheckImage:!checked.boolValue];
    
    
}

- (void)setCheckImage:(BOOL)checked {
    
    _imageCheckView.image = [UIImage imageNamed:checked?@"icon_stateSelected":@"icon_stateDeselected"];
    
}

- (IBAction)tappedButtonExpand:(id)sender {
    
    [self.listItemExpandingViewCellDelegate listViewItemWillExpand:self];
    
}

+ (CGFloat)itemHeight {
    return kDeviceHeight * 0.087;
}

#pragma mark - Custom List View Delegate

- (void)listViewRegisterNib:(CustomListView *)customListView {
    [customListView registerListItemNib:[ListItemExpandingViewCell class]];
}

- (void)listViewItemDidSelected:(ListItemCollectionViewCell *)listViewItem {
    
}

- (NSInteger)listViewItemCount {

    return subItems.count;

}

- (ListItemCollectionViewCell *)listViewItemPrepareForUse:(NSIndexPath *)indexPath listView:(CustomListView *)listView{
    
    ListItemExpandingViewCell *cell = (ListItemExpandingViewCell*)[_listView dequeListItemCollectionViewCell:[[ListItemExpandingViewCell class] description] indexPath:indexPath];
    cell.level = [NSNumber numberWithInteger:self.level.integerValue + 1];
    cell.index = indexPath;
    [cell setItem:subItems[indexPath.row]];
    cell.listItemExpandingViewCellDelegate = self;
    cell.listItemCollectionViewCellDelegate = self;
    cell.shouldOnlySelectChild = self.shouldOnlySelectChild;
    
    [cell reloadData];
    return cell;
}

- (CGSize)listViewItemSize:(NSIndexPath *)indexPath {
    
    CGFloat itemHeight = [ListItemExpandingViewCell itemHeight];
    ListViewItemDictionary *item = subItems[indexPath.row];
    NSNumber *expand = item[STATUS_EXPAND];
    
    if ((expand != nil) & expand.boolValue) {
   
        NSArray *items = item[LIST_VIEW_SUBITEMS];
        itemHeight = itemHeight + [self currentHeight:items];
        
    }
    
    if (self.shouldOnlySelectChild) {
        if ( (subItems != nil) && (subItems.count>0)) {
            self.buttonCheck.hidden = YES;
            self.imageCheckView.hidden = self.buttonCheck.hidden;
            self.constraintButtonCheckWidth.constant = 0;
        } else {
            self.buttonCheck.hidden = NO;
            self.imageCheckView.hidden = self.buttonCheck.hidden;
            self.constraintButtonCheckWidth.constant = kDeviceWidth * 0.112;
        }
    }
    
    return CGSizeMake(_listView.frame.size.width, itemHeight);

}

- (CGFloat)currentHeight:(NSArray*)items {
    
    CGFloat totalHeight = 0;
    
    for (NSMutableDictionary *item in items) {
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
    
    CustomListView *listView = [listViewItem parentListView];
    NSIndexPath *indexPath = listViewItem.index;
    NSMutableDictionary *item = subItems[indexPath.row];
    NSNumber *expand = item[STATUS_EXPAND];
    
    item[STATUS_EXPAND] =  [NSNumber numberWithBool:!expand.boolValue];
    
    [self setButtonExpanded:!expand.boolValue];
    [listView reloadData];

    [self.listItemCollectionViewCellDelegate didChangeListViewItemSize];
}

- (NSArray *)listViewSubItems:(ListItemCollectionViewCell *)listViewItem {
    
    return subItems;
}

- (void)setItem:(ListViewItemDictionary *)item {
    [super setItem:item];
    subItems = item[LIST_VIEW_SUBITEMS];
    _labelTitle.text = item[LIST_VIEW_NAME];
    
    if ((subItems == nil) | (subItems.count == 0)) {
        _constraintButtonExpandWidth.constant = 0;
    } else {
        
        NSNumber *expand = item[STATUS_EXPAND];
        [self setButtonExpanded:expand.boolValue];
        
        _constraintButtonExpandWidth.constant = kDeviceWidth * 0.15;
    }
    
    NSNumber *checked = localItem[STATUS_CHECK];
    
    [self setCheckImage:checked.boolValue];
    
}

- (void)didChangeListViewItemSize {
    [_listView reloadData];
    [self.listItemCollectionViewCellDelegate didChangeListViewItemSize];
}

- (void)reloadData {
    [_listView reloadData];
}

- (BOOL)singleSelection {

    return [self.listItemCollectionViewCellDelegate singleSelection];

}

@end

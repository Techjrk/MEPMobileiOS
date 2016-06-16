//
//  TrackingListView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "TrackingListView.h"

#import "CustomCollectionView.h"
#import "TrackingItemCollectionViewCell.h"
#import "trackingListViewConstants.h"

@interface TrackingListView()<CustomCollectionViewDelegate>{
    NSArray *infoDict;
    BOOL isExpanded;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet CustomCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *buttonHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeaderHeight;
- (IBAction)tappedButtonHeader:(id)sender;
@end

@implementation TrackingListView
@synthesize trackingListViewDelegate;
@synthesize headerTitle;

#define cellHeight              kDeviceHeight * 0.06

- (void)awakeFromNib {
    _collectionView.customCollectionViewDelegate = self;
    _constraintHeaderHeight.constant = kDeviceHeight * 0.08;
    _topView.backgroundColor = TRACK_LIST_TOPBAR_BG_COLOR;
    isExpanded = YES;
    
}

-(void)setInfo:(id)info {
    infoDict = info;
    [self changeButtonTitle];
    _collectionView.cargo = [NSNumber numberWithBool:isExpanded];
    [_collectionView reload];
}

- (void)changeButtonTitle{
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[self.headerTitle stringByAppendingString:@"  "] attributes:@{NSFontAttributeName:TRACK_LIST_TOPBAR_TITLE_FONT, NSForegroundColorAttributeName:TRACK_LIST_TOPBAR_TITLE_COLOR}];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:!isExpanded?SEE_ALL_CARET_DOWN_TEXT:SEE_ALL_CARET_UP_TEXT attributes:@{NSFontAttributeName:SEE_ALL_CARET_FONT, NSForegroundColorAttributeName:TRACK_LIST_TOPBAR_TITLE_COLOR}]];
    
    [_buttonHeader setAttributedTitle:title forState:UIControlStateNormal];
}

- (IBAction)tappedButtonHeader:(id)sender {
    
    isExpanded = !isExpanded;
    [self changeButtonTitle];
    _collectionView.cargo = [NSNumber numberWithBool:isExpanded];
    [_collectionView reload];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CELL_SIZE_CHANGE object:nil];
}

- (CGFloat)viewHeight {
    return _buttonHeader.frame.size.height + ( (isExpanded?infoDict.count:0) * cellHeight);
}

#pragma mark - CustomCollectionView Delegate

- (void)collectionViewItemClassRegister:(id)customCollectionView {
    [_collectionView registerCollectionItemClass:[TrackingItemCollectionViewCell class]];
}

- (UICollectionViewCell*)collectionViewItemClassDeque:(NSIndexPath*)indexPath collectionView:
(UICollectionView*)collectionView {
    return [collectionView dequeueReusableCellWithReuseIdentifier:[[TrackingItemCollectionViewCell class] description] forIndexPath:indexPath];
}

- (NSInteger)collectionViewItemCount {
 
    return isExpanded?infoDict.count:0;
}

- (NSInteger)collectionViewSectionCount {
    return 1;
}

- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath *)indexPath cargo:(id)cargo{
    return CGSizeMake(view.frame.size.width * 0.95, cellHeight);
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    [self.trackingListViewDelegate tappedTrackingListItem:indexPath view:self];
}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    TrackingItemCollectionViewCell *cellItem = (TrackingItemCollectionViewCell*)cell;
    NSDictionary *item = infoDict[indexPath.row];
    [cellItem setInfo:item];
    
}

- (BOOL)isExpanded {
    return isExpanded;
}
@end

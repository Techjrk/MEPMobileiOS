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

@interface TrackingListView()<CustomCollectionViewDelegate>{
    NSDictionary *infoDict;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet CustomCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *buttonHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCollectionHeight;
- (IBAction)tappedButtonHeader:(id)sender;
@end

@implementation TrackingListView

- (void)awakeFromNib {
    _collectionView.customCollectionViewDelegate = self;
}

-(void)setInfo:(id)info {
    infoDict = info;
    [_collectionView reload];
}

- (IBAction)tappedButtonHeader:(id)sender {
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
 
    return 4;
}

- (NSInteger)collectionViewSectionCount {
    return 1;
}

- (CGSize)collectionViewItemSize:(UIView*)view {
    return CGSizeZero;
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    
}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    TrackingItemCollectionViewCell *cellItem = (TrackingItemCollectionViewCell*)cell;
    
}

@end

//
//  CustomCollectionView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomCollectionView.h"

@interface CustomCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    BOOL isNibRegistered;
    NSLayoutConstraint *heightConstraint;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation CustomCollectionView
@synthesize cargo;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)registerCollectionItemClass:(Class)objectClass {
    
    [_collectionView registerNib:[UINib nibWithNibName:[objectClass description] bundle:nil] forCellWithReuseIdentifier:[objectClass description]];

}

- (void)reload {
    [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (!isNibRegistered) {
        isNibRegistered = YES;
        [self.customCollectionViewDelegate collectionViewItemClassRegister:self];
    }
    
    UICollectionViewCell *cell = [self.customCollectionViewDelegate collectionViewItemClassDeque:indexPath collectionView:_collectionView];

    [self.customCollectionViewDelegate collectionViewPrepareItemForUse:cell indexPath:indexPath];
    
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.customCollectionViewDelegate collectionViewItemCount];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.customCollectionViewDelegate collectionViewItemSize:self indexPath:indexPath cargo:self.cargo];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.customCollectionViewDelegate collectionViewDidSelectedItem:indexPath];
}

- (void)setConstraintHeight:(NSLayoutConstraint *)constraint {
    heightConstraint = constraint;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (heightConstraint!= nil) {
        heightConstraint.constant = _collectionView.contentSize.height;
    }

}

- (CGSize)contentSize {

    return _collectionView.collectionViewLayout.collectionViewContentSize;

}

@end

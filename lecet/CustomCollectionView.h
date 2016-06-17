//
//  CustomCollectionView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol CustomCollectionViewDelegate <NSObject>
@optional
- (UICollectionReusableView*)collectionSectionHeader:(UIView*)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
@required
- (void)collectionViewItemClassRegister:(id)customCollectionView;
- (UICollectionViewCell*)collectionViewItemClassDeque:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView;
- (NSInteger)collectionViewItemCount;
- (NSInteger)collectionViewSectionCount;
- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath*)indexPath cargo:(id)cargo;
- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath;
- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath;
@end

@interface CustomCollectionView : BaseViewClass
@property (strong, nonatomic) id<CustomCollectionViewDelegate>customCollectionViewDelegate;
@property (strong, nonatomic) id cargo;
- (void)reload;
- (void)registerCollectionItemClass:(Class)objectClass;
- (void)registerSectionHeaderItemClass:(Class)objectClass;
- (void)setConstraintHeight:(NSLayoutConstraint*)constraint;
- (CGSize)contentSize;
@end

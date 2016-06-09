//
//  MyProfileView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileView.h"
#import "MyProfileHeaderCollectionViewCell.h"
#import "MyProfileTextFieldCVCell.h"
@interface MyProfileView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSDictionary *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    NSArray *headerIndex;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MyProfileView
#define kCellIdentifier                 @"kCellIdentifier"
#define kCellIdentifierTextField        @"kCellIdentifierTextField"

- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[MyProfileHeaderCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:[[MyProfileTextFieldCVCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierTextField];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self setHeaderIndex];
}

- (void)setHeaderIndex{
    
    headerIndex= @[@"0",@"3",@"5",@"7",@"9",@"11",@"13",@"15"];
    
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyProfileHeaderCollectionViewCell *cellHeader = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    MyProfileTextFieldCVCell *celltextField = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierTextField forIndexPath:indexPath];
    
    NSString *intToString = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if ([headerIndex containsObject:intToString]) {
        return cellHeader;
    }else{
        return celltextField;
    }
    
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 17;

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    cellHeight = kDeviceHeight * 0.07;
    size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
        return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);;
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
    
}


@end

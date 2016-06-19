//
//  CompanySortView.m
//  lecet
//
//  Created by Michael San Minay on 18/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanySortView.h"
#import "CompanySortCollectionViewCell.h"

@interface CompanySortView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NSArray *items;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CompanySortView
#define kCellIdentifier     @"kCellIdentifier"

-(void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[CompanySortCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    _collectionView.bounces = NO;
    
    [self.layer setCornerRadius:5.0f];
    self.layer.masksToBounds = YES;
    
    
    items = @[@"Last Updated",@"Alphabetical"];
    
}


#pragma mark - UICollectionView source and delegate


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CompanySortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSString *title = [items objectAtIndex:indexPath.row];
    [cell setLabelTitleText:title];
    [self configureView:cell];
    return cell;
}
- (void)configureView:(UIView*)view {
    CGFloat borderWidth = 1.0;
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(borderWidth, view.frame.size.height - borderWidth, view.frame.size.width, 1)];
    mask.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [view addSubview:mask];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [items count];
}

#pragma mark - UIollection Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    CGFloat cellWidth =  collectionView.frame.size.width;
    CGFloat cellHeight = collectionView.frame.size.height / 2;
    size = CGSizeMake( cellWidth, cellHeight);
    return size;
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
    
    [_companySortDelegate selectedSort:(CompanySortItem)indexPath.row];
    
}
@end

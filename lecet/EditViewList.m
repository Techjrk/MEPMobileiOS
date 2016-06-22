//
//  EditViewList.m
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "EditViewList.h"
#import "EditViewCollectionViewCell.h"
#import "companyTrackingListConstant.h"

@interface EditViewList ()<UICollectionViewDelegate, UICollectionViewDataSource,EditViewCollectionViewCellDelegate>{
    NSDictionary *collectionItems;
    NSMutableArray *collectionDataItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    NSMutableArray *flagSelectedUnSelected;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation EditViewList
#define kCellIdentifier             @"kCellIdentifier"
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"

- (void)awakeFromNib {
   
  
    [_collectionView registerNib:[UINib nibWithNibName:[[EditViewCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
 
}

- (void)setInfo:(id)items {
    collectionDataItems = items;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)setInfoToReload:(id)item {
    collectionDataItems = item;
    [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EditViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.editViewCollectionViewCellDelegate = self;
    [cell setButtonTag:(int)indexPath.row];
    
  
    NSString *addressOne = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_NAME];
    NSString *addressTwo = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_ADDRESSONE];
    [cell setAddressOneText:addressOne];
    [cell setAddressTwoTex:addressTwo];
    
    
    [self configureView:cell];
    
    
    NSString *currentflag = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_SELECTION_FLAG];
    if ([currentflag isEqualToString:UnSelectedFlag]) {
        [cell setButtonSelected:NO];
    }
    if ([currentflag isEqualToString:SelectedFlag]) {
        [cell setButtonSelected:YES];
    }
    
  
    
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
    return [collectionDataItems count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    cellHeight = kDeviceHeight * 0.123;
    size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    
    return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);
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

#pragma mark - EditViewCell Delegate

- (void)tappedButtonSelectAtTag:(int)tag {
    
    NSMutableDictionary *dict = [collectionDataItems objectAtIndex:tag];
    NSString *currentflag = [collectionDataItems objectAtIndex:tag][COMPANYDATA_SELECTION_FLAG];
    NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
    [dict setValue:flagTochange forKey:COMPANYDATA_SELECTION_FLAG];
    [collectionDataItems replaceObjectAtIndex:tag withObject:dict];
        
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)tag inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
    
    NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
    [collectionDataItems enumerateObjectsUsingBlock:^(id result,NSUInteger count,BOOL *stop){
        
        if ([result[COMPANYDATA_SELECTION_FLAG] isEqualToString:SelectedFlag]) {
            [selectedItems addObject:result];
        }
        
    }];
    
    [_editViewListDelegate selectedItem:selectedItems];
    
}

- (id)getData:(id)items {
    return collectionDataItems;
}


@end

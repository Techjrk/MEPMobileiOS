//
//  EditViewList.m
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "EditViewList.h"
#import "EditViewCollectionViewCell.h"

@interface EditViewList ()<UICollectionViewDelegate, UICollectionViewDataSource,EditViewCollectionViewCellDelegate>{
    NSDictionary *collectionItems;
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
    [self tempData];
    flagSelectedUnSelected = [NSMutableArray new];
    [collectionItems[@"companyName"] enumerateObjectsUsingBlock:^(id result,NSUInteger count,BOOL *stop){
        
        [flagSelectedUnSelected addObject:UnSelectedFlag];
    }];

    
    [_collectionView registerNib:[UINib nibWithNibName:[[EditViewCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)tempData {
    NSArray *names = @[@"ERS Industrial Services Inc",@"Jay Dee Contractor, Inc",@"Myers & Sons Construction, LP",@"Slayden Construction Group Inc",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    NSArray *addressesOne = @[@"7215 NW 7th St",@"38881 Schoolcraft Rd",@"254 bowery St",@"174 Purchase Rd",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    NSArray *addressesTwo = @[@"Freemont, CA 10054",@"Livonia, MI 48150-101033",@"Sacramento, CA 21054-1201",@"Stayton, OR 10780",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    NSArray *showButtons = @[@"AddAcct",@"Add",@"false",@"false",@"false",@"false",@"AddAcct",@"false",@"false",@"false",@"Add",@"false",@"false",@"false",@"false",@"false"];
    NSDictionary *dict = @{@"companyName":names,@"companyAddressOne":addressesOne,@"companyAddressTwo":addressesTwo,@"companyButtons":showButtons};
    collectionItems = dict;
    
    
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EditViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.editViewCollectionViewCellDelegate = self;
    [cell setButtonTag:(int)indexPath.row];
    
    NSString *addressOne = [collectionItems[@"companyAddressOne"] objectAtIndex:indexPath.row];
    NSString *addressTwo = [collectionItems[@"companyAddressTwo"] objectAtIndex:indexPath.row];
    [cell setAddressOneText:addressOne];
    [cell setAddressTwoTex:addressTwo];
    
    
    [self configureView:cell];
    
    NSString *currentflag = [flagSelectedUnSelected objectAtIndex:(int)indexPath.row];
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
    return [collectionItems[@"companyName"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    cellHeight = kDeviceHeight * 0.148;
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
    int count;
    NSString *currentflag = [flagSelectedUnSelected objectAtIndex:tag];
    NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
    [flagSelectedUnSelected replaceObjectAtIndex:tag withObject:flagTochange];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)tag inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
    
    [collectionItems[@"companyName"] enumerateObjectsUsingBlock:^(id result,NSUInteger count,BOOL *stop){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)count inSection:0];
        EditViewCollectionViewCell *cell = (EditViewCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        
        if ([cell isButtonSelected]) {
            count++;
            
        }
        
    }];
    
    
    [_editViewListDelegate selectedButtonCountInCell:count];
    
}
- (void)tappedButtonSelect {
    
    
    
    
    
}


@end

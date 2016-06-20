//
//  CompanyTrackingListView.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyTrackingListView.h"
#import "CompanyTrackingCollectionViewCell.h"

@interface CompanyTrackingListView ()<UICollectionViewDelegate, UICollectionViewDataSource,CompanyTrackingCollectionViewCellDelegate>{
    NSDictionary *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    CGFloat cellHeightToExpand;
    int tempTag;
    BOOL firstLoad;
    NSMutableArray *flagsClosedOpen;
    BOOL shouldShowUpdates;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CompanyTrackingListView
#define kCellIdentifier             @"kCellIdentifier"
#define kCellAdditionalHeight       0.68f
#define flagIdentifierOpen          @"open"
#define flagIdentifierClosed        @"closed"

- (void)awakeFromNib {
    
    CompanyTrackingCollectionViewCell *cell = (CompanyTrackingCollectionViewCell *)[CompanyTrackingCollectionViewCell class];

    [_collectionView registerNib:[UINib nibWithNibName:[cell description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    flagsClosedOpen = [NSMutableArray new];
    [self tempData];
    
    [collectionItems[@"companyName"] enumerateObjectsUsingBlock:^(id response,NSUInteger index,BOOL *stop){
        [flagsClosedOpen addObject:flagIdentifierClosed];
    }];
    firstLoad = YES;
    shouldShowUpdates = YES;
}

- (void)setItems:(NSDictionary *)items {
    //collectionItems = items;
    constraintHeight.constant = 0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
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
    
    CompanyTrackingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.companyTrackingCollectionViewCellDelegate =self;
    NSString *titleName = [collectionItems[@"companyName"] objectAtIndex:indexPath.row];
    NSString *addressTop = [collectionItems[@"companyAddressOne"] objectAtIndex:indexPath.row];
    NSString *addressBelow = [collectionItems[@"companyAddressTwo"] objectAtIndex:indexPath.row];
    
    [cell setTitleName:titleName];
    [cell setAddressTop:addressTop];
    [cell setAddressBelow:addressBelow];
    int tag = (int)indexPath.row;
    [cell setButtontag:tag];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //NSInteger count = collectionItems.count;
    return [collectionItems[@"companyName"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    cellHeight = kDeviceHeight * 0.13;
    
    if (shouldShowUpdates) {
        
        NSString *buttonIfToShowString = [collectionItems[@"companyButtons"] objectAtIndex:indexPath.row];
        if ([buttonIfToShowString isEqualToString:@"false"]) {
            size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
            
        }else {
            
            NSString *flag = [flagsClosedOpen objectAtIndex:indexPath.row];
            if ([flag isEqualToString:flagIdentifierOpen]) {
                cellHeightToExpand = 60;
                //size = CGSizeMake( _collectionView.frame.size.width, cellHeight + ((cellHeight/ 2) + 15) + cellHeightToExpand);
                size = CGSizeMake( _collectionView.frame.size.width, cellHeight + (cellHeight * kCellAdditionalHeight) + cellHeightToExpand);
            }else
            {
                //size = CGSizeMake( _collectionView.frame.size.width, cellHeight + (cellHeight/ 2) + 15);
                size = CGSizeMake( _collectionView.frame.size.width, cellHeight + (cellHeight * kCellAdditionalHeight));
            }
            
        }

    }else {
        size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
        
    }
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

}

- (void)tappedButtonAtTag:(int)tag {
    firstLoad = NO;
    
    NSString *flag = [flagsClosedOpen objectAtIndex:tag];
    NSString *flagTochange = [flag isEqualToString:flagIdentifierClosed]?flagIdentifierOpen:flagIdentifierClosed;
    [flagsClosedOpen replaceObjectAtIndex:tag withObject:flagTochange];
    
    tempTag = tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)tag inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
    
}


- (void)switchButtonChange:(BOOL)isOn {
    
    shouldShowUpdates = isOn;
    
    [_collectionView reloadData];
    
}




@end

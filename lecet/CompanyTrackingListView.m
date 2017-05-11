//
//  CompanyTrackingListView.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyTrackingListView.h"
#import "CompanyTrackingCollectionViewCell.h"
#import "EditViewList.h"
#import "CompanyDetailViewController.h"
#import "CustomActivityIndicatorView.h"

@interface CompanyTrackingListView ()<UICollectionViewDelegate, UICollectionViewDataSource,CompanyTrackingCollectionViewCellDelegate>{
    NSMutableArray *collectionDataItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    CGFloat cellHeightToExpand;
    int tempTag;
    BOOL firstLoad;
    BOOL shouldShowUpdates;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet CustomActivityIndicatorView *customLoadingIndicator;

@end

@implementation CompanyTrackingListView

#define kCellIdentifier             @"kCellIdentifier"
#define kCellAdditionalHeight       0.599f
#define flagIdentifierOpen          @"open"
#define flagIdentifierClosed        @"closed"
#define kButtonToShow               @"false"

- (void)awakeFromNib {
    [super awakeFromNib];
    CompanyTrackingCollectionViewCell *cell = (CompanyTrackingCollectionViewCell *)[CompanyTrackingCollectionViewCell class];

    [_collectionView registerNib:[UINib nibWithNibName:[cell description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
   _collectionView.showsVerticalScrollIndicator = NO;
    firstLoad = YES;
    shouldShowUpdates = YES;
}

- (void)setItems:(id)items {

    collectionDataItems = [items mutableCopy];
    NSOperationQueue* queue= [NSOperationQueue new];
    queue.maxConcurrentOperationCount=1;
    [queue setSuspended: YES];

    NSMutableArray *tempArray = collectionDataItems;
    [collectionDataItems enumerateObjectsUsingBlock:^(id response,NSUInteger index,BOOL *stop){
        NSMutableDictionary *dict = [response mutableCopy];
        [dict setValue:flagIdentifierClosed forKey:COMPANYDATA_BUTTON_STATE];
        [dict setValue:@"0" forKey:COMPANYDATA_SELECTION_FLAG];
        
        if ([DerivedNSManagedObject objectOrNil:dict[@"UPDATES"]]) {
            
            NSDictionary *updates = dict[@"UPDATES"];
            [dict setValue:updates[@"changeIndicator"] forKey:COMPANYDATA_BUTTON_TOSHOW];
            
        } else {
            [dict setValue:kButtonToShow forKey:COMPANYDATA_BUTTON_TOSHOW];
        }

            NSBlockOperation* op=[NSBlockOperation blockOperationWithBlock: ^ (void)
            {
                [tempArray replaceObjectAtIndex:index withObject:dict];

            }];
            [queue addOperation: op];
        
    }];
    
    [queue setSuspended: NO];
    [queue waitUntilAllOperationsAreFinished];
    
    collectionDataItems= tempArray;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
    
}

- (void)setItemToReload:(id)item {
    collectionDataItems =item;
     [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CompanyTrackingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.companyTrackingCollectionViewCellDelegate =self;
    
    NSString *titleName = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_NAME];
    NSString *addressTop = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_ADDRESSONE];
    
    NSString *zip5 = [DerivedNSManagedObject objectOrNil:[collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_ZIP5]];
    zip5 = zip5 == nil || [zip5 isEqual:[NSNull null]]?@"":zip5;
    
    NSString *county = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_COUNTY];
    county = county == nil || [county isEqual:[NSNull null]]?@"":[NSString stringWithFormat:@"%@, ",county];
    
    NSString *state = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_STATE];
    state = state == nil || [state isEqual:[NSNull null]]?@"":state;
    
    NSString *addressCon = [NSString stringWithFormat:@"%@%@ %@",county,state,zip5];
    
    NSString *addressBelow = addressCon;
    
    [cell setTitleName:titleName];
    [cell setAddressTop:addressTop];
    [cell setAddressBelow:addressBelow];
    int tag = (int)indexPath.row;
    [cell setButtontag:tag];
    [cell searchLocationGeoCode];
    
    if ([DerivedNSManagedObject objectOrNil:[collectionDataItems objectAtIndex:indexPath.row][@"UPDATES"]]) {
        NSString *titleUpdates =  [DerivedNSManagedObject objectOrNil:[collectionDataItems objectAtIndex:indexPath.row][@"UPDATES"][@"summary"] ];
        
        if (titleUpdates == nil) {
            titleUpdates = @"";
        }
        [cell setButtonLabelTitle:titleUpdates];
        id modelType = [DerivedNSManagedObject objectOrNil:[collectionDataItems objectAtIndex:indexPath.row][@"UPDATES"][@"modelType"]];
        
        if (modelType == nil) {
            modelType = @"";
        }
        [cell setImage:modelType];
        //[cell setUpdateDescription:titleName];
        NSString *updateInfo = [collectionDataItems objectAtIndex:indexPath.row][@"UPDATES"];
        if (updateInfo == nil) {
            updateInfo = @"";
        }
        [cell setUpdateInfo:updateInfo];
    }
    
    NSString *flag = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_BUTTON_STATE];
    if ([flag isEqualToString:flagIdentifierOpen]) {
        [cell changeCaretToUp:YES];
    }else {
        [cell changeCaretToUp:NO];
    }
    
    return cell;
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
    cellHeight = kDeviceHeight * 0.13;

    if (shouldShowUpdates) {
        
        NSString *buttonIfToShowString = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_BUTTON_TOSHOW];
        if ([buttonIfToShowString isEqualToString:kButtonToShow]) {
            size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
            
        }else {
            
            NSString *flag = [collectionDataItems objectAtIndex:indexPath.row][COMPANYDATA_BUTTON_STATE];
            if ([flag isEqualToString:flagIdentifierOpen]) {
                cellHeightToExpand = 50;
                
                size = CGSizeMake( _collectionView.frame.size.width, cellHeight + (cellHeight * kCellAdditionalHeight) + cellHeightToExpand);
            }else
            {
                
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
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.customLoadingIndicator startAnimating];
    NSNumber *recordId = collectionDataItems[indexPath.row][@"id"];
    [[DataManager sharedManager] companyDetail:recordId success:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        id returnObject = object;
        CompanyDetailViewController *controller = [CompanyDetailViewController new];
        controller.view.hidden = NO;
        [controller setInfo:returnObject];
        
        UIViewController *navController = [[DataManager sharedManager] getActiveViewController];
        [navController.navigationController pushViewController:controller animated:YES];
        
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];

}

- (void)tappedButtonAtTag:(int)tag {

    firstLoad = NO;
    
    NSMutableDictionary *dict = [collectionDataItems objectAtIndex:tag];
    NSString *flag = [collectionDataItems objectAtIndex:tag][COMPANYDATA_BUTTON_STATE];
    NSString *flagTochange = [flag isEqualToString:flagIdentifierClosed]?flagIdentifierOpen:flagIdentifierClosed;
   [dict setValue:flagTochange forKey:COMPANYDATA_BUTTON_STATE];
    [collectionDataItems replaceObjectAtIndex:tag withObject:dict];
 
    tempTag = tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)tag inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
    
}

- (void)switchButtonChange:(BOOL)isOn {
    shouldShowUpdates = isOn;
    [_collectionView reloadData];
}

- (id)getdata {
    return collectionDataItems;
}


@end

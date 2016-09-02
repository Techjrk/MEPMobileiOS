//
//  ProjectFilterSelectionViewList.m
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterSelectionViewList.h"
#import "ProjectFilterSelectionCollectionViewCell.h"

@interface ProjectFilterSelectionViewList () <UICollectionViewDelegate, UICollectionViewDataSource,ProjectFilterSelectionCollectionViewCellDelegate>{
    NSMutableArray *collectionDataItems;
    CGFloat cellHeight;
    int prevTag;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProjectFilterSelectionViewList
#define kCellIdentifier             @"kCellIdentifier"
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"
#define FLAGNAME                    @"flag"


- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectFilterSelectionCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.showsVerticalScrollIndicator = NO;
    collectionDataItems = [[NSMutableArray alloc] init];
    
}

- (void)setInfo:(NSArray *)item {
    
    NSString *title = [DerivedNSManagedObject objectOrNil:_dataSelected[@"TITLE"]];
    [item enumerateObjectsUsingBlock:^(id obj,NSUInteger index, BOOL *stop){
        NSMutableDictionary *dict = [obj mutableCopy];
        
        if ([dict[PROJECT_SELECTION_TITLE] isEqualToString:title]) {
            [dict setValue:SelectedFlag forKey:FLAGNAME];
        } else {
            [dict setValue:UnSelectedFlag forKey:FLAGNAME];
        }
        
        [collectionDataItems addObject:dict];
    }];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;


}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectFilterSelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.projectFilterSelectionCollectionViewCellDelegate = self;
    
     NSString *title = [collectionDataItems objectAtIndex:indexPath.row][PROJECT_SELECTION_TITLE];
    [cell setLabelText:title];
    [cell setButtonTag:(int)indexPath.row];
    [self configureView:cell];
    
    NSString *currentflag = [collectionDataItems objectAtIndex:indexPath.row][FLAGNAME];
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
    
    cellHeight = kDeviceHeight * 0.08;
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


#pragma mark - CollectionViewCell Delegate

- (void)tappedCheckButtonAtTag:(int)tag {
    
    
    if (prevTag != tag) {
        [self clearPrevSelection];
    }
    
    
    NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:tag] mutableCopy];
    NSString *currentflag = [collectionDataItems objectAtIndex:tag][FLAGNAME];
    NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
    [dict setValue:flagTochange forKey:FLAGNAME];
    [collectionDataItems replaceObjectAtIndex:tag withObject:dict];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)tag inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];

    prevTag = tag;
    NSDictionary *returnDict = [[collectionDataItems objectAtIndex:tag][FLAGNAME] isEqualToString: SelectedFlag]?[collectionDataItems objectAtIndex:tag]:nil;
    [_projectFilterSelectionViewListDelegate selectedItem:returnDict];
}


- (void)clearPrevSelection {
    NSOperationQueue* queue= [NSOperationQueue new];
    queue.maxConcurrentOperationCount=1;
    [queue setSuspended: YES];
    
    [collectionDataItems enumerateObjectsUsingBlock:^(id response,NSUInteger index,BOOL *stop){
    
        if ([response[FLAGNAME] isEqualToString:SelectedFlag]) {
            NSBlockOperation* op=[NSBlockOperation blockOperationWithBlock: ^ (void)
                                  {
                                      NSMutableDictionary *prevDict = [[collectionDataItems objectAtIndex:index] mutableCopy];
                                      [prevDict setValue:UnSelectedFlag forKey:FLAGNAME];
                                      [collectionDataItems replaceObjectAtIndex:index withObject:prevDict];
                                      
                                      
                                  }];
            [queue addOperation: op];
            
            
        }
        
        
    }];
    
    [queue setSuspended: NO];
    [queue waitUntilAllOperationsAreFinished];
    [_collectionView reloadData];
    
}

@end

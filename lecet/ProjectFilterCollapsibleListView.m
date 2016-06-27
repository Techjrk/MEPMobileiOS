//
//  ProjectFilterCollapsibleListView.m
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterCollapsibleListView.h"
#import "ProjectFilterCollapsibleCollectionViewCell.h"

@interface ProjectFilterCollapsibleListView ()<UICollectionViewDelegate, UICollectionViewDataSource,ProjectFilterCollapsibleCollectionViewCellDelegate>{
    NSMutableArray *collectionDataItems;
    CGFloat cellHeight;
    int prevTag;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProjectFilterCollapsibleListView


#define kCellIdentifier             @"kCellIdentifier"
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"
#define SELECTIONFLAGNAME           @"selectionFlag"
#define DROPDOWNFLAGNAME            @"dropDownFlagName"
#define TITLENAME                   @"TITLE"


- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectFilterCollapsibleCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.showsVerticalScrollIndicator = NO;
    collectionDataItems = [[NSMutableArray alloc] init];
    
    
    
    collectionDataItems = [@[@{TITLENAME:@"One",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag},
                             @{TITLENAME:@"Two",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag},
                             @{TITLENAME:@"three",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag},
                             @{TITLENAME:@"Four",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag},
                             @{TITLENAME:@"Five",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag}
                            ] mutableCopy];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
}

- (void)setInfo:(NSArray *)item {
    
    [item enumerateObjectsUsingBlock:^(id obj,NSUInteger index, BOOL *stop){
        NSMutableDictionary *dict = [obj mutableCopy];
        [dict setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
        [collectionDataItems addObject:dict];
    }];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectFilterCollapsibleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.projectFilterCollapsibleCollectionViewCellDelegate = self;
    
    
    NSString *title = [collectionDataItems objectAtIndex:indexPath.row][TITLENAME];
    [cell setTextLabel:title];
    [cell setButtonTag:(int)indexPath.row];
    [self configureView:cell];
    
    NSString *currentflag = [collectionDataItems objectAtIndex:indexPath.row][SELECTIONFLAGNAME];
    if ([currentflag isEqualToString:UnSelectedFlag]) {
        [cell setSelectionButtonSelected:NO];
    }
    if ([currentflag isEqualToString:SelectedFlag]) {
        [cell setSelectionButtonSelected:YES];
    }
    
    NSString *dropDownFlag = [collectionDataItems objectAtIndex:indexPath.row][DROPDOWNFLAGNAME];
    if ([dropDownFlag isEqualToString:UnSelectedFlag]) {
        [cell setDropDownSelected:NO];
    }
    if ([dropDownFlag isEqualToString:SelectedFlag]) {
        [cell setDropDownSelected:YES];
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
    return 5;
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


#pragma mark - Cell Delegate


- (void)tappedSelectionButton:(int)tag {
    
    NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:tag] mutableCopy];
    NSString *currentflag = [collectionDataItems objectAtIndex:tag][SELECTIONFLAGNAME];
    NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
    [dict setValue:flagTochange forKey:SELECTIONFLAGNAME];
    [collectionDataItems replaceObjectAtIndex:tag withObject:dict];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)tag inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
    
}

- (void)tappedDropDownButton:(int)tag {
    
    NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:tag] mutableCopy];
    NSString *currentflag = [collectionDataItems objectAtIndex:tag][DROPDOWNFLAGNAME];
    NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
    [dict setValue:flagTochange forKey:DROPDOWNFLAGNAME];
    [collectionDataItems replaceObjectAtIndex:tag withObject:dict];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)tag inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
}
@end

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
    
    BOOL hideLineViewInFirstLayerForSecSubCat;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id<UICollectionViewDataSource> myDataSource;

@end

@implementation ProjectFilterCollapsibleListView


#define kCellIdentifier             @"kCellIdentifier"
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"
#define SELECTIONFLAGNAME           @"selectionFlag"
#define DROPDOWNFLAGNAME            @"dropDownFlagName"
#define TITLENAME                   @"title"
#define SUBCATEGORYDATA             @"SubData"
#define SECONDSUBCATDATA            @"SECONDSUBCATDATA"

- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectFilterCollapsibleCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.showsVerticalScrollIndicator = NO;
    collectionDataItems = [[NSMutableArray alloc] init];
}

- (void)setInfo:(NSArray *)item {
    
    collectionDataItems = [item mutableCopy];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
}

- (void)replaceInfo:(id)info atSection:(int)section {

    [collectionDataItems replaceObjectAtIndex:section withObject:info];
    [_collectionView reloadData];
}

- (void)setInfoToReload:(id)info {
    collectionDataItems = [info mutableCopy];
    [_collectionView reloadData];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectFilterCollapsibleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.projectFilterCollapsibleCollectionViewCellDelegate = self;
    
    [cell setIndePathForCollapsible:indexPath];
    if (indexPath.item == 0) {
    
        [self configureSectionData:cell index:indexPath];
        
    }else {
        
        //SubCategory or Row Data
        NSDictionary *dict = [[collectionDataItems objectAtIndex:indexPath.section][SUBCATEGORYDATA] count] > 0?[[collectionDataItems objectAtIndex:indexPath.section][SUBCATEGORYDATA] objectAtIndex:indexPath.row - 1]:nil;
 
        [cell setTextLabel:dict[TITLENAME]];
        
        NSString *currentflag = dict[SELECTIONFLAGNAME];
        BOOL selected = [currentflag isEqualToString:SelectedFlag]?YES:NO;
        [cell setSelectionButtonSelected:selected];
        
        NSString *dropDownFlag = dict[DROPDOWNFLAGNAME];
        BOOL dropDownSelected = [dropDownFlag isEqualToString:SelectedFlag]?YES:NO;
        [cell setDropDownSelected:dropDownSelected];
        
       
        [cell setCollapsibleViewLetfSpacing:42.0f];
        [cell setLeftLineSpacingForLineView:42.0f];
        
        //Second SubCategory
        [self configureSecSubCategory:cell index:indexPath];
        
        
        
    }
    
    return cell;
}

#pragma mark - First  Layer Data/ Section
- (void)configureSectionData:(ProjectFilterCollapsibleCollectionViewCell *)cell index:(NSIndexPath *)indexPath {

    NSString *title = [collectionDataItems objectAtIndex:indexPath.section][TITLENAME];
    [cell setTextLabel:title];
    
    NSString *currentflag = [collectionDataItems objectAtIndex:indexPath.section][SELECTIONFLAGNAME];
    BOOL selected = [currentflag isEqualToString:SelectedFlag]?YES:NO;
    [cell setSelectionButtonSelected:selected];
    
    
    NSString *dropDownFlag = [collectionDataItems objectAtIndex:indexPath.section][DROPDOWNFLAGNAME];
    [cell setCollapsibleViewLetfSpacing:0];
    if ([dropDownFlag isEqualToString:UnSelectedFlag]) {
        [cell setDropDownSelected:NO];
        [cell setLeftLineSpacingForLineView:0];
        
    }
    if ([dropDownFlag isEqualToString:SelectedFlag]) {
        [cell setDropDownSelected:YES];
        [cell setLeftLineSpacingForLineView:42.0f];
    }

    
    if ([DerivedNSManagedObject objectOrNil:[collectionDataItems objectAtIndex:indexPath.section][SUBCATEGORYDATA]]) {
        [cell setCollapsibleRightButtonHidden:NO];
    }else
    {
        [cell setCollapsibleRightButtonHidden:YES];
    }
    
    
    if (hideLineViewInFirstLayerForSecSubCat) {
        [cell setLineViewHidden:YES];
    }

}

#pragma mark - Second SubCategory Data
- (void)configureSecSubCategory:(ProjectFilterCollapsibleCollectionViewCell *)cell index:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *secSubDict = [self getSubCategoryalue:indexPath];
    
    
    if ([DerivedNSManagedObject objectOrNil:secSubDict[SECONDSUBCATDATA]]) {
        
        [cell setSecSubCatInfo:secSubDict[SECONDSUBCATDATA]];
        [cell setCollapsibleRightButtonHidden:NO];
    } else {
        [cell setCollapsibleRightButtonHidden:YES];
    }
    
    [cell setHideLineViewBOOL:YES];
    [cell setSecSubCatLeftSpacing:74.0f];
    [cell setSecSubCatBounce:NO];
    
}


#pragma mark - Collection DataSource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [collectionDataItems count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSString *dropDownFlag = [collectionDataItems objectAtIndex:section][DROPDOWNFLAGNAME];
    NSArray *subData = [collectionDataItems objectAtIndex:section][SUBCATEGORYDATA];
    CGFloat count = [dropDownFlag isEqualToString:UnSelectedFlag]?0:[subData count];
    
    return count + 1;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGSize size;
    cellHeight = kDeviceHeight * 0.08;
   
    if (indexPath.item == 0) {
        size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
    }else {
       
        NSMutableDictionary *subDict = [self getSubCategoryalue:indexPath];
        NSString *currentflag = subDict[DROPDOWNFLAGNAME];
        CGFloat heigthIfOpen = [currentflag isEqualToString:SelectedFlag]?cellHeight *2:cellHeight;
        size = CGSizeMake( _collectionView.frame.size.width, heigthIfOpen);
    }
    

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
    return 5;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];

}

#pragma mark - Cell Delegate
- (void)tappedSelectionButton:(id)tag {
    NSIndexPath *index = tag;
    
    
    if (index.item == 0) {
        NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:index.section] mutableCopy];
        NSString *currentflag = [collectionDataItems objectAtIndex:index.section][SELECTIONFLAGNAME];
        NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
        [dict setValue:flagTochange forKey:SELECTIONFLAGNAME];
        
        NSMutableArray *clearSelection = [self clearSelection:dict[SUBCATEGORYDATA]];
        [dict setValue:clearSelection forKey:SUBCATEGORYDATA];
        
        [collectionDataItems replaceObjectAtIndex:index.section withObject:dict];

        
    } else {
        NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:index.section] mutableCopy];
        NSMutableArray *array = [dict[SUBCATEGORYDATA] mutableCopy];
        
        NSMutableDictionary *subDict = [[array objectAtIndex:index.row -1] mutableCopy];
        NSString *currentflag = subDict[SELECTIONFLAGNAME];
        NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
        [subDict setValue:flagTochange forKey:SELECTIONFLAGNAME];
        [array replaceObjectAtIndex:index.row -1 withObject:subDict];
        [dict setValue:array forKey:SUBCATEGORYDATA];
        [dict setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
        [collectionDataItems replaceObjectAtIndex:index.section withObject:dict];
    }
    
    [_collectionView reloadData];
    
}

- (void)tappedDropDownButton:(id)tag {
    
    NSIndexPath *index = tag;
   
    
    if (index.item == 0) {
        NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:index.section] mutableCopy];
        NSString *currentflag = [collectionDataItems objectAtIndex:index.section][DROPDOWNFLAGNAME];
        NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
        [dict setValue:flagTochange forKey:DROPDOWNFLAGNAME];
        [collectionDataItems replaceObjectAtIndex:index.section withObject:dict];
     
    } else {
        
        NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:index.section] mutableCopy];
        NSMutableArray *array = [dict[SUBCATEGORYDATA] mutableCopy];
        
        NSMutableDictionary *subDict = [[array objectAtIndex:index.row -1] mutableCopy];
        NSString *currentflag = subDict[DROPDOWNFLAGNAME];
        NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
        [subDict setValue:flagTochange forKey:DROPDOWNFLAGNAME];
        [array replaceObjectAtIndex:index.row -1 withObject:subDict];
        [dict setValue:array forKey:SUBCATEGORYDATA];
        [collectionDataItems replaceObjectAtIndex:index.section withObject:dict];

    }
    
    [_collectionView reloadData];
    
}

- (void)tappedSecondSubCatSelectionButton:(id)tag {
    
}

#pragma mark - Misc Method

- (NSMutableDictionary *)getSubCategoryalue:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:indexPath.section] mutableCopy];
    NSMutableArray *array = [dict[SUBCATEGORYDATA] mutableCopy];
    NSMutableDictionary *subDict = [[array objectAtIndex:indexPath.row -1] mutableCopy];
    
    return subDict;
}

- (void)setCollectionViewBounce:(BOOL)bounce {
    _collectionView.bounces = NO;
}

- (void)setHideLineViewInFirstLayerForSecSubCat:(BOOL)hide {
    hideLineViewInFirstLayerForSecSubCat = hide;
}

- (NSMutableArray *)clearSelection:(NSMutableArray *)array {
    NSMutableArray *reArray = [NSMutableArray new];
    for (id obj in array) {
        NSMutableDictionary *res = [obj mutableCopy];
        [res setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
        [reArray addObject:res];
    }
    
    return reArray;
}

@end

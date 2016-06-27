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
@property (nonatomic, weak) id<UICollectionViewDataSource> myDataSource;

@end

@implementation ProjectFilterCollapsibleListView


#define kCellIdentifier             @"kCellIdentifier"
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"
#define SELECTIONFLAGNAME           @"selectionFlag"
#define DROPDOWNFLAGNAME            @"dropDownFlagName"
#define TITLENAME                   @"TITLE"
#define SUBCATEGORYDATA             @"SubData"

- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectFilterCollapsibleCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.showsVerticalScrollIndicator = NO;
    collectionDataItems = [[NSMutableArray alloc] init];
    
    
    
    collectionDataItems = [@[@{TITLENAME:@"One",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                               SUBCATEGORYDATA:
                                @[@{TITLENAME:@"SubOne",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag}]
                               },
                             @{TITLENAME:@"Two",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                               SUBCATEGORYDATA:@[]
                               },
                             @{TITLENAME:@"three",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                               SUBCATEGORYDATA:@[
                                @{TITLENAME:@"SubThreeOne",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag},
                                @{TITLENAME:@"SubThreeTwo",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag},
                                @{TITLENAME:@"SubThreeThree",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag}]
                               },
                             @{TITLENAME:@"Four",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                               SUBCATEGORYDATA:@[]
                               },
                             @{TITLENAME:@"Five",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                               SUBCATEGORYDATA:@[]
                               }
                            ] mutableCopy];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    /*
    CGFloat sectionInsetX =  8.;
    CGFloat sectionInsetTop = 8.;
    CGFloat collectionViewInsetX =  0.;
    CGFloat collectionViewInsetY =  0.;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        collectionViewInsetY += 20.;
    }
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(304., 44.);
    layout.minimumLineSpacing = 4.;
    layout.sectionInset = UIEdgeInsetsMake(sectionInsetTop, sectionInsetX, 0., sectionInsetX);
    _collectionView.contentInset = UIEdgeInsetsMake(collectionViewInsetY, collectionViewInsetX, collectionViewInsetY + sectionInsetTop, collectionViewInsetX);
    
    */
    
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
    
    [cell setIndePathForCollapsible:indexPath];
    if (indexPath.item == 0) {
        
        //Section Data
        NSString *title = [collectionDataItems objectAtIndex:indexPath.section][TITLENAME];
        [cell setTextLabel:title];
        //[cell setButtonTag:(int)indexPath.section];
        
        NSString *currentflag = [collectionDataItems objectAtIndex:indexPath.section][SELECTIONFLAGNAME];
        BOOL selected = [currentflag isEqualToString:SelectedFlag]?YES:NO;
        [cell setSelectionButtonSelected:selected];
        
        /*
        if ([currentflag isEqualToString:UnSelectedFlag]) {
            [cell setSelectionButtonSelected:NO];
        }
        if ([currentflag isEqualToString:SelectedFlag]) {
            [cell setSelectionButtonSelected:YES];
        }*/
        
        NSString *dropDownFlag = [collectionDataItems objectAtIndex:indexPath.section][DROPDOWNFLAGNAME];
        if ([dropDownFlag isEqualToString:UnSelectedFlag]) {
            [cell setDropDownSelected:NO];
            [cell setLeftLineSpacingForLineView:0];
            [cell setCollapsibleViewLetfSpacing:.0];
        }
        if ([dropDownFlag isEqualToString:SelectedFlag]) {
            [cell setDropDownSelected:YES];
            [cell setLeftLineSpacingForLineView:42.0f];
        }

        
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
        
        
        /*
        if ([dropDownFlag isEqualToString:UnSelectedFlag]) {
            [cell setDropDownSelected:NO];
        }
        if ([dropDownFlag isEqualToString:SelectedFlag]) {
            [cell setDropDownSelected:YES];
        }
        */
        
        [cell setCollapsibleViewLetfSpacing:42.0f];
        [cell setLeftLineSpacingForLineView:42.0f];
        
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
    return [collectionDataItems count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    /*
    NSString *dropDownFlag = [collectionDataItems objectAtIndex:section][DROPDOWNFLAGNAME];
    if ([dropDownFlag isEqualToString:UnSelectedFlag]) {
        return MIN(1, 3);
    } else {
        return 3;
    }
    */
    
    NSString *dropDownFlag = [collectionDataItems objectAtIndex:section][DROPDOWNFLAGNAME];
    NSArray *subData = [collectionDataItems objectAtIndex:section][SUBCATEGORYDATA];
    CGFloat count = [dropDownFlag isEqualToString:UnSelectedFlag]?0:[subData count];
    
    return count + 1;
    
    
    
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


- (void)tappedSelectionButton:(id)tag {
    NSIndexPath *index = tag;
    
    
    if (index.row == 0) {
        NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:index.section] mutableCopy];
        NSString *currentflag = [collectionDataItems objectAtIndex:index.section][SELECTIONFLAGNAME];
        NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
        [dict setValue:flagTochange forKey:SELECTIONFLAGNAME];
        [collectionDataItems replaceObjectAtIndex:index.section withObject:dict];
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:(NSInteger)tag];
        //NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        //[_collectionView reloadItemsAtIndexPaths:indexPaths];
    } else {
        NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:index.section] mutableCopy];
        NSMutableArray *array = [dict[SUBCATEGORYDATA] mutableCopy];
        
        NSMutableDictionary *subDict = [[array objectAtIndex:index.row -1] mutableCopy];
        NSString *currentflag = subDict[SELECTIONFLAGNAME];
        NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
        [subDict setValue:flagTochange forKey:SELECTIONFLAGNAME];
        [array replaceObjectAtIndex:index.row -1 withObject:subDict];
        [dict setValue:array forKey:SUBCATEGORYDATA];
        [collectionDataItems replaceObjectAtIndex:index.section withObject:dict];
    }
    
    [_collectionView reloadData];
    
}

- (void)tappedDropDownButton:(id)tag {
    
    NSIndexPath *index = tag;
   
    
    if (index.row == 0) {
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
        //NSLog(@"Array %@", collectionDataItems);
        //NSLog(@"IndexRow %ld IndexSection %ld",(long)index.row,(long)index.section);
        
        
    }
    [_collectionView reloadData];
    

    
    
}
@end

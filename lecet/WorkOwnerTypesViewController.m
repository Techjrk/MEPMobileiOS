//
//  WorkOwnerTypesViewController.m
//  lecet
//
//  Created by Michael San Minay on 30/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "WorkOwnerTypesViewController.h"
#import "WorkOwnerTypesCollectionViewCell.h"
#import "ProfileNavView.h"
@interface WorkOwnerTypesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,ProfileNavViewDelegate,WorkOwnerTypesCollectionViewCellDelegate>{
    NSMutableArray *collectionDataItems;
    CGFloat cellHeight;
    NSString *navTitle;
    int prevTag;
}
@property (weak, nonatomic) IBOutlet ProfileNavView *navView;
@property (weak, nonatomic) IBOutlet UIView *containerCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation WorkOwnerTypesViewController
#define kCellIdentifier             @"kCellIdentifier"
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"
#define SELECTIONFLAGNAME           @"selectionFlag"
#define DROPDOWNFLAGNAME            @"dropDownFlagName"
#define TITLENAME                   @"title"
#define PROJECTGROUPID              @"id"
#define SUBCATEGORYDATA             @"SubData"
#define SECONDSUBCATDATA            @"SECONDSUBCATDATA"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_collectionView registerNib:[UINib nibWithNibName:[[WorkOwnerTypesCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.showsVerticalScrollIndicator = NO;
    _navView.profileNavViewDelegate = self;
    [_navView setRigthBorder:10];
    [_navView setNavRightButtonTitle:NSLocalizedLanguage(@"RIGHTNAV_BUTTON_TITLE")];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [_navView setNavTitleLabel:navTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(id)info {
    
    NSMutableArray *array = [NSMutableArray new];
    for (id dict in info) {
        NSMutableDictionary *resDict =  [dict mutableCopy];
        [resDict setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
        [array addObject:resDict];
    }

    
    collectionDataItems  = array;

}

- (void)setNavTitle:(NSString *)text {
    navTitle = text;
}

#pragma mark - Collection DataSource and Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WorkOwnerTypesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.workOwnerTypesCollectionViewCellDelegate = self;
    [cell setIndexPath:indexPath];
    NSString *title = [collectionDataItems objectAtIndex:indexPath.row][TITLENAME];
    NSString *currentflag = [collectionDataItems objectAtIndex:indexPath.row][SELECTIONFLAGNAME];
    BOOL selected = [currentflag isEqualToString:SelectedFlag]?YES:NO;
    [cell setSelectionButtonSelected:selected];
    
    [cell setTextLabel:title];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [collectionDataItems count];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
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

#pragma mark - NavViewDelegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    switch (profileNavItem) {
        case ProfileNavItemBackButton:{
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ProfileNavItemSaveButton:{
            
            break;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Cell Delegate
- (void)tappedSelectionButton:(id)tag {
    
    
    NSIndexPath *index = tag;
    
    if (prevTag != index.row) {
        [self clearPrevSelection];
    }
    
    NSMutableDictionary *dict = [[collectionDataItems objectAtIndex:index.row] mutableCopy];
    NSString *currentflag = [collectionDataItems objectAtIndex:index.row][SELECTIONFLAGNAME];
    NSString *flagTochange = [currentflag isEqualToString:UnSelectedFlag]?SelectedFlag:UnSelectedFlag;
    [dict setValue:flagTochange forKey:SELECTIONFLAGNAME];    
    [collectionDataItems replaceObjectAtIndex:index.row withObject:dict];
    
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:index, nil];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
    
    prevTag = (int)index.row;
    NSDictionary *returnDict = [[collectionDataItems objectAtIndex:index.row][SELECTIONFLAGNAME] isEqualToString: SelectedFlag]?[collectionDataItems objectAtIndex:index.row]:nil;
    [_workOwnerTypesViewControllerDelegate workOwnerTypesSelectedItems:returnDict];
    
}

- (void)clearPrevSelection {
    NSOperationQueue* queue= [NSOperationQueue new];
    queue.maxConcurrentOperationCount=1;
    [queue setSuspended: YES];
    
    [collectionDataItems enumerateObjectsUsingBlock:^(id response,NSUInteger index,BOOL *stop){
        
        if ([response[SELECTIONFLAGNAME] isEqualToString:SelectedFlag]) {
            NSBlockOperation* op=[NSBlockOperation blockOperationWithBlock: ^ (void)
                                  {
                                      NSMutableDictionary *prevDict = [[collectionDataItems objectAtIndex:index] mutableCopy];
                                      [prevDict setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
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

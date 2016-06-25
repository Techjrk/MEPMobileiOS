//
//  HiddenProjectsViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "HiddenProjectsViewController.h"

#import "ContactNavBarView.h"
#import "HiddenProjectCollectionViewCell.h"

#define HIDDEN_PROJECTS_TOPVIEW_BG_COLOR            RGB(5, 35, 74)

#define HIDDEN_PROJECTS_COUNT_FONT                  fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define HIDDEN_PROJECTS_COUNT_COLOR                 RGB(255, 255, 255)

@interface HiddenProjectsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ContactNavViewDelegate>
@property (weak, nonatomic) IBOutlet ContactNavBarView *topBar;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@end

@implementation HiddenProjectsViewController
@synthesize collectionItems;

#define  kCellIdentifier            @"kCellIdentifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    [_topBar setNameTitle:NSLocalizedLanguage(@"HIDDEN_PROJECTS_TITLE")];
    _topBar.view.backgroundColor = [UIColor clearColor];
    _topBar.backgroundColor = [UIColor clearColor];
    _countView.backgroundColor = HIDDEN_PROJECTS_TOPVIEW_BG_COLOR;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[HiddenProjectCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    _labelCount.text = [NSString stringWithFormat:NSLocalizedLanguage(@"HIDDEN_PROJECT_COUNT"), self.collectionItems.count];
    _labelCount.font = HIDDEN_PROJECTS_COUNT_FONT;
    _labelCount.textColor = HIDDEN_PROJECTS_COUNT_COLOR;
    _topBar.contactNavViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HiddenProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    //DB_CompanyContact *item = collectionItems[indexPath.row];
    
    //[cell setItemInfo:@{CONTACT_NAME:item.name, CONTACT_COMPANY:item.relationshipCompany.name}];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.collectionItems.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellHeight = kDeviceHeight * 0.105;
    size = CGSizeMake( _collectionView.frame.size.width * 0.95, cellHeight);
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
    [[DataManager sharedManager] featureNotAvailable];
}

#pragma mark - Nav Delegate

- (void)tappedContactNavBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

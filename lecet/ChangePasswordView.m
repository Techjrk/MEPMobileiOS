//
//  ChangePasswordView.m
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ChangePasswordView.h"
#import "ChnagePasswordCollectionViewCell.h"

#define CHANGEPASSWORD_LEFTTITLE @"CHANGEPASSWORD_TITLE"
#define CHANGEPASSWORD_PLACEHOLDER @"CHANGEPASSWORD_PLACEHOLDER"

@interface ChangePasswordView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSDictionary *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ChangePasswordView
#define kCellIdentifier                 @"kCellIdentifier"

- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[ChnagePasswordCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setScrollEnabled:NO];
    [self setDataForLeftTitle];
    
}

- (void)setDataForLeftTitle {
    
    
    NSArray *leftTitles = @[NSLocalizedLanguage(@"CPASSWORD_LEFT_TITLE_CURRENT"),NSLocalizedLanguage(@"CPASSWORD_LEFT_TITLE_NEW"),NSLocalizedLanguage(@"CPASSWORD_LEFT_TITLE_CONFIRM")];
    NSArray *placeHoldertitles = @[NSLocalizedLanguage(@"CPASSWORD_PLACEHOLDER_CURRENT"),NSLocalizedLanguage(@"CPASSWORD_PLACEHOLDER_NEW"),NSLocalizedLanguage(@"CPASSWORD_PLACEHOLDER_CONFIRM")];
    NSDictionary *dict = @{CHANGEPASSWORD_LEFTTITLE:leftTitles,CHANGEPASSWORD_PLACEHOLDER:placeHoldertitles};
    
    collectionItems = dict;
}

- (void)configureView:(UIView*)view {
    CGFloat borderWidth = 1.0;
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(borderWidth, view.frame.size.height - borderWidth, view.frame.size.width, 1)];
    mask.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [view addSubview:mask];
    
}

- (void)setItems:(id)items {
    
    collectionItems = items;
    cellHeight = 0;
    constraintHeight.constant = 0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView reloadData];
}
#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChnagePasswordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSString *titleString = [collectionItems[CHANGEPASSWORD_LEFTTITLE] objectAtIndex:indexPath.row];
    NSString *placeHolderString = [collectionItems[CHANGEPASSWORD_PLACEHOLDER] objectAtIndex:indexPath.row];

    [self configureView:cell];
    [cell setSecureTextField:YES];
    [cell setTitle:titleString];
    [cell setPlaceHolderForTextField:placeHolderString];

    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //NSInteger count = collectionItems.count;
    return [collectionItems[CHANGEPASSWORD_LEFTTITLE] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    cellHeight = kDeviceHeight * 0.07;
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

- (NSString *)getCurrentPasswordText {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ChnagePasswordCollectionViewCell *cell = (ChnagePasswordCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    return [cell getText];
}

- (NSString *)getNewPasswordText {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ChnagePasswordCollectionViewCell *cell = (ChnagePasswordCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    return [cell getText];
}

- (NSString *)getConfirmPasswordText {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    ChnagePasswordCollectionViewCell *cell = (ChnagePasswordCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    return [cell getText];
}




@end

//
//  MyProfileView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileView.h"
#import "MyProfileHeaderCollectionViewCell.h"
#import "MyProfileTextFieldCVCell.h"
#import "myProfileConstant.h"
@interface MyProfileView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSDictionary *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    NSArray *headerIndex;
    NSArray *textFieldIndex;
    NSMutableArray *myProfileDataInfo;
    NSDictionary *profileInfo;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMyProfile;

@end

@implementation MyProfileView
#define kCellIdentifier                 @"kCellIdentifier"
#define kCellIdentifierTextField        @"kCellIdentifierTextField"

- (void)awakeFromNib {
    [_collectionViewMyProfile registerNib:[UINib nibWithNibName:[[MyProfileHeaderCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    [_collectionViewMyProfile registerNib:[UINib nibWithNibName:[[MyProfileTextFieldCVCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierTextField];

    [self setHeader];
}

- (void)setHeader{
    
    headerIndex= @[@"0",@"3",@"5",@"7",@"9",@"11",@"13",@"15"];
    textFieldIndex = @[@"1",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16"];
    myProfileDataInfo = [@[NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_NAME"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_FIRSTNAME"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_LASTNAME"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_EMAIL_ADDRESS"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_EMAIL_ADDRESS"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_TITLE"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_TITLE"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_ORGANIZATION"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_ORGANIZATION"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_PHONE"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_PHONE"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STREETADDRESS"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_STREETADDRESS"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_CITY"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_CITY"),
                           NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STATE"),
                           NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_STATE")] mutableCopy];
    
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyProfileHeaderCollectionViewCell *cellHeader = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    MyProfileTextFieldCVCell *celltextField = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierTextField forIndexPath:indexPath];

        NSString *intToString = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        if ([headerIndex containsObject:intToString]) {
            [self setHeaderTitleForCell:cellHeader forIndexPath:indexPath];
            return cellHeader;
        }
        
            
           // [self configureTextFieldViewCell:celltextField forIndexPath:indexPath];
           // [self setTextFieldInfoCell:celltextField forIndexPath:indexPath];
            if (indexPath.row == 1) {
                [self addBottomBorderLineView:celltextField];
            }
            
            
            return celltextField;
        


    
    
}
- (void)setHeaderTitleForCell:(id)cellHeader forIndexPath:(NSIndexPath *)indexPath{
    MyProfileHeaderCollectionViewCell *cell = cellHeader;
    NSString *leftTitle = [myProfileDataInfo objectAtIndex:indexPath.row];
    if ([leftTitle isEqualToString:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_PHONE")]) {
        [cell setHeaderRightTitle:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_FAX")];
        [cell hideRightLabel:NO];
    }
    if ([leftTitle isEqualToString:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_STATE")]) {
        [cell setHeaderRightTitle:NSLocalizedLanguage(@"MYPROFILE_HEADER_TEXT_ZIP")];
        [cell hideRightLabel:NO];
    }
    [cell setHeaderLeftTitle:leftTitle];
}

- (void)setTextFieldInfoCell:(id)cellTextField forIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        [self setTextAndCheckDataIfEmpty:cellTextField dictName:@"first_name"];
    }
    if (indexPath.row == 2) {
        [self setTextAndCheckDataIfEmpty:cellTextField dictName:@"last_name"];
    }
    if (indexPath.row == 4) {
        [self setTextAndCheckDataIfEmpty:cellTextField dictName:@"email"];
    }
    if (indexPath.row == 16) {
        
    }
    
}
- (void)setTextAndCheckDataIfEmpty:(id)cellTextField dictName:(NSString *)dictName {
    MyProfileTextFieldCVCell *cell = cellTextField;
    
        if ([DerivedNSManagedObject objectOrNil:profileInfo[dictName]]) {
            [cell setText:profileInfo[dictName]];
        }

    
}

- (void)configureTextFieldViewCell:(UIView *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        [self addBottomBorderLineView:cell];
    }
    
}

- (void)addBottomBorderLineView:(UIView*)view {
    CGFloat borderWidth = 1.0;
    CGFloat borderSpacing = 15.0f;
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(borderSpacing, view.frame.size.height - borderWidth, view.frame.size.width - (borderSpacing *2), 1)];
    mask.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [view addSubview:mask];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 17;

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    cellHeight = kDeviceHeight * 0.07;
    size = CGSizeMake( _collectionViewMyProfile.frame.size.width, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
        return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);;
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

- (void)setInfo:(id)info {
    profileInfo = info;
    _collectionViewMyProfile.delegate = self;
    _collectionViewMyProfile.dataSource = self;
    [_collectionViewMyProfile reloadData];
 
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
{
    MyProfileHeaderCollectionViewCell *cellHeader = (MyProfileHeaderCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MyProfileTextFieldCVCell *celltextField = (MyProfileTextFieldCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
 
    cellHeader = nil;
    celltextField = nil;
}


@end

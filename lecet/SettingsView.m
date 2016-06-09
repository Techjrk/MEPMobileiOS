//
//  SettingsView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SettingsView.h"
#import "SettingCollectionViewCell.h"


@interface SettingsView ()<UICollectionViewDelegate, UICollectionViewDataSource,SettingCollectionViewCellDelegate>{
    NSDictionary *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SettingsView
#define kCellIdentifier                 @"kCellIdentifier"

- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[SettingCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
  
    
}

- (void)configureView:(UIView*)view {
    CGFloat borderWidth = 1.0;
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(borderWidth, view.frame.size.height - borderWidth, view.frame.size.width, 1)];
    mask.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [view addSubview:mask];
    
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.settingCollectionViewCellDelegate = self;
            [cell setHideChangePassword:YES];
        }
        if (indexPath.row == 1) {
            [cell setHideNotificationView:YES];
            [cell setHideChangePassword:NO];
        }
    }else {
        [cell setHideNotificationView:YES];
        [cell setHideChangePassword:YES];
    }
    [self configureView:cell];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }else{
        return 2;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size;
    CGFloat cellWidth =  collectionView.frame.size.width;
    cellHeight = collectionView.frame.size.height / 4;
    size = CGSizeMake( cellWidth, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);;
    }
    else {
        CGFloat cHeight = (cellHeight * 0.5f);
        return UIEdgeInsetsMake(cHeight, 0, kDeviceHeight * 0.015, 0);;
    }
    
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [_settingViewDelegate selectedSettings:SettingItemsChangePassword];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [_settingViewDelegate selectedSettings:SettingItemsSignOut];
        }
    }
}

#pragma mark - Cell Delegate
- (void)switchButtonStateChange:(BOOL)isOn {
    [_settingViewDelegate switchButtonStateChange:isOn];
}

@end

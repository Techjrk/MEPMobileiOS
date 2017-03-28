//
//  CameraControlListView.m
//  lecet
//
//  Created by Michael San Minay on 17/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CameraControlListView.h"
#import "CustomCameraCollectionViewCell.h"

#pragma mark - FONT
#define FONT_CELL_TITLE             fontNameWithSize(FONT_NAME_LATO_BOLD, 14)

#pragma mark - COLOR
#define COLOR_FONT_CELL_TITLE       RGB(255,255,255)
#define COLOR_BG_LINE_VIEW          RGB(255,255,255)

#define kCellIdentifier                     @"kCellIdentifier"
@interface CameraControlListView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSIndexPath *selectedIndex;
    BOOL isImageCaptured;
    BOOL hideLineView;
}
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *cameraItems;
@end

@implementation CameraControlListView
@synthesize isImageCaptured;


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:[[CustomCameraCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.lineView.backgroundColor = [COLOR_BG_LINE_VIEW colorWithAlphaComponent:0.5];
    self.lineView.hidden = YES;
    
  
}

#pragma mark - UICollectionViewDelegate and DataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.cameraItems.count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCameraCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *info = self.cameraItems[indexPath.row];

    cell.titleLabel.font = FONT_CELL_TITLE;
    cell.titleLabel.textColor = self.isImageCaptured?COLOR_FONT_CELL_TITLE:[COLOR_FONT_CELL_TITLE colorWithAlphaComponent:0.5];
    
    if (selectedIndex == indexPath) {
        cell.titleLabel.textColor = COLOR_FONT_CELL_TITLE;
    }
    
    if (info != nil && ![info isEqual:@""]) {
        NSString *title = info[@"title"];
        cell.titleLabel.text = title;
    } else {
        cell.titleLabel.text = @"";
    }
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    size = CGSizeMake( (self.collectionView.frame.size.width * 0.35), self.collectionView.frame.size.height);
    
    return size;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake( 0, 0, 0, 0);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.cameraItems[indexPath.row];
    if (info != nil && ![info isEqual:@""]) {
        selectedIndex = indexPath;
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.cameraControlListViewDelegate cameraControlListDidSelect:info];
        [self.collectionView reloadData];
    }
}

#pragma mark - Misc Method
- (void)setCameraItemsInfo:(NSArray *)cameraItems hideLineView:(BOOL)hide {
    self.lineView.hidden = hide;
    self.cameraItems = cameraItems;
    [self.collectionView reloadData];
    
    if (cameraItems.count > 2) {
        [self performSelector:@selector(selectInFirstLoad) withObject:nil afterDelay:0.1];
    }
}

- (void)selectInFirstLoad {
    
    int index = 0;
    int count = 0;
    for (id info in self.cameraItems) {
        count++;
        if (info != nil && ![info isEqual:@""]) {
            CameraControlListViewItems items = (CameraControlListViewItems)[info[@"type"] intValue];
            
            //if (items == CameraControlListViewPhoto) {
            if (items == self.focusOnItem) {
                index = (count - 1);
                break;
            }
            /*
            if (items == CameraControlListViewPreview) {
                index = (count - 1);
                break;
            }
             */
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

@end

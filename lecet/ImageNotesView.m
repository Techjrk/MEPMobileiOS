//
//  ImageNotesView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/14/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ImageNotesView.h"
#import "ImageNoteCollectionViewCell.h"
#import "PhotoViewController.h"

#define kCellIdentifier             @"kCellIdentifier"

#define BG_COLOR                    RGB(245, 245, 245)

@interface ImageNotesView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ImageNotesView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[[ImageNoteCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.backgroundColor = BG_COLOR;
}

#pragma mark - UICollectionDelegate and UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageNoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake( collectionView.frame.size.width * 0.9, [ImageNoteCollectionViewCell itemSize]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceHeight * 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageNoteCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [self.imageNotesViewDelegate viewNoteAndImage:cell.titleView.text detail:cell.note.text image:cell.image.image];
}

@end

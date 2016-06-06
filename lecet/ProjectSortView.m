//
//  ProjectSortView.m
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectSortView.h"
#import "ProjectSortCVCell.h"


@interface ProjectSortView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
 
    NSArray *projectSortDataItems;
    
}
@property (weak, nonatomic) IBOutlet UIView *sortTitleView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleSort;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProjectSortView
#define kCellIdentifier     @"kCellIdentifier"



-(void)awakeFromNib{
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectSortCVCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setBackgroundColor:PROJECTSORT_LINE_COLOR];

    _collectionView.bounces = NO;
    
    [self.layer setCornerRadius:5.0f];
    self.layer.masksToBounds = YES;

    
    [_labelTitleSort setFont:PROJECTSORT_SORTTITLE_LABEL_FONT];
    [_labelTitleSort setTextColor:PROJECTSORT_SORTTITLE_LABEL_FONT_COLOR];
    [_labelTitleSort setText:NSLocalizedLanguage(@"PROJECTSORT_TITLE_LABEL_TEXT")];
    
    [_sortTitleView setBackgroundColor:PROJECTSORT_TITLEVIEW_BG_COLOR];
    
    [self setProjectSortDataItem];
    
}


- (void)setProjectSortDataItem{
    projectSortDataItems= @[NSLocalizedLanguage(@"PROJECTSORT_BID_DATE_TEXT"),
                            NSLocalizedLanguage(@"PROJECTSORT_LAST_UPDATED_TEXT"),
                            NSLocalizedLanguage(@"PROJECTSORT_DATE_ADDED_TEXT"),
                            NSLocalizedLanguage(@"PROJECTSORT_HIGH_TO_LOW_TEXT"),
                            NSLocalizedLanguage(@"PROJECTSORT_LOW_TO_HIGH_TEXT")];
    
    
}


#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectSortCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    
    NSString *title = [projectSortDataItems objectAtIndex:indexPath.row];
    cell.labelTitle.text = title;
    
    return cell;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [projectSortDataItems count];
}

#pragma mark - UIollection Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellWidth =  collectionView.frame.size.width;
    CGFloat cellHeight = collectionView.frame.size.height / 5;
    size = CGSizeMake( cellWidth, cellHeight);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [_projectSortViewDelegate selectedProjectSort:(ProjectSortItems)indexPath.row];
    
}





@end

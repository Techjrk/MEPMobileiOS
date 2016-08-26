//
//  FilterEntryView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "FilterEntryView.h"
#import "CustomTitleLabel.h"
#import "FilterEntryCollectionViewCell.h"
#import "CustomCollectionViewFlowLayout.h"

#define kCellIdentifier             @"kCellIdentifier"
#define LABEL_FONT                  fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_FONT_COLOR            RGB(34,34,34)

#define LABEL_HINT_FONT             fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define LABEL_HINT_FONT_COLOR       [UIColor lightGrayColor]

@interface FilterEntryView() <UICollectionViewDelegate, UICollectionViewDataSource,FilterEntryCollectionViewCellDelegate> {
    NSMutableArray *collectionDataItems;
    CGFloat cellHeight;
    
}
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet CustomTitleLabel *labelTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCustomLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriantTopViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelHint;
- (IBAction)tappedButton:(id)sender;
@end

@implementation FilterEntryView
@synthesize filterModel;

- (void)awakeFromNib {
    [super awakeFromNib];

    [_collectionView registerNib:[UINib nibWithNibName:[[FilterEntryCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    _collectionView.layer.borderWidth = 1.0;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _constriantTopViewHeight.constant = (kDeviceHeight * 0.035) * 0.12;
    _constraintCustomLabelHeight.constant = kDeviceHeight * 0.035;
    
     UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedButton:)];
    tapRecognizer.cancelsTouchesInView = YES;
    [_collectionView addGestureRecognizer:tapRecognizer];
    
    _labelHint.font = LABEL_HINT_FONT;
    _labelHint.textColor = LABEL_HINT_FONT_COLOR;
}

- (void)setInfo:(id)info {
    collectionDataItems = [info mutableCopy];
    [_collectionView reloadData];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];

    _button.hidden = collectionDataItems.count > 0?YES:NO;
    _labelHint.hidden = collectionDataItems.count > 0?YES:NO;

}

- (void)setTitle:(NSString *)title {
    _labelTitle.text = title;
}

- (void)setHint:(NSString *)text {
    _labelHint.text = text;
}

- (IBAction)tappedButton:(id)sender {
    [self.filterEntryViewDelegate tappedFilterEntryViewDelegate:self];
}

#pragma mark - Collection Delegate and Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterEntryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.button.tag = indexPath.row;
    NSDictionary *dict = [collectionDataItems objectAtIndex:indexPath.row];
    [cell setLabelAttributedText:[self convertToAttributedText:dict[ENTRYTITLE]]];
    cell.filterEntryCollectionViewCellDelegate = self;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [collectionDataItems count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    cellHeight = kDeviceHeight * 0.035;
    
    NSDictionary *dict = [collectionDataItems objectAtIndex:indexPath.row];
    CGSize labelSize = [dict[ENTRYTITLE] sizeWithAttributes:@{NSFontAttributeName :LABEL_FONT}];

    size = CGSizeMake( labelSize.width + 30 , cellHeight);
    return size;
}

- (NSAttributedString *)convertToAttributedText:(NSString *)text {
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:LABEL_FONT, NSForegroundColorAttributeName:LABEL_FONT_COLOR}];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceHeight * 0.008;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceHeight * 0.008;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    return UIEdgeInsetsMake(kDeviceHeight * 0.005, kDeviceHeight * 0.008, kDeviceHeight * 0.005, kDeviceHeight * 0.008);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)reloadData {
    [_filterEntryViewDelegate reloadDataBeenComplete:self.filterModel];
}

#pragma mark - RemovedData
- (void)tappedRemovedButtonAtIndex:(int)index {
    [collectionDataItems removeObjectAtIndex:index];
    [_collectionView reloadData];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
}

- (NSArray *)getCollectionItemsData {
    return [collectionDataItems copy];
}
@end

//
//  SearchResultView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchResultView.h"

#import "ProjectTrackItemCollectionViewCell.h"
#import "CompanyTrackingCollectionViewCell.h"
#import "ContactItemCollectionViewCell.h"

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)

@interface SearchResultView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableDictionary *items;
    NSInteger currentTab;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonProjects;
@property (weak, nonatomic) IBOutlet UIButton *buttonCompany;
@property (weak, nonatomic) IBOutlet UIButton *buttonContacts;
@property (weak, nonatomic) IBOutlet UIView *viewMarker;
@property (weak, nonatomic) IBOutlet UIView *viewTopHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMakerLeading;
- (IBAction)tappedButton:(id)sender;
@end

@implementation SearchResultView
#define kCellIdentifierProject              @"kCellIdentifierProject"
#define kCellIdentifierCompany              @"kCellIdentifierCompany"
#define kCellIdentifierContact              @"kCellIdentifierContact"

- (void)awakeFromNib {
    [super awakeFromNib];
    _viewTopHeader.backgroundColor = TOP_HEADER_BG_COLOR;
    
    [_buttonProjects setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    _buttonProjects.titleLabel.font = BUTTON_FONT;
    
    [_buttonCompany setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    _buttonCompany.titleLabel.font = BUTTON_FONT;
    
    [_buttonContacts setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    _buttonContacts.titleLabel.font = BUTTON_FONT;
    
    _viewMarker.backgroundColor = BUTTON_MARKER_COLOR;
    
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectTrackItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierProject];
 
    [_collectionView registerNib:[UINib nibWithNibName:[[CompanyTrackingCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierCompany];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[ContactItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierContact];
    
}

- (IBAction)tappedButton:(id)sender {
    
    UIButton *button = sender;
    _constraintMakerLeading.constant = button.frame.origin.x;

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            currentTab =  ((button.frame.origin.x + button.frame.size.width) / button.frame.size.width) -1;
            [_collectionView reloadData];
        }
    }];
    
}

- (void)setCollectionItems:(NSMutableDictionary *)collectionItems tab:(NSInteger)tab {
    items = collectionItems;
    currentTab = tab;
    _constraintMakerLeading.constant = (kDeviceWidth * 0.333) * currentTab;
    [self setInfo];
    
}
- (void)setCollectionItems:(NSMutableDictionary *)collectionItems {
}

- (NSInteger)getCollectionCount:(NSString*)string {

    NSArray *array = items[string];
    return array.count;
}

- (void)setInfo {
    
    [_buttonProjects setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"SEARCH_RESULT_COUNT_PROJECT"), [self getCollectionCount:RESULT_ITEMS_PROJECT]] forState:UIControlStateNormal];

    [_buttonCompany setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"SEARCH_RESULT_COUNT_COMPANY"), [self getCollectionCount:RESULT_ITEMS_COMPANY]] forState:UIControlStateNormal];

    [_buttonContacts setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"SEARCH_RESULT_COUNT_CONTACT"), [self getCollectionCount:RESULT_ITEMS_CONTACT]] forState:UIControlStateNormal];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    switch (currentTab) {
            
        case 0: {
            ProjectTrackItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierProject forIndexPath:indexPath];
            cell = cellItem;
            break;
        }
        
        case 1: {
            CompanyTrackingCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierCompany forIndexPath:indexPath];
            cell = cellItem;
            break;
        }
            
        case 2: {
            ContactItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierContact forIndexPath:indexPath];
            cell = cellItem;
            break;
        }
            
    }
    
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (currentTab) {
        case 0: {
            return [self getCollectionCount:RESULT_ITEMS_PROJECT];
            break;
        }
        case 1: {
            return [self getCollectionCount:RESULT_ITEMS_COMPANY];
            break;
        }
            
        case 2 : {
            return [self getCollectionCount:RESULT_ITEMS_CONTACT];
            break;
        }
    }
    return 0;

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    size = CGSizeMake( collectionView.frame.size.width * 0.96, kDeviceHeight * (currentTab == 2?0.145:0.13));
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(kDeviceHeight * 0.013, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceHeight * (currentTab == 2?0:0.015);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end

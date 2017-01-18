//
//  ProjectNearMeListMe.m
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearMeListView.h"
#import "ProjectNearMeListCollectionViewCell.h"

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)
#define kCellIdentifier                     @"kCellIdentifier"

@interface ProjectNearMeListView () <UICollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
    @property (weak, nonatomic) IBOutlet UIButton *preBidButton;
    @property (weak, nonatomic) IBOutlet UIButton *postBidButton;
    @property (weak, nonatomic) IBOutlet UIView *topHeaderView;
    @property (weak, nonatomic) IBOutlet UIView *markerView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMarkerLeading;
    @property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProjectNearMeListView

    - (void)awakeFromNib {
        [super awakeFromNib];
        
         [self.collectionView registerNib:[UINib nibWithNibName:[[ProjectNearMeListCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
        
        _topHeaderView.backgroundColor = TOP_HEADER_BG_COLOR;
        _markerView.backgroundColor = BUTTON_MARKER_COLOR;
        
        _preBidButton.titleLabel.font = BUTTON_FONT;
        [_preBidButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        [_preBidButton setTitle:NSLocalizedLanguage(@"Pre Bid") forState:UIControlStateNormal];
        
        _postBidButton.titleLabel.font = BUTTON_FONT;
        [_postBidButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        [_postBidButton setTitle:NSLocalizedLanguage(@"Post Bid") forState:UIControlStateNormal];
    }
    
- (IBAction)tappedButton:(id)sender {
    UIButton *button = sender;
    
    _constraintMarkerLeading.constant = button.frame.origin.x;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}
    
#pragma mark - UICollectionView Datasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
    
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - UICollectionView Delegate
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProjectNearMeListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    return cell;
}
    
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    size = CGSizeMake( self.collectionView.frame.size.width * 0.96, kDeviceHeight * 0.135);
    return size;
}
    
#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        return UIEdgeInsetsMake( 0, 0, 0, 0);
}
@end

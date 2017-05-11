//
//  ProjectNearMeListMe.m
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearMeListView.h"
#import "ProjectNearMeListCollectionViewCell.h"
#import "ProjectDetailViewController.h"
#import <MapKit/MapKit.h>
#import "CustomActivityIndicatorView.h"

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)
#define kCellIdentifier                     @"kCellIdentifier"

@interface ProjectNearMeListView () <UICollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *collectionItemsPostBid;
    NSMutableArray *collectionItemsPreBid;
    
    NSMutableArray *tempCollectionItemsPostBid;
    NSMutableArray *tempCollectionItemsPreBid;
    
    BOOL isPostBidHidden;
}
    @property (weak, nonatomic) IBOutlet UIButton *preBidButton;
    @property (weak, nonatomic) IBOutlet UIButton *postBidButton;
    @property (weak, nonatomic) IBOutlet UIView *topHeaderView;
    @property (weak, nonatomic) IBOutlet UIView *markerView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMarkerLeading;
    @property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
    @property (strong,nonatomic) NSArray *collectionItems;
    @property (weak, nonatomic) IBOutlet CustomActivityIndicatorView *customLoadingIndicator;

@end

@implementation ProjectNearMeListView
@synthesize parentCtrl;

    - (void)awakeFromNib {
        [super awakeFromNib];
        
         [self.collectionView registerNib:[UINib nibWithNibName:[[ProjectNearMeListCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
        
        _topHeaderView.backgroundColor = TOP_HEADER_BG_COLOR;
        _markerView.backgroundColor = BUTTON_MARKER_COLOR;
        
        _preBidButton.titleLabel.font = BUTTON_FONT;
        [_preBidButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        
        _postBidButton.titleLabel.font = BUTTON_FONT;
        [_postBidButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        
        NSString *postBidTitle = [NSString stringWithFormat:NSLocalizedLanguage(@"PV_POSTBID"),collectionItemsPostBid.count];
        NSString *preBidTitle = [NSString stringWithFormat:NSLocalizedLanguage(@"PV_PREBID"),collectionItemsPreBid.count];
        
        [_preBidButton setTitle:preBidTitle forState:UIControlStateNormal];
        [_postBidButton setTitle:postBidTitle forState:UIControlStateNormal];
    }

#pragma mark - MISC Methods
- (void)setInfo:(id)info {
    isPostBidHidden = YES;
    
    collectionItemsPreBid = [NSMutableArray new];
    collectionItemsPostBid = [NSMutableArray new];
    
    tempCollectionItemsPreBid = [NSMutableArray new];
    tempCollectionItemsPostBid = [NSMutableArray new];
    
    for (NSDictionary *dicInfo in info) {
        NSDictionary *projectStage = dicInfo[@"projectStage"];
        
        if (projectStage != nil) {
            NSNumber *bidId = projectStage[@"parentId"];
            if (bidId.integerValue != 102) {
                [tempCollectionItemsPostBid addObject:dicInfo];
            } else {
                [tempCollectionItemsPreBid addObject:dicInfo];
            }
        }        
    }

}

- (void)setDataBasedOnVisible {
    [collectionItemsPreBid removeAllObjects];
    collectionItemsPreBid = [self arrangeArrayListBasedOnVisible:tempCollectionItemsPreBid];
    
    [collectionItemsPostBid removeAllObjects];
    collectionItemsPostBid =  [self arrangeArrayListBasedOnVisible:tempCollectionItemsPostBid];
    
    NSString *postBidTitle = [NSString stringWithFormat:NSLocalizedLanguage(@"PV_POSTBID"),collectionItemsPostBid.count];
    NSString *preBidTitle = [NSString stringWithFormat:NSLocalizedLanguage(@"PV_PREBID"),collectionItemsPreBid.count];
    
    [_preBidButton setTitle:preBidTitle forState:UIControlStateNormal];
    [_postBidButton setTitle:postBidTitle forState:UIControlStateNormal];
    
    self.collectionItems = isPostBidHidden ? [collectionItemsPreBid copy] : [collectionItemsPostBid copy];
    [self.collectionView reloadData];
}

- (NSMutableArray *)arrangeArrayListBasedOnVisible:(NSMutableArray *)listArray {
    NSMutableArray *tempSetArray = [NSMutableArray new];
    
    for (id dicInfo in listArray) {
        NSDictionary *geoCode  =  [DerivedNSManagedObject objectOrNil:dicInfo[@"geocode"]];
        BOOL visible = NO;
        
        for (id<MKAnnotation> ann in self.visibleAnnotationArray) {
            CLLocationCoordinate2D coord = ann.coordinate;
            CGFloat lat, lng;
            lat = [geoCode[@"lat"] floatValue];
            lng = [geoCode[@"lng"] floatValue];
            
            if (lat == coord.latitude && lng == coord.longitude) {
                visible = YES;
            }
        }
        visible ? [tempSetArray addObject:dicInfo]:nil;
    }
    return tempSetArray;
}

- (NSString *)setFullAddress:(id)info {
    NSDictionary *dict = info;
    
    NSString *fullAddress = @"";
    NSString *address1 = [DerivedNSManagedObject objectOrNil:dict[@"address1"]];
    NSString *city = [DerivedNSManagedObject objectOrNil:dict[@"city"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:dict[@"state"]];
    NSString *zip = [DerivedNSManagedObject objectOrNil:dict[@"zipPlus4"]];
    
    if (address1 != nil) {
        fullAddress = [[fullAddress stringByAppendingString:address1] stringByAppendingString:@" "];
    }
    
    if (city != nil) {
        fullAddress = [[fullAddress stringByAppendingString:city] stringByAppendingString:@", "];
    }
    
    if (state != nil) {
        fullAddress = [[fullAddress stringByAppendingString:state] stringByAppendingString:@" "];
    }
    
    if (zip != nil) {
        fullAddress = [[fullAddress stringByAppendingString:zip] stringByAppendingString:@" "];
    }
    
    
    return fullAddress;
}
#pragma mark - IBAction
- (IBAction)tappedButton:(id)sender {
    UIButton *button = sender;
    isPostBidHidden = !isPostBidHidden;
    _constraintMarkerLeading.constant = button.frame.origin.x;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.collectionItems = isPostBidHidden ? collectionItemsPreBid : collectionItemsPostBid;
            [self.collectionView reloadData];
        }
    }];
}
    
#pragma mark - UICollectionView Datasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
    
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionItems.count;
}

#pragma mark - UICollectionView Delegate
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProjectNearMeListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dicInfo = self.collectionItems[indexPath.row];
    cell.projectId = dicInfo[@"id"];
    NSString *titleName = [DerivedNSManagedObject objectOrNil:dicInfo[@"title"]];
    cell.titleNameText = titleName;
    cell.titleAddressText = [self setFullAddress:dicInfo];
    cell.geoCode = [DerivedNSManagedObject objectOrNil:dicInfo[@"geocode"]];
    NSNumber *value = [DerivedNSManagedObject objectOrNil:dicInfo[@"estLow"]];
    if (value == nil) {
        value = @(0);
    }
    
    cell.titlePriceText = [NSString stringWithFormat:@"$%@",value];
    cell.unionDesignation = [DerivedNSManagedObject objectOrNil:dicInfo[@"unionDesignation"]];
    [cell setInitInfo];
    
    return cell;
}
    
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    size = CGSizeMake( self.collectionView.frame.size.width * 0.96, kDeviceHeight * 0.135);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.collectionItems[indexPath.row];
    NSNumber *recordId = dic[@"id"];
    [self.customLoadingIndicator startAnimating];
    [[DataManager sharedManager] projectDetail:recordId success:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        ProjectDetailViewController *detail = [ProjectDetailViewController new];
        detail.view.hidden = NO;
        [detail detailsFromProject:object];
        
        [self.parentCtrl.navigationController pushViewController:detail animated:YES];
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];
}

    
#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        return UIEdgeInsetsMake( 0, 0, 0, 0);
}
@end

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
#import "PopupViewController.h"
#import "TrackingListCellCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"
#import "NewTrackingListCollectionViewCell.h"

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)
#define kCellIdentifier                     @"kCellIdentifier"
#define kCellIdentifierTrack                @"kCellIdentifierTrack"

@interface ProjectNearMeListView () <UICollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProjectNearMeListCollectionViewCellDelegate, PopupViewControllerDelegate, CustomCollectionViewDelegate, TrackingListViewDelegate, NewTrackingListCollectionViewCellDelegate> {
    NSMutableArray *collectionItemsPostBid;
    NSMutableArray *collectionItemsPreBid;
    ProjectDetailPopupMode popupMode;
    BOOL isPostBidHidden;
    NSArray *trackItemRecord;
    NSNumber *projectId;
    NSIndexPath *currentProjectIndexPath;
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
    
        [self.collectionView registerNib:[UINib nibWithNibName:[[NewTrackingListCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierTrack];
    
    
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
        
        isPostBidHidden = YES;
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipe:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipe:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView addGestureRecognizer:swipeGestureLeft];
    [self.collectionView addGestureRecognizer:swipeGestureRight];
}

- (void)userSwipe:(UISwipeGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (indexPath != nil) {
        ProjectNearMeListCollectionViewCell* cell = (ProjectNearMeListCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            [cell swipeExpand:sender.direction];
        }
    }
}

#pragma mark - MISC Methods
- (void)setInfo:(id)info {
    
    collectionItemsPreBid = [NSMutableArray new];
    collectionItemsPostBid = [NSMutableArray new];
    
    for (NSDictionary *dicInfo in info) {
        NSDictionary *projectStage = dicInfo[@"projectStage"];
        
        NSMutableDictionary *mutableDict = [dicInfo mutableCopy];
        mutableDict[@"IS_HIDDEN"] = @(NO);
        if (projectStage != nil) {
            NSNumber *bidId = projectStage[@"parentId"];
            if (bidId.integerValue != 102) {
                [collectionItemsPostBid addObject:mutableDict];
                
            } else {
                [collectionItemsPreBid addObject:mutableDict];
            }
        } else {
            [collectionItemsPreBid addObject:mutableDict];
            
        }
    }

}


- (void)setDataBasedOnVisible {
    
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
    isPostBidHidden = YES;
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
- (IBAction)tappedPostBidButton:(id)sender {
    UIButton *button = sender;
    isPostBidHidden = NO;
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
    [cell swipeExpand:UISwipeGestureRecognizerDirectionRight];
    NSString *titleName = [DerivedNSManagedObject objectOrNil:dicInfo[@"title"]];
    cell.titleNameText = titleName;
    cell.titleAddressText = [self setFullAddress:dicInfo];
    cell.dodgeNumber = [DerivedNSManagedObject objectOrNil:dicInfo[@"dodgeNumber"]];
    cell.geoCode = [DerivedNSManagedObject objectOrNil:dicInfo[@"geocode"]];
    NSNumber *value = [DerivedNSManagedObject objectOrNil:dicInfo[@"estLow"]];

    cell.projectNearMeListCollectionViewCellDelegate = self;
    if (value == nil) {
        value = [DerivedNSManagedObject objectOrNil:dicInfo[@"estHigh"]];
    }

    if (value == nil) {
        value = @(0);
    }
    
    cell.titlePriceText = [NSString stringWithFormat:@"$%@",value];
    cell.unionDesignation = [DerivedNSManagedObject objectOrNil:dicInfo[@"unionDesignation"]];
    
    NSArray *userImages = dicInfo[@"images"];
    NSArray *userNotes = dicInfo[@"userNotes"];
    
    cell.hasNoteAndImages = (userNotes.count>0) || (userImages.count>0);
    [cell setInitInfo];
    
    NSNumber *isHidden = dicInfo[@"IS_HIDDEN"];
 
    [cell projectHidden:isHidden.boolValue];
    
    return cell;
}
    
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    size = CGSizeMake( self.collectionView.frame.size.width * 0.96, kDeviceHeight * 0.135);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        return UIEdgeInsetsMake( 0, 0, 0, 0);
}

#pragma mark - ProjectNearMeListCollectionViewCellDelegate Protocol

- (NSIndexPath*)projectIndexPath:(id)sender {
    return [self.collectionView indexPathForCell:(ProjectNearMeListCollectionViewCell*)sender];
}

- (NSMutableDictionary*)itemDictionNary:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(ProjectNearMeListCollectionViewCell*)sender];
    
    return self.collectionItems[indexPath.row];
}

- (void)didSelectItem:(id)sender {
    
    NSDictionary *dic = [self itemDictionNary:sender];
    projectId = dic[@"id"];
    [self.customLoadingIndicator startAnimating];
    [[DataManager sharedManager] projectDetail:projectId success:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        ProjectDetailViewController *detail = [ProjectDetailViewController new];
        detail.view.hidden = NO;
        [detail detailsFromProject:object];
        
        [self.parentCtrl.navigationController pushViewController:detail animated:YES];
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];

}

- (void)didTrackItem:(id)sender {
    NSDictionary *dic = [self itemDictionNary:sender];
    projectId = dic[@"id"];
    currentProjectIndexPath = [self projectIndexPath:sender];
    
    popupMode = ProjectDetailPopupModeTrack;
    [self.customLoadingIndicator startAnimating];
    
    [[DataManager sharedManager] projectAvailableTrackingList:projectId success:^(id object) {
        
        trackItemRecord = object;
        
        if (trackItemRecord.count>0) {
            PopupViewController *controller = [PopupViewController new];
            
            ProjectNearMeListCollectionViewCell *cell = (ProjectNearMeListCollectionViewCell*)sender;
            
            CGRect rect = [controller getViewPositionFromViewController:[cell trackButton] controller:self.parentCtrl];
            controller.popupRect = rect;
            controller.popupWidth = 0.98;
            controller.isGreyedBackground = YES;
            controller.customCollectionViewDelegate = self;
            controller.popupViewControllerDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self.parentCtrl presentViewController:controller animated:NO completion:nil];
        } else {
            
            [self PopupViewControllerDismissed];
            
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"NO_TRACKING_LIST")];
        }
        [self.customLoadingIndicator stopAnimating];
        
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        
    }];
}

- (void)didShareItem:(id)sender {
    
    ProjectNearMeListCollectionViewCell *cell = (ProjectNearMeListCollectionViewCell*)sender;
    
    NSDictionary *dic = [self itemDictionNary:sender];
    projectId = dic[@"id"];
    currentProjectIndexPath = [self projectIndexPath:sender];
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:[cell shareButton] controller:self.parentCtrl];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.parentCtrl presentViewController:controller animated:NO completion:nil];
}

- (void)didHideItem:(id)sender {
    
    NSMutableDictionary *dic = [self itemDictionNary:sender];
    NSNumber *recordId = dic[@"id"];
    currentProjectIndexPath = [self projectIndexPath:sender];
    
    [self.customLoadingIndicator startAnimating];
    
    [[DataManager sharedManager] hideProject:recordId success:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        dic[@"IS_HIDDEN"] = @YES;
        [self.collectionView reloadData];
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];
}

- (void)didExpand:(id)sender {
    NSArray *cells = [self.collectionView visibleCells];
    
    for (ProjectNearMeListCollectionViewCell *cell in cells) {
        if (![cell isEqual:sender]) {
            [cell swipeExpand:UISwipeGestureRecognizerDirectionRight];
        }
    }
    
}

- (void)undoHide:(id)sender {
    
    NSMutableDictionary *dic = [self itemDictionNary:sender];
    NSNumber *recordId = dic[@"id"];
    currentProjectIndexPath = [self projectIndexPath:sender];
    
    [self.customLoadingIndicator startAnimating];
    
    [[DataManager sharedManager] unhideProject:recordId success:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        dic[@"IS_HIDDEN"] = @NO;
        [self.collectionView reloadData];

    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];

}

#pragma mark - CustomCollectionView Delegate

- (void)collectionViewItemClassRegister:(id)customCollectionView {
    
    CustomCollectionView *collectionView = (CustomCollectionView*)customCollectionView;
    switch (popupMode) {
            
        case ProjectDetailPopupModeTrack: {
            [collectionView registerCollectionItemClass:[NewTrackingListCollectionViewCell class]];
            [collectionView registerCollectionItemClass:[TrackingListCellCollectionViewCell class]];
            break;
        }
            
        case ProjectDetailPopupModeShare: {
            
            [collectionView registerCollectionItemClass:[ShareItemCollectionViewCell class]];
            break;
        }
    }
}

- (UICollectionViewCell*)collectionViewItemClassDeque:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView {
    
    switch (popupMode) {
            
        case ProjectDetailPopupModeTrack: {
            
            if (indexPath.row == 0) {
                return [collectionView dequeueReusableCellWithReuseIdentifier:[[TrackingListCellCollectionViewCell class] description]forIndexPath:indexPath];
            } else {
                return [collectionView dequeueReusableCellWithReuseIdentifier:[[NewTrackingListCollectionViewCell class] description]forIndexPath:indexPath];
            }
            break;
        }
            
        case ProjectDetailPopupModeShare :{
            return [collectionView dequeueReusableCellWithReuseIdentifier:[[ShareItemCollectionViewCell class] description]forIndexPath:indexPath];
            break;
        };
            
    }
    
    return nil;
}

- (NSInteger)collectionViewItemCount {
    
    return popupMode == ProjectDetailPopupModeTrack?2:2;
    
}

- (NSInteger)collectionViewSectionCount {
    return 1;
}

- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath*)indexPath cargo:(id)cargo {
    
    switch (popupMode) {
            
        case ProjectDetailPopupModeTrack: {
            CGFloat defaultHeight = kDeviceHeight * 0.08;
            if (indexPath.row == 0) {
                
                CGFloat cellHeight = kDeviceHeight * 0.06;
                defaultHeight = defaultHeight+ ((trackItemRecord.count<4?trackItemRecord.count:4.5)*cellHeight);
            }
            
            return CGSizeMake(kDeviceWidth * 0.98, defaultHeight);
            break;
        }
            
        case ProjectDetailPopupModeShare: {
            return CGSizeMake(kDeviceWidth * 0.98, kDeviceHeight * 0.075);
            break;
        }
            
    }
    
    return CGSizeZero;
}

- (void)PopupViewControllerDismissed {
    ProjectNearMeListCollectionViewCell *cell = (ProjectNearMeListCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentProjectIndexPath];
    if(cell){
        [cell resetStatus];
    }
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    
    NSDictionary *dict = self.collectionItems[currentProjectIndexPath.row];
    NSNumber *recordId = dict[@"id"];

    if (popupMode == ProjectDetailPopupModeShare) {
        NSString *url = [kHost stringByAppendingString:[NSString stringWithFormat:kUrlProjectDetailShare, (long)recordId.integerValue]];
        
        NSString *dodgeNumber = dict[@"dodgeNumber"];
        
        if (indexPath.row == 0) {
            NSString *html = [NSString stringWithFormat:@"<HTML><BODY>DODGE NUMBER :<BR>%@ <BR>WEB LINK : <BR>%@ </BODY></HTML>", dodgeNumber, url];
            [[DataManager sharedManager] sendEmail:html];
            
        } else {
            
            NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"COPY_TO_CLIPBOARD_PROJECT"), dodgeNumber];
            [[DataManager sharedManager] copyTextToPasteBoard:url withMessage:message];
            
        }
    }
}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    
    switch (popupMode) {
            
        case ProjectDetailPopupModeTrack: {
            
            if (indexPath.row == 0) {
                TrackingListCellCollectionViewCell *cellItem = (TrackingListCellCollectionViewCell*)cell;
                cellItem.headerDisabled = YES;
                cellItem.trackingListViewDelegate = self;
                [cellItem setInfo:trackItemRecord withTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_TITLE_TRACKING_LABEL_TEXT")];
            } else {
                NewTrackingListCollectionViewCell *cellItem = (NewTrackingListCollectionViewCell*)cell;
                cellItem.labelTitle.text = NSLocalizedLanguage(@"NTL_TEXT");
                [cellItem.labelTitle sizeToFit];
                cellItem.newtrackingListCollectionViewCellDelegate = self;
            }
            
            break;
        }
            
        case ProjectDetailPopupModeShare: {
            
            ShareItemCollectionViewCell *cellItem = (ShareItemCollectionViewCell*)cell;
            [cellItem setShareItem:indexPath.row == 0?ShareItemEmail:ShareItemLink];
            
            break;
        }
            
    }
    
}

- (void)tappedTrackingListItem:(id)object view:(UIView *)view {
    NSIndexPath *indexPath = object;
    NSDictionary *dict = trackItemRecord[indexPath.row];
    [self.customLoadingIndicator startAnimating];

    [[DataManager sharedManager] projectAddTrackingList:dict[@"id"] recordId:projectId success:^(id object) {
        [[DataManager sharedManager] dismissPopup];
        [self PopupViewControllerDismissed];
        [self.customLoadingIndicator stopAnimating];

    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];

    }];
}

#pragma mark - Project List Delegate and Method

-(void)tappedDismissedProjectTrackList{
    [self PopupViewControllerDismissed];
}

#pragma mark - NewTrackingListCollectionViewCellDelegate
- (void)getNewTrackingList {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedLanguage(@"NTL_TRACKINGNAME") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"";
        textField.placeholder = NSLocalizedLanguage(@"NTL_NEWNAME");
    }];
    
    UIAlertAction *actionAccept = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"PROJECT_FILTER_LOCATION_ACCEPT") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        for (int i=0; i<alert.textFields.count; i++) {
            UITextField *alertTextField = alert.textFields[i];
            
            if (alertTextField) {
                if (alertTextField.text.length>0) {
                    [self.customLoadingIndicator startAnimating];

                    [[DataManager sharedManager] createProjectTrackingList:projectId trackingName:alertTextField.text success:^(id object) {
                        [self PopupViewControllerDismissed];
                        
                        NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"NTL_ADDED"), alertTextField.text];
                     
                        [[DataManager sharedManager] promptMessage:message];
                        ProjectNearMeListCollectionViewCell *cell = (ProjectNearMeListCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentProjectIndexPath];
                        if(cell){
                            [cell resetStatus];
                            [cell swipeExpand:UISwipeGestureRecognizerDirectionRight];
                        }

                        [self.customLoadingIndicator stopAnimating];

                    } failure:^(id object) {
                        [self PopupViewControllerDismissed];
                        [self.customLoadingIndicator stopAnimating];
}];
                }
            }
        }
    }];
    
    [alert addAction:actionAccept];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"NTL_CANCEL") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actionCancel];
    
    
    [self.parentCtrl presentViewController:alert animated:YES completion:nil];
    

}

-(void)didTappedNewTrackingList:(id)sender {
    
    [self.parentCtrl dismissViewControllerAnimated:NO completion:^{
        [self PopupViewControllerDismissed];
        [self getNewTrackingList];
    }];
}

@end

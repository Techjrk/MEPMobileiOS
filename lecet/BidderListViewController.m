//
//  BidderListViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/9/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidderListViewController.h"

#import "ProjectNavigationBarView.h"
#import "ProjectBiddersCollectionViewCell.h"
#import "CompanyDetailViewController.h"

#import <DataManagerSDK/DB_Company.h>
#import <DataManagerSDK/DB_Bid.h>

#import "ProjectDetailViewController.h"
#import "PopupViewController.h"
#import "NewTrackingListCollectionViewCell.h"
#import "TrackingListCellCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"

#define PROJECT_BIDDER_CONTAINER_BG_COLOR           RGB(245, 245, 245)
#define LABEL_COLOR                                 RGB(34, 34, 34)

@interface BidderListViewController ()<ProjectNavViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CustomCollectionViewDelegate, PopupViewControllerDelegate, TrackingListViewDelegate, NewTrackingListCollectionViewCellDelegate>{
    NSIndexPath *currentItemIndexPath;
    NSNumber *currentCompanyId;
    ProjectDetailPopupMode popupMode;
    NSArray *trackItemRecord;
    
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *topBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation BidderListViewController
@synthesize collectionItems;
@synthesize projectName;

#define kCellIdentifier                 @"kCellIdentifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectBiddersCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

    _collectionView.backgroundColor = PROJECT_BIDDER_CONTAINER_BG_COLOR;
    
    [_topBar setContractorName:self.projectName];
    [_topBar setProjectTitle:NSLocalizedLanguage(@"BIDDER_LIST_BOTTOM_LABEL")];
    [_topBar hideReorderButton:YES];
    _topBar.projectNavViewDelegate = self;
    
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
        ProjectBiddersCollectionViewCell* cell = (ProjectBiddersCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            [cell.actionView swipeExpand:sender.direction];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Delegates

- (void)tappedProjectNav:(ProjectNavItem)projectNavItem {
    
    if (projectNavItem == ProjectNavBackButton) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[DataManager sharedManager] featureNotAvailable];
    }
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectBiddersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DB_Bid *bidItem = self.collectionItems[indexPath.row];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    formatter.maximumFractionDigits = 0;
    NSString *estLow = bidItem.amount != nil?[formatter stringFromNumber:[NSNumber numberWithFloat:bidItem.amount.floatValue]]: @"0";
    
    [cell setItem:[NSString stringWithFormat:@"$ %@",estLow] line1:bidItem.relationshipCompany.name line2:[bidItem.relationshipCompany address]];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    [cell.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
    [cell.actionView itemHidden:NO];
    [cell.actionView setUndoLabelTextColor: LABEL_COLOR];
    [cell.actionView disableHide];
    cell.actionViewDelegate = self;

    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.collectionItems.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellHeight = kDeviceHeight * 0.1;
    size = CGSizeMake( kDeviceWidth * 0.85, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
    DB_Bid *bid = self.collectionItems[indexPath.row];
    _collectionView.userInteractionEnabled = NO;
    [[DataManager sharedManager] companyDetail:bid.relationshipCompany.recordId success:^(id object) {
        id returnObject = object;
        CompanyDetailViewController *controller = [CompanyDetailViewController new];
        controller.view.hidden = NO;
        [controller setInfo:returnObject];
        [self.navigationController pushViewController:controller animated:YES];
        _collectionView.userInteractionEnabled = YES;
        
    } failure:^(id object) {
        _collectionView.userInteractionEnabled = YES;
    }];

}

#pragma mark - Project Tracking List

- (void)displayCompanyTrackingList:(id)sender {
    DB_Bid *bidItem = collectionItems[currentItemIndexPath.row];
    
    currentCompanyId = bidItem.relationshipCompany.recordId;
    
    popupMode = ProjectDetailPopupModeTrack;
    [[DataManager sharedManager] companyAvailableTrackingList:currentCompanyId success:^(id object) {
        
        trackItemRecord = object;
        PopupViewController *controller = [PopupViewController new];
        ProjectBiddersCollectionViewCell *cell = (ProjectBiddersCollectionViewCell*)sender;
        
        CGRect rect = [controller getViewPositionFromViewController:[cell.actionView trackButton] controller:self];
        controller.popupRect = rect;
        controller.popupWidth = 0.98;
        controller.isGreyedBackground = YES;
        controller.customCollectionViewDelegate = self;
        controller.popupViewControllerDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:NO completion:nil];
    } failure:^(id object) {
        
    }];
    
}

#pragma mark - ActionView

- (NSIndexPath*)indexPathForSender:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UICollectionViewCell*)sender];
    return indexPath;
}

- (void)didSelectItem:(id)sender {
    NSIndexPath *indexPath = [self indexPathForSender:sender];
    //[self.associatedProjectDelegate tappedAssociatedProject:collectionItems[indexPath.row]];
}

- (void)didTrackItem:(id)sender {
    currentItemIndexPath = [self indexPathForSender:sender];
    [self displayCompanyTrackingList:sender];
}

- (void)shareCompany:(id)sender {
    DB_Bid *bidItem = collectionItems[currentItemIndexPath.row];
    
    ProjectBiddersCollectionViewCell *cell = (ProjectBiddersCollectionViewCell*)sender;
    currentItemIndexPath = [self indexPathForSender:sender];
    currentCompanyId = bidItem.relationshipCompany.recordId;
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:[cell.actionView shareButton] controller:self];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:NO completion:nil];
    
}

- (void)didShareItem:(id)sender {
    [self shareCompany:sender];
}


- (void)didHideItem:(id)sender {
}

- (void)didExpand:(id)sender {
    NSArray *cells = [self.collectionView visibleCells];
    
    for (UICollectionViewCell *cell in cells) {
        if (![cell isEqual:sender]) {
            
            if( [cell respondsToSelector:@selector(actionView)]){
                ActionView * actionView = [cell performSelector:@selector(actionView)];
                [actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
            }
        }
    }
    
}

- (void)unhideProject:(id)sender {
}

- (void)undoHide:(id)sender {
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
            
        default: {
            break;
        }
            
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
    UICollectionViewCell *cell = (UICollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentItemIndexPath];
    if(cell){
        if( [cell respondsToSelector:@selector(actionView)]){
            ActionView * actionView = [cell performSelector:@selector(actionView)];
            [actionView resetStatus];
        }
    }
}

- (void)didSelectShareCompany:(NSIndexPath*)indexPath {
    DB_Bid *bidItem = collectionItems[currentItemIndexPath.row];
    currentCompanyId = bidItem.relationshipCompany.recordId;
    
    NSString *url = [kHost stringByAppendingString:[NSString stringWithFormat:kUrlCompanyDetailShare, (long)currentCompanyId.integerValue]];
    
    if (indexPath.row == 0) {
        
        NSString *html = [NSString stringWithFormat:@"<HTML><BODY>COMPANY NAME :<BR>%@ <BR>WEB LINK : <BR>%@ </BODY></HTML>", bidItem.relationshipCompany.name, url];
        [[DataManager sharedManager] sendEmail:html];
        
    } else {
        NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"COPY_TO_CLIPBOARD_COMPANY"), bidItem.relationshipCompany.name];
        [[DataManager sharedManager] copyTextToPasteBoard:url withMessage:message];
        
    }
    
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    [self didSelectShareCompany:indexPath];
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


- (void)trackCompanyItem:(NSIndexPath*)indexPath {
    NSDictionary *dict = trackItemRecord[indexPath.row];
    
    [[DataManager sharedManager] companyAddTrackingList:dict[@"id"] recordId:currentCompanyId success:^(id object) {
        [[DataManager sharedManager] dismissPopup];
        [self PopupViewControllerDismissed];
    } failure:^(id object) {
    }];
    
}

- (void)tappedTrackingListItem:(id)object view:(UIView *)view {
    [self trackCompanyItem:object];
}

#pragma mark - Project List Delegate and Method

-(void)tappedDismissedProjectTrackList{
    [self PopupViewControllerDismissed];
}

#pragma mark - NewTrackingListCollectionViewCellDelegate

- (void)createNewCompanyTrackingList:(UITextField*)alertTextField {
    [[DataManager sharedManager] createCompanyTrackingList:currentCompanyId trackingName:alertTextField.text success:^(id object) {
        [self PopupViewControllerDismissed];
        
        NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"NTL_COMPANYADDED"), alertTextField.text];
        
        [[DataManager sharedManager] promptMessage:message];
        
        UICollectionViewCell *cell = (UICollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentItemIndexPath];
        if(cell){
            if([cell respondsToSelector:@selector(resetStatus)]){
                [cell performSelector:@selector(resetStatus)];
            }
        }
        
    } failure:^(id object) {
        [self PopupViewControllerDismissed];
    }];
}

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
                    
                    [self createNewCompanyTrackingList:alertTextField];
                    
                }
            }
        }
    }];
    
    [alert addAction:actionAccept];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"NTL_CANCEL") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actionCancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)didTappedNewTrackingList:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self PopupViewControllerDismissed];
        [self getNewTrackingList];
    }];
}


@end

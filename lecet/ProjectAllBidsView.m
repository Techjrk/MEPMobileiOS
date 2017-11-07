//
//  ProjectAllBidsView.m
//  lecet
//
//  Created by Michael San Minay on 03/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectAllBidsView.h"
#import "ProjectBidItemCollectionViewCell.h"
#import "ProjectBidView.h"
#import <DataManagerSDK/DB_Bid.h>
#import <DataManagerSDK/DB_Project.h>
#import "ProjectSortCVCell.h"

#import "PopupViewController.h"
#import "ProjectDetailViewController.h"
#import "NewTrackingListCollectionViewCell.h"
#import "TrackingListCellCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"
#define LABEL_COLOR                                     RGB(34, 34, 34)

@interface ProjectAllBidsView ()<UICollectionViewDelegate, UICollectionViewDataSource,  ActionViewDelegate, CustomCollectionViewDelegate, PopupViewControllerDelegate, TrackingListViewDelegate, NewTrackingListCollectionViewCellDelegate>{
    NSMutableArray *collectionItems;
    CGFloat cellHeight;
    
    NSNumber *projectId;
    NSIndexPath *currentProjectIndexPath;
    ProjectDetailPopupMode popupMode;
    NSArray *trackItemRecord;

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ProjectAllBidsView
@synthesize projectAllBidsViewDelegate;

#define kCellIdentifier             @"kCellIdentifier"

-(void)awakeFromNib{
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectBidItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
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
        ProjectBidItemCollectionViewCell* cell = (ProjectBidItemCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            [cell.actionView swipeExpand:sender.direction];
        }
    }
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProjectBidItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DB_Bid *bid = collectionItems[indexPath.row];
    DB_Project *project = bid.relationshipProject;
    NSDictionary *dict = @{PROJECT_BID_NAME:project.title, PROJECT_BID_LOCATION:[project address], PROJECT_BID_AMOUNT:[bid bidAmountWithCurrency], PROJECT_BID_DATE:[project bidDateString], PROJECT_BID_GEOCODE_LAT:project.geocodeLat, PROJECT_BID_GEOCODE_LNG:project.geocodeLng};
  
    [cell setInfo:dict];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    [cell.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
    [cell.actionView projectHidden:NO];
    [cell.actionView setUndoLabelTextColor: LABEL_COLOR];
    cell.actionViewDelegate = self;
    
    if(project.isHidden != nil) {
        [cell.actionView projectHidden:project.isHidden.boolValue];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = collectionItems.count;
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    cellHeight = kDeviceHeight * 0.15;
    size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.projectAllBidsViewDelegate selectedProjectAllBidItem:collectionItems[indexPath.row]];
}

#pragma mark - ActionView

- (NSIndexPath*)indexPathForSender:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(ProjectBidItemCollectionViewCell*)sender];
    return indexPath;
}

- (void)didSelectItem:(id)sender {
    NSIndexPath *indexPath = [self indexPathForSender:sender];
    [self.projectAllBidsViewDelegate selectedProjectAllBidItem:collectionItems[indexPath.row]];
}

- (void)didTrackItem:(id)sender {
    currentProjectIndexPath = [self indexPathForSender:sender];
    DB_Bid *project = collectionItems[currentProjectIndexPath.row];
    projectId = project.relationshipProject.recordId;
    
    popupMode = ProjectDetailPopupModeTrack;
    
    [[DataManager sharedManager] projectAvailableTrackingList:projectId success:^(id object) {
        
        trackItemRecord = object;
        
        if (trackItemRecord.count>0) {
            PopupViewController *controller = [PopupViewController new];
            
            ProjectBidItemCollectionViewCell *cell = (ProjectBidItemCollectionViewCell*)sender;
            
            CGRect rect = [controller getViewPositionFromViewController:[cell.actionView trackButton] controller:[self.projectAllBidsViewDelegate parentController]];
            controller.popupRect = rect;
            controller.popupWidth = 0.98;
            controller.isGreyedBackground = YES;
            controller.customCollectionViewDelegate = self;
            controller.popupViewControllerDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [[self.projectAllBidsViewDelegate parentController] presentViewController:controller animated:NO completion:nil];
        } else {
            
            [self PopupViewControllerDismissed];
            
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"NO_TRACKING_LIST")];
        }
        
    } failure:^(id object) {
        
    }];
}

- (void)didShareItem:(id)sender {
    
    ProjectBidItemCollectionViewCell *cell = (ProjectBidItemCollectionViewCell*)sender;
    currentProjectIndexPath = [self indexPathForSender:sender];
    DB_Bid *project = collectionItems[currentProjectIndexPath.row];
    projectId = project.relationshipProject.recordId;
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:[cell.actionView shareButton] controller:[self.projectAllBidsViewDelegate parentController]];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [[self.projectAllBidsViewDelegate parentController] presentViewController:controller animated:NO completion:nil];
}

- (void)didHideItem:(id)sender {
    
    currentProjectIndexPath = [self indexPathForSender:sender];
    DB_Bid *project = collectionItems[currentProjectIndexPath.row];
    projectId = project.relationshipProject.recordId;
    
    [[DataManager sharedManager] hideProject:projectId success:^(id object) {
        project.relationshipProject.isHidden = @YES;
        [[DataManager sharedManager] saveContext];
        [self.collectionView reloadData];
    } failure:^(id object) {
    }];
}

- (void)didExpand:(id)sender {
    NSArray *cells = [self.collectionView visibleCells];
    
    for (ProjectBidItemCollectionViewCell *cell in cells) {
        if (![cell isEqual:sender]) {
            [cell.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
        }
    }
    
}

- (void)undoHide:(id)sender {
    
    currentProjectIndexPath = [self indexPathForSender:sender];
    DB_Bid *project = collectionItems[currentProjectIndexPath.row];
    projectId = project.relationshipProject.recordId;
    
    [[DataManager sharedManager] unhideProject:projectId success:^(id object) {
        project.relationshipProject.isHidden = @NO;
        [[DataManager sharedManager] saveContext];
        [self.collectionView reloadData];
        
    } failure:^(id object) {
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
    ProjectBidItemCollectionViewCell *cell = (ProjectBidItemCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentProjectIndexPath];
    if(cell){
        [cell.actionView resetStatus];
    }
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    
    DB_Bid *project = collectionItems[indexPath.row];
    NSNumber *recordId = project.relationshipProject.recordId;
    
    if (popupMode == ProjectDetailPopupModeShare) {
        NSString *url = [kHost stringByAppendingString:[NSString stringWithFormat:kUrlProjectDetailShare, (long)recordId.integerValue]];
        
        NSString *dodgeNumber = project.relationshipProject.dodgeNumber;
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
    
    [[DataManager sharedManager] projectAddTrackingList:dict[@"id"] recordId:projectId success:^(id object) {
        [[DataManager sharedManager] dismissPopup];
        [self PopupViewControllerDismissed];
        
    } failure:^(id object) {
        
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
                    
                    [[DataManager sharedManager] createProjectTrackingList:projectId trackingName:alertTextField.text success:^(id object) {
                        [self PopupViewControllerDismissed];
                        
                        NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"NTL_ADDED"), alertTextField.text];
                        
                        [[DataManager sharedManager] promptMessage:message];
                        ProjectBidItemCollectionViewCell *cell = (ProjectBidItemCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentProjectIndexPath];
                        if(cell){
                            [cell.actionView resetStatus];
                            [cell.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
                        }
                        
                        
                    } failure:^(id object) {
                        [self PopupViewControllerDismissed];
                    }];
                }
            }
        }
    }];
    
    [alert addAction:actionAccept];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"NTL_CANCEL") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actionCancel];
    
    
    [[self.projectAllBidsViewDelegate parentController] presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)didTappedNewTrackingList:(id)sender {
    [[self.projectAllBidsViewDelegate parentController] dismissViewControllerAnimated:NO completion:^{
        [self PopupViewControllerDismissed];
        [self getNewTrackingList];
    }];
}

@end

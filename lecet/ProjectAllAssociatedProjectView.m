//
//  ProjectAllAssociatedProjectView.m
//  lecet
//
//  Created by Michael San Minay on 05/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectAllAssociatedProjectView.h"
#import "AssociatedBidCollectionViewCell.h"
#import "AssociatedBidView.h"
#import <DataManagerSDK/DB_Project.h>

#import "PopupViewController.h"
#import "ProjectDetailViewController.h"
#import "NewTrackingListCollectionViewCell.h"
#import "TrackingListCellCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"

#define LABEL_COLOR                                     RGB(34, 34, 34)

@interface ProjectAllAssociatedProjectView ()<UICollectionViewDelegate, UICollectionViewDataSource, ActionViewDelegate, CustomCollectionViewDelegate, PopupViewControllerDelegate, TrackingListViewDelegate, NewTrackingListCollectionViewCellDelegate>{
    NSMutableArray *collectionItems;
    NSLayoutConstraint *constraintHeight;
    CGFloat cellHeight;
    
    NSNumber *projectId;
    NSIndexPath *currentProjectIndexPath;
    ProjectDetailPopupMode popupMode;
    NSArray *trackItemRecord;

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ProjectAllAssociatedProjectView
@synthesize projectAllAssociatedProjectViewDelegate;

#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:[[AssociatedBidCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
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
        AssociatedBidCollectionViewCell* cell = (AssociatedBidCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            [cell.actionView swipeExpand:sender.direction];
        }
    }
}

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    constraintHeight.constant = 0;
    [_collectionView reloadData];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssociatedBidCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
  
    DB_Project *project = collectionItems[indexPath.row];
    NSDictionary *dict = @{ASSOCIATED_BID_NAME:project.title, ASSOCIATED_BID_LOCATION:[project address], ASSOCIATED_BID_DESIGNATION:project.unionDesignation != nil?project.unionDesignation:@"", ASSOCIATED_BID_GEOCODE_LAT:project.geocodeLat, ASSOCIATED_BID_GEOCODE_LNG:project.geocodeLng, ASSOCIATED_BID_ID:project.recordId,ASSOCIATED_BID_HAS_NOTESIMAGES:project.hasNotesImages};
    [cell setInfo:dict];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    [cell.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
    [cell.actionView itemHidden:NO];
    [cell.actionView setUndoLabelTextColor: LABEL_COLOR];
    cell.actionViewDelegate = self;
    
    if(project.isHidden != nil) {
        [cell.actionView itemHidden:project.isHidden.boolValue];
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
    cellHeight = kDeviceHeight * 0.148;
    size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);
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
    [self.projectAllAssociatedProjectViewDelegate selectedAssociatedProjectItem:collectionItems[indexPath.row]];
}

#pragma mark - ActionView

- (NSIndexPath*)indexPathForSender:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(AssociatedBidCollectionViewCell*)sender];
    return indexPath;
}

- (void)didSelectItem:(id)sender {
    NSIndexPath *indexPath = [self indexPathForSender:sender];
    [self.projectAllAssociatedProjectViewDelegate selectedAssociatedProjectItem:collectionItems[indexPath.row]];
}

- (void)didTrackItem:(id)sender {
    currentProjectIndexPath = [self indexPathForSender:sender];
    DB_Project *project = collectionItems[currentProjectIndexPath.row];
    projectId = project.recordId;
    
    popupMode = ProjectDetailPopupModeTrack;
    
    [[DataManager sharedManager] projectAvailableTrackingList:projectId success:^(id object) {
        
        trackItemRecord = object;
        
        if (trackItemRecord.count>0) {
            PopupViewController *controller = [PopupViewController new];
            
            AssociatedBidCollectionViewCell *cell = (AssociatedBidCollectionViewCell*)sender;
            
            CGRect rect = [controller getViewPositionFromViewController:[cell.actionView trackButton] controller:[self.projectAllAssociatedProjectViewDelegate parentItemController]];
            controller.popupRect = rect;
            controller.popupWidth = 0.98;
            controller.isGreyedBackground = YES;
            controller.customCollectionViewDelegate = self;
            controller.popupViewControllerDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [[self.projectAllAssociatedProjectViewDelegate parentItemController] presentViewController:controller animated:NO completion:nil];
        } else {
            
            [self PopupViewControllerDismissed];
            
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"NO_TRACKING_LIST")];
        }
        
    } failure:^(id object) {
        
    }];
}

- (void)didShareItem:(id)sender {
    
    AssociatedBidCollectionViewCell *cell = (AssociatedBidCollectionViewCell*)sender;
    currentProjectIndexPath = [self indexPathForSender:sender];
    DB_Project *project = collectionItems[currentProjectIndexPath.row];
    projectId = project.recordId;
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:[cell.actionView shareButton] controller:[self.projectAllAssociatedProjectViewDelegate parentItemController]];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [[self.projectAllAssociatedProjectViewDelegate parentItemController] presentViewController:controller animated:NO completion:nil];
}

- (void)didHideItem:(id)sender {
    
    currentProjectIndexPath = [self indexPathForSender:sender];
    DB_Project *project = collectionItems[currentProjectIndexPath.row];
    projectId = project.recordId;
    
    [[DataManager sharedManager] hideProject:projectId success:^(id object) {
        project.isHidden = @YES;
        [[DataManager sharedManager] saveContext];
        [self.collectionView reloadData];
    } failure:^(id object) {
    }];
}

- (void)didExpand:(id)sender {
    NSArray *cells = [self.collectionView visibleCells];
    
    for (AssociatedBidCollectionViewCell *cell in cells) {
        if (![cell isEqual:sender]) {
            [cell.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
        }
    }
    
}

- (void)undoHide:(id)sender {
    
    currentProjectIndexPath = [self indexPathForSender:sender];
    DB_Project *project = collectionItems[currentProjectIndexPath.row];
    projectId = project.recordId;
    
    [[DataManager sharedManager] unhideProject:projectId success:^(id object) {
        project.isHidden = @NO;
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
    AssociatedBidCollectionViewCell *cell = (AssociatedBidCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentProjectIndexPath];
    if(cell){
        [cell.actionView resetStatus];
    }
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    
    DB_Project *project = collectionItems[indexPath.row];
    NSNumber *recordId = project.recordId;
    
    if (popupMode == ProjectDetailPopupModeShare) {
        NSString *url = [kHost stringByAppendingString:[NSString stringWithFormat:kUrlProjectDetailShare, (long)recordId.integerValue]];
        
        NSString *dodgeNumber = project.dodgeNumber;
        
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
                        AssociatedBidCollectionViewCell *cell = (AssociatedBidCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentProjectIndexPath];
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
    
    
    [[self.projectAllAssociatedProjectViewDelegate parentItemController] presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)didTappedNewTrackingList:(id)sender {
    [[self.projectAllAssociatedProjectViewDelegate parentItemController] dismissViewControllerAnimated:NO completion:^{
        [self PopupViewControllerDismissed];
        [self getNewTrackingList];
    }];
}

@end

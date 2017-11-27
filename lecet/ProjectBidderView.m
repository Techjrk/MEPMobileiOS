//
//  ProjectBidderView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBidderView.h"

#import "SectionTitleView.h"
#import "ProjectBiddersCollectionViewCell.h"
#import <DataManagerSDK/DB_Bid.h>
#import <DataManagerSDK/DB_Company.h>
#import "ProjectDetailViewController.h"
#import "PopupViewController.h"
#import "TrackingListCellCollectionViewCell.h"
#import "NewTrackingListCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"
#import "NewTrackingListCollectionViewCell.h"

#define PROJECTBIDDERS_FONT                fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define PROJECTBIDDERS_COLOR               RGB(121, 120, 120)
#define LABEL_COLOR                        RGB(34, 34, 34)

@interface ProjectBidderView()<UICollectionViewDelegate, UICollectionViewDataSource, CustomCollectionViewDelegate, ActionViewDelegate, PopupViewControllerDelegate, TrackingListViewDelegate, NewTrackingListCollectionViewCellDelegate>{
    NSLayoutConstraint *constraintHeight;
    NSMutableArray *collectionItems;
    CGFloat cellHeight;
    NSNumber *currentCompanyId;
    NSIndexPath *currentItemIndexPath;
    ProjectDetailPopupMode popupMode;
    NSArray *trackItemRecord;
}
@property (weak, nonatomic) IBOutlet SectionTitleView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeAll;
- (IBAction)tappedButtonSeeAll:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintButtonSeeAll;
@end

@implementation ProjectBidderView
@synthesize projectBidderDelegate;

#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    [super awakeFromNib];
    [_titleView setTitle:NSLocalizedLanguage(@"PROJECTBIDDER_VIEW_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;

    [_buttonSeeAll setTitleColor:PROJECTBIDDERS_COLOR forState:UIControlStateNormal];
    _buttonSeeAll.titleLabel.font = PROJECTBIDDERS_FONT;

    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectBiddersCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];

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

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)setItems:(NSMutableArray*)items {
    collectionItems = items;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _contraintButtonSeeAll.constant = items.count>3? (kDeviceHeight * 0.06):0;
    _buttonSeeAll.enabled = items.count>3;
    if (_buttonSeeAll.enabled) {
        [_buttonSeeAll setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"PROJECTBIDDER_VIEW_BIDDERS"), items.count ]forState:UIControlStateNormal];
    } else {
        _buttonSeeAll.hidden = YES;
    }

    [_collectionView reloadData];
}


#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectBiddersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DB_Bid *bidItem = collectionItems[indexPath.row];
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
    
    NSInteger count = collectionItems.count;
    return count>3?3:count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    cellHeight = kDeviceHeight * 0.1;
    size = CGSizeMake( _collectionView.frame.size.width, cellHeight);
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
    [self.projectBidderDelegate tappedProjectBidder:collectionItems[indexPath.row]];
}

#pragma mark - View

- (void)layoutSubviews {
    
    if (collectionItems.count == 0) {
        constraintHeight.constant = 0;
    } else if (cellHeight>0) {
        
        NSInteger count = collectionItems.count>3?3:collectionItems.count;
        constraintHeight.constant = (count * cellHeight) + _titleView.frame.size.height + _buttonSeeAll.frame.size.height;
    }
}

- (void)removeFromSuperview {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    [super removeFromSuperview];
}

- (IBAction)tappedButtonSeeAll:(id)sender {
    [self.projectBidderDelegate tappedProjectBidSeeAll:self];
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
        
        CGRect rect = [controller getViewPositionFromViewController:[cell.actionView trackButton] controller:[self.projectBidderDelegate projectBidderViewController]];
        controller.popupRect = rect;
        controller.popupWidth = 0.98;
        controller.isGreyedBackground = YES;
        controller.customCollectionViewDelegate = self;
        controller.popupViewControllerDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [[self.projectBidderDelegate projectBidderViewController] presentViewController:controller animated:NO completion:nil];
        
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
    CGRect rect = [controller getViewPositionFromViewController:[cell.actionView shareButton] controller:[self.projectBidderDelegate projectBidderViewController] ];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [[self.projectBidderDelegate projectBidderViewController] presentViewController:controller animated:NO completion:nil];
    
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
    
    
    [[self.projectBidderDelegate projectBidderViewController] presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)didTappedNewTrackingList:(id)sender {
    
    [[self.projectBidderDelegate projectBidderViewController] dismissViewControllerAnimated:NO completion:^{
        [self PopupViewControllerDismissed];
        [self getNewTrackingList];
    }];
}

@end

//
//  ProjectDetailViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/12/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectDetailViewController.h"

#import "ProjectHeaderView.h"
#import "ProjectStateView.h"
#import "projectHeaderConstants.h"
#import "projectDetailConstants.h"
#import "CustomEntryField.h"
#import "SeeAllView.h"
#import "NotesView.h"
#import "PariticpantsView.h"
#import "ProjectBidderView.h"
#import "MapViewController.h"
#import "PushZoomAnimator.h"
#import "CompanyDetailViewController.h"

#import "DB_Project.h"
#import "DB_Company.h"
#import "DB_Participant.h"

#import "ProjectDetailStateViewController.h"
#import "ProjectListViewController.h"
#import "ProjectShareViewController.h"
#import "BidderListViewController.h"
#import "ParticipantsListViewController.h"
#import "PopupViewController.h"
#import "TrackingListCellCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"

typedef enum {
    ProjectDetailPopupModeTrack,
    ProjectDetailPopupModeShare
} ProjectDetailPopupMode;

@interface ProjectDetailViewController ()<ProjectStateViewDelegate, ProjectHeaderDelegate,PariticipantsDelegate, ProjectBidderDelegate,ProjectDetailStateViewControllerDelegate,ProjectTrackListViewControllerDelegate,ProjectShareListViewControllerDelegate, SeeAllViewDelegate, CustomCollectionViewDelegate, TrackingListViewDelegate, PopupViewControllerDelegate>{

    BOOL isShownContentAdjusted;
    BOOL isProjectDetailStateHidden;
    BOOL usePushZoom;
    NSMutableArray *bidItems;
    NSMutableArray *participants;
    NSString *projectTitle;
    NSArray *trackItemRecord;
    NSNumber *recordId;
    ProjectDetailPopupMode popupMode;
}

//Views
@property (weak, nonatomic) IBOutlet ProjectHeaderView *headerView;
@property (weak, nonatomic) IBOutlet ProjectStateView *projectState;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet SeeAllView *seeAllView;
@property (weak, nonatomic) IBOutlet NotesView *notesView;
@property (weak, nonatomic) IBOutlet PariticpantsView *participantsView;
@property (weak, nonatomic) IBOutlet ProjectBidderView *projectBidder;
@property (weak, nonatomic) IBOutlet UIView *seeAllViewContainer;

//Fields
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldCounty;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldProjectId;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldAddress;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldProjectType;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldEstLow;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldEstHigh;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldStage;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldDateAdded;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldBidDate;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldTargetStartDate;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldTargetFinishDate;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldLastUpdated;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldValue;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldJurisdiction;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldBuildingOrHighway;

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldCounty;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldEstLow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldEstHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldStage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldNotes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldParticipants;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectBidder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSeeAllViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldDateAdded;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldBidDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTargetStartDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTargerFinishDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLastUpdated;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldJurisdiction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldBuildingOrHighway;


//Actions
- (IBAction)tappedBackButton:(id)sender;
@end

@implementation ProjectDetailViewController

@synthesize previousRect;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.hidden = YES;
    _containerView.backgroundColor = PROJECT_DETAIL_CONTAINER_BG_COLOR;
    _scrollView.backgroundColor = PROJECT_DETAIL_CONTAINER_BG_COLOR;
    _headerView.projectHeaderDelegate = self;
    [_fieldCounty changeConstraintHeight: _constraintFieldCounty];
    [_fieldProjectId changeConstraintHeight: _constraintFieldProjectID];
    [_fieldAddress changeConstraintHeight: _constraintFieldAddress];
    [_fieldProjectType changeConstraintHeight: _constraintFieldProjectType];
    [_fieldEstLow changeConstraintHeight: _constraintFieldEstLow];
    [_fieldEstHigh changeConstraintHeight: _constraintFieldEstHigh];
    [_fieldDateAdded changeConstraintHeight:_constraintFieldDateAdded];
    [_fieldBidDate changeConstraintHeight:_constraintFieldBidDate];
    [_fieldTargetStartDate changeConstraintHeight:_constraintTargetStartDate];
    [_fieldTargetFinishDate changeConstraintHeight:_constraintTargerFinishDate];
    [_fieldLastUpdated changeConstraintHeight:_constraintLastUpdated];
    [_fieldValue changeConstraintHeight:_constraintFieldValue];
    [_fieldJurisdiction changeConstraintHeight:_constraintFieldJurisdiction];
    [_fieldBuildingOrHighway changeConstraintHeight:_constraintFieldBuildingOrHighway];
    [_fieldStage changeConstraintHeight: _constraintFieldStage];
    [_notesView changeConstraintHeight:_constraintFieldNotes];
    [_participantsView changeConstraintHeight:_constraintFieldParticipants];
    [_projectBidder changeConstraintHeight:_constraintFieldProjectBidder];
    
    _constraintSeeAllViewContainer.constant = 0;
    
    _projectBidder.projectBidderDelegate = self;
    _participantsView.pariticipantsDelegate = self;
    _projectState.projectStateViewDelegate = self;
    _seeAllView.seeAllViewDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (IBAction)tappedBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailsFromProject:(DB_Project*)record {
    
    DB_Project *project = record;
    projectTitle = project.title;
    recordId = project.recordId;
    
    NSString *address1 = project.address1 == nil ? @"": project.address1;
    [_headerView setHeaderInfo:@{PROJECT_GEOCODE_LAT:project.geocodeLat, PROJECT_GEOCODE_LNG:project.geocodeLng, PROJECT_TITLE:project.title, PROJECT_LOCATION: address1}];
    
    [_fieldCounty setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_COUNTY") line1Text:project.county line2Text:nil];
    
    NSString *projectId = [NSString stringWithFormat:@"%@ %@", project.dodgeNumber, (project.dodgeVersion == nil ? @"":[NSString stringWithFormat:@"(v%@)", project.dodgeVersion]) ];
    [_fieldProjectId setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_ID") line1Text:projectId line2Text:nil];

    NSString *address = [project fullAddress];
    [_fieldAddress setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ADDRESS") line1Text:address line2Text:nil];
    
    [_fieldProjectType setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_TYPE") line1Text:[project getProjectType] line2Text:nil];
    
    [_notesView setNotes:project.notes];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [_fieldEstLow setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ESTLOW") line1Text:[project estLowAmountWithCurrency] line2Text:nil];

    [_fieldEstHigh setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ESTHIGH") line1Text:[project estHighAmountWithCurrency] line2Text:nil];

    [_fieldStage setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_STAGE") line1Text:project.projectStageName line2Text:nil];
    
    [_fieldDateAdded setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_DATE_ADDED") line1Text:[project dateAddedString] line2Text:nil];
    
    [_fieldBidDate setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_BIDDATE") line1Text:[project bidDateString] line2Text:nil];
    
    [_fieldTargetStartDate setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_START_DATE") line1Text:[project startDateString] line2Text:nil];
    
    [_fieldTargetFinishDate setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_FINISH_DATE") line1Text:[project finishDateString] line2Text:nil];
    
    [_fieldLastUpdated setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_LAST_UPDATE") line1Text:[project lastUpdateDateString] line2Text:nil];
    
    [_fieldValue setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_VALUE") line1Text:@"$ 0" line2Text:nil];
    
    [_fieldJurisdiction setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_JURISDICTION") line1Text:project.ownerClass line2Text:nil];
    
    [_fieldBuildingOrHighway setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_B_OR_H") line1Text:project.primaryProjectTypeBuildingOrHighway line2Text:nil];
    
    bidItems =  [project.relationshipBid allObjects] != nil? [[project.relationshipBid allObjects] mutableCopy] : [NSMutableArray new];
    [_projectBidder setItems:bidItems];
 
    participants = [project.relationshipParticipants allObjects] != nil? [[project.relationshipParticipants allObjects] mutableCopy]:[NSMutableArray new];
    [_participantsView setItems:participants];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self layoutContentView];
}

- (void)layoutContentView {
    if (!isShownContentAdjusted) {

        isShownContentAdjusted = YES;
        CGFloat contentHeight = _projectBidder.frame.size.height + _projectBidder.frame.origin.y + (kDeviceHeight * 0.05);
        _constraintContentHeight.constant = contentHeight;
        _scrollView.contentSize = CGSizeMake(kDeviceWidth, contentHeight);
    }

}

- (void)selectedStateViewItem:(StateView)stateView view:(UIView *)view{
    
    if (stateView == StateViewShare) {
        
        [self showShareListMenu:view];
        
    }else if (stateView == StateViewTrack){
        
        [self tappedProjectTrackListButton:view];
       
    }else if (stateView == StateViewHide){
 
        [self tappedProjectDetailStateHideButton];
        
    }
}

- (void)tappedProjectMapViewLat:(CGFloat)lat lng:(CGFloat)lng {
    usePushZoom = YES;
    MapViewController *map = [MapViewController new];
    [map setLocationLat:lat lng:lng];
    [self.navigationController pushViewController:map animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationObjectForOperation:(UINavigationControllerOperation)operation {
    
    if (usePushZoom) {
        PushZoomAnimator *animator = [[PushZoomAnimator alloc] init];
        animator.willPop = operation!=UINavigationControllerOperationPush;
        if (!animator.willPop){
            animator.startRect = [_headerView mapFrame];
            animator.endRect = self.view.frame;
        } else {
            animator.startRect = self.view.frame;
            animator.endRect = [_headerView mapFrame];
        }
        return animator;
    }
    return nil;
}

- (void)tappedParticipant:(id)object {
    DB_Participant *record = object;
    usePushZoom = NO;
    _participantsView.userInteractionEnabled = NO;
    [[DataManager sharedManager] companyDetail:record.companyId success:^(id object) {
        id returnObject = object;
        [[DataManager sharedManager] companyProjectBids:record.companyId success:^(id object) {
            CompanyDetailViewController *controller = [CompanyDetailViewController new];
            controller.view.hidden = NO;
            [controller setInfo:returnObject];
            [self.navigationController pushViewController:controller animated:YES];
            _participantsView.userInteractionEnabled = YES;
        } failure:^(id object) {
            _participantsView.userInteractionEnabled = YES;
        }];
    } failure:^(id object) {
        _participantsView.userInteractionEnabled = YES;
    }];

}

- (void)tappedParticipantSeeAll {
    usePushZoom = NO;
    ParticipantsListViewController *controller = [ParticipantsListViewController new];
    controller.collectionItems = participants;
    controller.projectName = projectTitle;
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)tappedSeeAllView:(id)object {
    [UIView animateWithDuration:0.25 animations:^{
        _constraintSeeAllViewContainer.constant = _seeAllView.isExpanded?_fieldBuildingOrHighway.frame.origin.y + _fieldBuildingOrHighway.frame.size.height : 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            isShownContentAdjusted = NO;
            [self layoutContentView];
        }
    }];
}

#pragma mark - Delegate and Share List Method

- (void)PopupViewControllerDismissed {
    [_projectState clearSelection];
}

-(void)tappedDismissedProjectShareList{
    
}


- (void)showShareListMenu:(UIView*)view{
    
    /*
    ProjectShareViewController *controller = [ProjectShareViewController new];
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.projectShareListViewControllerDelegate = self;
    [controller setProjectState:_projectState];
    [self presentViewController:controller  animated:YES completion:nil];
     */
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:view controller:self];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:NO completion:nil];
    
    
}

#pragma mark - Project List Delegate and Method

-(void)tappedDismissedProjectTrackList{
    
    [_projectState clearSelection];
}

- (void)tappedProjectTrackListButton:(UIView*)view{
    
    /*
    ProjectListViewController *controller = [ProjectListViewController new];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [controller setProjectStateViewFrame:_projectState];
    controller.projectTrackListViewControllerDelegate = self;
    [self presentViewController:controller  animated:YES completion:nil];
     */
    popupMode = ProjectDetailPopupModeTrack;
    [[DataManager sharedManager] projectAvailableTrackingList:recordId success:^(id object) {
        
        trackItemRecord = object;
        PopupViewController *controller = [PopupViewController new];
        CGRect rect = [controller getViewPositionFromViewController:view controller:self];
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

#pragma mark - Project Detail State ViewController Methods And Delegate

- (void)tappedProjectDetailStateHideButton{
    ProjectDetailStateViewController *controller = [[ProjectDetailStateViewController alloc] initWithNibName:@"ProjectDetailStateViewController" bundle:nil];
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.projectDetailStateViewControllerDelegate = self;
    
    [self presentViewController:controller  animated:YES completion:nil];
    
}

- (void)tappedDismissed{
    
    [_projectState clearSelection];
}

- (void)tappedProjectBidder:(id)object {
    DB_Bid *bid = object;
    usePushZoom = NO;
    _projectBidder.userInteractionEnabled = NO;
    [[DataManager sharedManager] companyDetail:bid.relationshipCompany.recordId success:^(id object) {
        id returnObject = object;
        [[DataManager sharedManager] companyProjectBids:bid.relationshipCompany.recordId success:^(id object) {

            CompanyDetailViewController *controller = [CompanyDetailViewController new];
            controller.view.hidden = NO;
            [controller setInfo:returnObject];
            [self.navigationController pushViewController:controller animated:YES];
            _projectBidder.userInteractionEnabled = YES;
        } failure:^(id object) {
            _projectBidder.userInteractionEnabled = YES;
        }];
    } failure:^(id object) {
        _projectBidder.userInteractionEnabled = YES;
    }];
}

- (void)tappedProjectBidSeeAll:(id)object {
    usePushZoom = NO;
    BidderListViewController *controller = [BidderListViewController new];
    controller.collectionItems = bidItems;
    controller.projectName = projectTitle;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - CustomCollectionView Delegate

- (void)collectionViewItemClassRegister:(id)customCollectionView {
    
    CustomCollectionView *collectionView = (CustomCollectionView*)customCollectionView;
    switch (popupMode) {
        
        case ProjectDetailPopupModeTrack: {
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
            return [collectionView dequeueReusableCellWithReuseIdentifier:[[TrackingListCellCollectionViewCell class] description]forIndexPath:indexPath];
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
    
    return popupMode == ProjectDetailPopupModeTrack?1:2;

}

- (NSInteger)collectionViewSectionCount {
    return 1;
}

- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath*)indexPath cargo:(id)cargo {

    switch (popupMode) {

        case ProjectDetailPopupModeTrack: {
            CGFloat defaultHeight = kDeviceHeight * 0.08;
            CGFloat cellHeight = kDeviceHeight * 0.06;
            defaultHeight = defaultHeight+ (trackItemRecord.count*cellHeight);
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

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    [[DataManager sharedManager] featureNotAvailable];
}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {

    switch (popupMode) {
        
        case ProjectDetailPopupModeTrack: {

            TrackingListCellCollectionViewCell *cellItem = (TrackingListCellCollectionViewCell*)cell;
            cellItem.headerDisabled = YES;
            cellItem.trackingListViewDelegate = self;
            [cellItem setInfo:trackItemRecord withTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_TITLE_TRACKING_LABEL_TEXT")];
            
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
    [[DataManager sharedManager] featureNotAvailable];
}

@end

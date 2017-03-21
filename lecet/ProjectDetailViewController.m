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
#import "BidderListViewController.h"
#import "ParticipantsListViewController.h"
#import "PopupViewController.h"
#import "TrackingListCellCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"

#import "MobileProjectAddNoteViewController.h"
#import "ImageNotesView.h"
#import "PhotoViewController.h"
#import "CustomCameraViewController.h"

#define PROJECT_DETAIL_CONTAINER_BG_COLOR           RGB(245, 245, 245)
#define VIEW_TAB_BG_COLOR                           RGB(19, 86, 141)
#define BUTTON_TITLE_COLOR                          RGB(255, 255, 255)
#define INDICATOR_COLOR                             RGB(248, 153, 0)
#define PROJECT_NOTES_BUTTON_SHADOW_COLOR           RGB(0, 0, 0)
#define PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE      RGB(0, 56, 114)

#define PROJECT_STATE_BUTTON_TEXT_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)
#define BUTTON_TITLE_FONT                           fontNameWithSize(FONT_NAME_LATO_BOLD, 11)

typedef enum {
    ProjectDetailPopupModeTrack,
    ProjectDetailPopupModeShare
} ProjectDetailPopupMode;

@interface ProjectDetailViewController ()<ProjectStateViewDelegate, ProjectHeaderDelegate,PariticipantsDelegate, ProjectBidderDelegate,ProjectDetailStateViewControllerDelegate, SeeAllViewDelegate, CustomCollectionViewDelegate, TrackingListViewDelegate, PopupViewControllerDelegate, ImageNotesViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomCameraViewControllerDelegate,MobileProjectAddNoteViewControllerDelegate>{

    BOOL isShownContentAdjusted;
    BOOL isProjectDetailStateHidden;
    BOOL usePushZoom;
    NSMutableArray *bidItems;
    NSMutableArray *participants;
    NSString *projectTitle;
    NSArray *trackItemRecord;
    NSNumber *recordId;
    ProjectDetailPopupMode popupMode;
    NSMutableArray *imageNotesItems;
    BOOL isFlashOn;
    DB_Project *referenceProject;
}

@property (strong, nonatomic) UIImagePickerController *picker;

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

@property (weak, nonatomic) IBOutlet UIView *viewTab;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonNotes;
@property (weak, nonatomic) IBOutlet UIView *viewIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintIndicator;
@property (weak, nonatomic) IBOutlet UIView *NotesContainerView;
@property (weak, nonatomic) IBOutlet UIView *notesButtonContainer;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddNote;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddImage;

@property (weak, nonatomic) IBOutlet ImageNotesView *imageNoteView;
@property (weak, nonatomic) IBOutlet UIButton *buttonEditProject;
@property (strong,nonatomic) CustomCameraViewController *customCameraVC;

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
    self.NotesContainerView.backgroundColor = PROJECT_DETAIL_CONTAINER_BG_COLOR;
    _headerView.projectHeaderDelegate = self;
    self.imageNoteView.imageNotesViewDelegate = self;
    
    self.buttonEditProject.hidden = YES;
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
    
    self.viewTab.backgroundColor = VIEW_TAB_BG_COLOR;
    [self.buttonLocation setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_LOCATION_INFO") forState:UIControlStateNormal];
    [self.buttonLocation setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
    self.buttonLocation.titleLabel.font = BUTTON_TITLE_FONT;
    
    [self.buttonNotes setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_NOTES") forState:UIControlStateNormal];
    [self.buttonNotes setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
    self.buttonNotes.titleLabel.font = BUTTON_TITLE_FONT;
    
    self.viewIndicator.backgroundColor = INDICATOR_COLOR;
    self.NotesContainerView.hidden = YES;
    
    self.notesButtonContainer.layer.shadowColor = [PROJECT_NOTES_BUTTON_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.notesButtonContainer.layer.shadowRadius = 2;
    self.notesButtonContainer.layer.shadowOffset = CGSizeMake(2, 2);
    self.notesButtonContainer.layer.shadowOpacity = 0.25;
    self.notesButtonContainer.layer.masksToBounds = NO;
    
    [self.buttonAddNote setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ADD_NOTE") forState:UIControlStateNormal];
    [self setupButton:self.buttonAddNote];
    [self.buttonAddNote setTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE forState:UIControlStateNormal];
   
    [self.buttonAddImage setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ADD_IMAGE") forState:UIControlStateNormal];
    [self setupButton:self.buttonAddImage];
    [self.buttonAddImage setTitleColor:PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE forState:UIControlStateNormal];
    
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
    
    
    referenceProject = project;
    [self loadNotes];
    
    [[DataManager sharedManager] userActivitiesForRecordId:recordId viewType:0 success:^(id object) {
        
    } failure:^(id object) {
        
    }];
    
//    NSString *address1 = project.address1 == nil ? @"": project.address1;
//    [_headerView setHeaderInfo:@{PROJECT_GEOCODE_LAT:project.geocodeLat, PROJECT_GEOCODE_LNG:project.geocodeLng, PROJECT_TITLE:project.title, PROJECT_LOCATION: address1}];
    
    [_fieldCounty setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_COUNTY") line1Text:project.county line2Text:nil];
    
    NSString *projectId = [NSString stringWithFormat:@"%@ %@", project.dodgeNumber, (project.dodgeVersion == nil ? @"":[NSString stringWithFormat:@"(v%@)", project.dodgeVersion]) ];
    [_fieldProjectId setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_ID") line1Text:projectId line2Text:nil];

    NSString *address = [project fullAddress];
    [_fieldAddress setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ADDRESS") line1Text:address line2Text:nil];
    
    [_fieldProjectType setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_TYPE") line1Text:[project getProjectType] line2Text:nil];
    
    NSString *notes = nil;
    
    if (project.projectNotes != nil) {
        notes = project.projectNotes;
        
        if (project.stdIncludes != nil) {
            notes = [notes stringByAppendingString:@"\n"];
        }
    }
    
    if (project.stdIncludes != nil) {
        
        if (notes == nil) {
            notes = @"";
        }
        
        notes = [notes stringByAppendingString:project.stdIncludes];
    }
    
    [_notesView setNotes:notes];
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
    
    //[_fieldJurisdiction setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_JURISDICTION") line1Text:@"" line2Text:nil];
    
    [_fieldBuildingOrHighway setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_B_OR_H") line1Text:project.primaryProjectTypeBuildingOrHighway line2Text:nil];
    
    bidItems =  [project.relationshipBid allObjects] != nil? [[project.relationshipBid allObjects] mutableCopy] : [NSMutableArray new];
    
    [self dataSortingLowestToHighestBid];
    
    [_projectBidder setItems:bidItems];
 
    participants = [project.relationshipParticipants allObjects] != nil? [[project.relationshipParticipants allObjects] mutableCopy]:[NSMutableArray new];
    [_participantsView setItems:participants];
    
    [[DataManager sharedManager] projectJurisdiction:recordId success:^(id object) {
  
        NSArray *districts = object;
        NSString *jurisdiction = @"";
        int index = 0;
        for (NSDictionary *district in districts) {
     
            NSDictionary *dictrictCouncil = district[@"districtCouncil"];
            NSString *current = dictrictCouncil[@"abbreviation"];
            
            if (current.length>0) {
                jurisdiction = [jurisdiction stringByAppendingString:current];
                
                if (index<(districts.count-1)) {
                    jurisdiction = [jurisdiction stringByAppendingString:@", "];
                    
                }
            }
   
            index++;
        }
        
        
        /*
        NSArray *regions = [DerivedNSManagedObject objectOrNil:dict[@"regions"]];
        
        if (regions != nil) {
            NSString *current = @"abbreviation";
            for (NSDictionary *region in regions) {
                
                current = region[@""]
                if (current.length>0) {
                    jurisdiction = [jurisdiction stringByAppendingString:@","]
                }
                
            }
        }
        */
        [_fieldJurisdiction setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_JURISDICTION") line1Text:jurisdiction line2Text:nil];
        
        isShownContentAdjusted = NO;
        [self layoutContentView];
    } failure:^(id object) {
        
    }];

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
        CompanyDetailViewController *controller = [CompanyDetailViewController new];
        controller.view.hidden = NO;
        [controller setInfo:returnObject];
        [self.navigationController pushViewController:controller animated:YES];
        _participantsView.userInteractionEnabled = YES;
        
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
    
    popupMode = ProjectDetailPopupModeTrack;
    [[DataManager sharedManager] projectAvailableTrackingList:recordId success:^(id object) {
        
        trackItemRecord = object;
        
        if (trackItemRecord.count>0) {
            PopupViewController *controller = [PopupViewController new];
            CGRect rect = [controller getViewPositionFromViewController:view controller:self];
            controller.popupRect = rect;
            controller.popupWidth = 0.98;
            controller.isGreyedBackground = YES;
            controller.customCollectionViewDelegate = self;
            controller.popupViewControllerDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:NO completion:nil];
        } else {
            
            [_projectState clearSelection];
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"NO_TRACKING_LIST")];
        }
        
    } failure:^(id object) {
        
    }];

    
}

#pragma mark - Project Detail State ViewController Methods And Delegate

- (void)tappedProjectDetailStateHideButton{
    
    ProjectDetailStateViewController *controller = [ProjectDetailStateViewController new];
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.projectDetailStateViewControllerDelegate = self;
    
    [self presentViewController:controller  animated:YES completion:nil];
    
}

- (void)tappedDismissed{
    
    [_projectState clearSelection];
}

- (void)tappedHideButton {
    
    [[DataManager sharedManager] hideProject:recordId success:^(id object) {
        
        [_projectState clearSelection];

        [self tappedBackButton:nil];
        
    } failure:^(id object) {
        
    }];
}

- (void)tappedProjectBidder:(id)object {
    DB_Bid *bid = object;
    usePushZoom = NO;
    _projectBidder.userInteractionEnabled = NO;
    [[DataManager sharedManager] companyDetail:bid.relationshipCompany.recordId success:^(id object) {
        id returnObject = object;
        
        CompanyDetailViewController *controller = [CompanyDetailViewController new];
        controller.view.hidden = NO;
        [controller setInfo:returnObject];
        [self.navigationController pushViewController:controller animated:YES];
        _projectBidder.userInteractionEnabled = YES;

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
            defaultHeight = defaultHeight+ ((trackItemRecord.count<4?trackItemRecord.count:4.5)*cellHeight);
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

    if (popupMode == ProjectDetailPopupModeShare) {
        NSString *url = [kHost stringByAppendingString:[NSString stringWithFormat:kUrlProjectDetailShare, (long)recordId.integerValue]];
        
        
        if (indexPath.row == 0) {
            NSString *html = [NSString stringWithFormat:@"<HTML><BODY>DODGE NUMBER :<BR>%@ <BR>WEB LINK : <BR>%@ </BODY></HTML>", [_fieldProjectId getLine], url];
            [[DataManager sharedManager] sendEmail:html];
            
        } else {
            
            NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"COPY_TO_CLIPBOARD_PROJECT"), [_fieldProjectId getLine]];
            [[DataManager sharedManager] copyTextToPasteBoard:url withMessage:message];
            
        }
    }
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
    
    NSIndexPath *indexPath = object;
    NSDictionary *dict = trackItemRecord[indexPath.row];
    [[DataManager sharedManager] projectAddTrackingList:dict[@"id"] recordId:recordId success:^(id object) {
        [[DataManager sharedManager] dismissPopup];
    } failure:^(id object) {
        
    }];
}

- (void)dataSortingLowestToHighestBid{
    
    NSArray *array = [bidItems copy];
    NSArray *sortedArray = [array sortedArrayUsingComparator: ^(DB_Bid *obj1, DB_Bid *obj2) {
        int objOne = (int)[obj1.rank integerValue];
        int objTwo = (int)[obj2.rank integerValue];
        
        if (objOne == 0 && objTwo == 0)
        {
            return (NSComparisonResult)NSOrderedSame;
        }
        if (objOne  == 0)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (objTwo  == 0)
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (objOne  > objTwo )
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (objOne < objTwo )
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    bidItems = [sortedArray mutableCopy];
    
}

#pragma mark - Notes and Images

- (IBAction)tappedButtonTab:(id)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.constraintIndicator.constant = [sender isEqual:self.buttonLocation]?0:kDeviceWidth * 0.5;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.NotesContainerView.hidden = [sender isEqual:self.buttonLocation];
            if (!self.NotesContainerView.hidden) {
                [self loadNotes];
            }
        }
    }];
}

- (void)loadNotes {
    if (imageNotesItems == nil) {
        imageNotesItems = [NSMutableArray new];
        [[DataManager sharedManager] projectUserNotes:recordId success:^(id object) {

            NSArray *notes = object;
            for (NSDictionary *item in notes) {
                NSMutableDictionary *mutableItem = [item mutableCopy];
                mutableItem[@"cellType"] = @"note";
                [imageNotesItems addObject:mutableItem];
            }
            [self loadImages];
        } failure:^(id object) {
            
        }];
    }

}

- (void)loadImages {
    [[DataManager sharedManager] projectUserImages:recordId success:^(id object) {
      
        NSArray *images = object;
        for (NSDictionary *item in images) {
            NSMutableDictionary *mutableItem = [item mutableCopy];
            mutableItem[@"cellType"] = @"image";
            [imageNotesItems addObject:mutableItem];
        }
        [self showImageNotes];
    } failure:^(id object) {
        
    }];
}

- (void)showImageNotes {
    self.imageNoteView.items = imageNotesItems;
    [self.imageNoteView reloadData];
    
    self.buttonEditProject.hidden = YES;
    if (referenceProject.dodgeNumber != nil) {
        _headerView.pinType = pinTypeOrange;
        
        if (imageNotesItems.count>0) {
            _headerView.pinType = pinTypeOrageUpdate;
        }
    } else {
        self.buttonEditProject.hidden = NO;
        _headerView.pinType = pinTypeUser;
        if (imageNotesItems.count>0) {
            _headerView.pinType = pinTypeUserUpdate;
        }
    }

    NSString *address1 = referenceProject.address1 == nil ? @"": referenceProject.address1;
    [_headerView setHeaderInfo:@{PROJECT_GEOCODE_LAT:referenceProject.geocodeLat, PROJECT_GEOCODE_LNG:referenceProject.geocodeLng, PROJECT_TITLE:referenceProject.title, PROJECT_LOCATION: address1}];

}

- (void)setupButton:(UIButton*)button {
    button.titleLabel.font = PROJECT_STATE_BUTTON_TEXT_FONT;
    button.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    button.layer.borderWidth = 0.5;
    button.layer.masksToBounds = YES;
}

- (IBAction)tappedButtonAddNote:(id)sender {
    
    MobileProjectAddNoteViewController *controller = [MobileProjectAddNoteViewController new];
    controller.projectID = recordId;
    controller.mobileProjectAddNoteViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tappedUpdateUserNotes {
    imageNotesItems = nil;
    [self loadNotes];
}

- (IBAction)tappedButtonAddImage:(id)sender {
    [self showCustomCamera];
}

#pragma mark - ImageNoteViewDelegate
- (void)viewNoteAndImage:(NSString *)title detail:(NSString *)detail image:(UIImage *)image {
    
    if (image != nil) {
        PhotoViewController *controller = [PhotoViewController new];
        controller.image = image;
        controller.photoTitle = title;
        controller.text = detail;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Custom Camera Method

- (void)showCustomCamera {
    
    [self showCamera];
}

- (void)showCamera{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    
    
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.extendedLayoutIncludesOpaqueBars = YES;
    self.picker.edgesForExtendedLayout = YES;
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
    self.picker.cameraViewTransform = translate;
    
    self.customCameraVC =  [CustomCameraViewController new];
    self.customCameraVC.customCameraViewControllerDelegate = self;
    [self addChildViewController:self.customCameraVC];
    
    UIView *customView = self.customCameraVC.view;
    customView.frame = self.picker.view.frame;
    self.picker.cameraOverlayView = customView;
    self.picker.delegate = self;
    [self presentImagePickerController:self.picker];
    
}

- (void)presentImagePickerController:(UIViewController *)pickerController
{
    if (self.presentedViewController) {
        [self.presentedViewController presentViewController:pickerController animated:YES completion:^{}];
    } else {
        [self.navigationController presentViewController:pickerController animated:YES completion:^{}];
    }
}


#pragma mark - Camera Deleggare

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image =  [info valueForKey:UIImagePickerControllerOriginalImage];
    self.customCameraVC.capturedImage.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

#pragma mark - CustomCameraViewController Delegate

- (void)tappedCameraSwitch{
    [UIView transitionWithView:self.picker.view duration:1.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        if (self.picker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
            self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        else {
            self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
    }
    completion:nil];
}

- (void)tapppedTakePhoto {
    [self.picker takePicture];
    
}

- (void)tappedFlash {
    isFlashOn = !isFlashOn;
    self.picker.cameraFlashMode = isFlashOn ? UIImagePickerControllerCameraFlashModeOn:UIImagePickerControllerCameraFlashModeOff;
}

- (void)tappedCancel {
    [self.picker dismissViewControllerAnimated:YES completion:^{
        self.customCameraVC.customCameraViewControllerDelegate = nil;
    }];
}

- (void)customCameraControlListDidSelect:(id)info {
    
}


@end

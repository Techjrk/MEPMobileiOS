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

#import "NewProjectViewController.h"
#import "MobileProjectAddNoteViewController.h"
#import "ImageNotesView.h"
#import "PhotoViewController.h"
#import "CustomCameraViewController.h"
#import <Photos/Photos.h>
#import "CustomPhotoLibraryViewController.h"
#import "PhotoShutterViewController.h"
#import "NewProjectViewController.h"
#import "DMD_LITE.h"
#import "PanoramaSceneViewController.h"

#import "DMDViewerController.h"
#import <OpenGLES/ES2/gl.h>
#import <AssetsLibrary/AssetsLibrary.h>

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

@interface ProjectDetailViewController ()<ProjectStateViewDelegate, ProjectHeaderDelegate,PariticipantsDelegate, ProjectBidderDelegate,ProjectDetailStateViewControllerDelegate, SeeAllViewDelegate, CustomCollectionViewDelegate, TrackingListViewDelegate, PopupViewControllerDelegate, ImageNotesViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomCameraViewControllerDelegate,MobileProjectAddNoteViewControllerDelegate,CustomPhotoLibraryViewControllerDelegate, NewProjectViewControllerDelegate>{

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
    UIImage *capturedImage;
    NSDictionary *imageItemsToBeUpdated;
    NSNumber *jurisdictionIdentifier;
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
- (IBAction)tappedEditButton:(id)sender;

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

- (IBAction)tappedEditButton:(id)sender {

    CLLocation *location = [[CLLocation alloc] initWithLatitude:referenceProject.geocodeLat.floatValue longitude:referenceProject.geocodeLng.floatValue];

    NewProjectViewController *controller = [NewProjectViewController new];
    controller.location = location;
    controller.pinType = _headerView.pinType;
    controller.projectViewControllerDelegate = self;
    controller.updateProject = YES;
    [controller setProjectTitle:referenceProject.title];
    controller.projectId = referenceProject.recordId;
    [controller setType: referenceProject.primaryProjectTypeId];
    
    [controller setStage: referenceProject.projectStageId];
    
    [controller setDate: referenceProject.targetStartDate];
    
    [controller setJurisdiction:jurisdictionIdentifier];

    [self.navigationController pushViewController:controller animated:NO];
}

- (void)tappedSavedNewProject:(id)object {
    
    [[DataManager sharedManager] updateProject:recordId project:object success:^(id object) {
        
    } failure:^(id object) {
        
    }];
    
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
    
    NSString *projectId = nil;
    
    NSString *dodgeNumber = [DerivedNSManagedObject objectOrNil:project.dodgeNumber];
    
    if (dodgeNumber) {
        projectId = [NSString stringWithFormat:@"%@ %@", project.dodgeNumber, (project.dodgeVersion == nil ? @"":[NSString stringWithFormat:@"(v%@)", project.dodgeVersion]) ];
    }
    
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

            jurisdictionIdentifier = district[@"id"];
     
            NSDictionary *dictrictCouncil = district[@"districtCouncil"];
            NSString *current = [DerivedNSManagedObject objectOrNil:dictrictCouncil[@"abbreviation"]];
            
            if (current.length>0) {
                jurisdiction = [jurisdiction stringByAppendingString:current];
                
                if (index<(districts.count-1)) {
                    jurisdiction = [jurisdiction stringByAppendingString:@", "];
                    
                }
            }
   
            index++;
        }
        
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
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    NSArray *sorted = [imageNotesItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];

    self.imageNoteView.items = [sorted mutableCopy];
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
    
    NSString *title = [DerivedNSManagedObject objectOrNil:referenceProject.title];
    
    if (title == nil) {
        title = @"";
    }
    
    [_headerView setHeaderInfo:@{PROJECT_GEOCODE_LAT:referenceProject.geocodeLat, PROJECT_GEOCODE_LNG:referenceProject.geocodeLng, PROJECT_TITLE:title, PROJECT_LOCATION: address1}];

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

- (IBAction)tappedButtonAddImage:(id)sender {
    [self showCustomCamera];
}

#pragma mark - MobileProjectAddNoteViewControllerDelegate
- (void)tappedUpdateUserNotes {
    imageNotesItems = nil;
    imageItemsToBeUpdated = nil;
    [self loadNotes];
}

- (void)tappedCancelAddUpdateNoteImage{
    imageItemsToBeUpdated = nil;
}

- (void)tappedDeleteImage {
    //imageItemsToBeUpdated = nil;
    [self showCustomCamera];
}

#pragma mark - ImageNoteViewDelegate
- (void)viewNoteAndImage:(NSString *)title detail:(NSString *)detail image:(UIImage *)image imageNoteId:(NSNumber*)imageNoteId{
    
    if (image != nil) {
        
        if (image.size.width > (image.size.height*3) ) {

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                DMDViewerController *dmdViewerCtrlr= [[DMDViewerController alloc] init];
                dmdViewerCtrlr.photoTitle = title;
                dmdViewerCtrlr.text = detail;
                int fovx=360.0;
                BOOL isSpherical = NO;
                
                if(isSpherical?[dmdViewerCtrlr loadSphericalPanoramaFromUIImage:image]:[dmdViewerCtrlr loadPanoramaFromUIImage:
                                                                                        image fovx:fovx]) {
                    [self presentViewController:dmdViewerCtrlr animated:NO completion:nil];
                }
                else {
                    NSLog(@"Failed to load the given image.");
                }
            });

        } else {
            PhotoViewController *controller = [PhotoViewController new];
            controller.image = image;
            controller.photoTitle = title;
            controller.text = detail;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)updateNoteAndImage:(NSString *)title detail:(NSString *)detail image:(UIImage *)image itemID:(NSNumber *)itemID imageLink:(NSString *)link{
    
    if (title == nil) {
        title = @"";
    }
    if (image == nil) {
        MobileProjectAddNoteViewController *controller = [MobileProjectAddNoteViewController new];
        controller.projectID = recordId;
        controller.mobileProjectAddNoteViewControllerDelegate = self;
        controller.projectID = itemID;
        controller.itemsToBeUpdate = @{@"title":title,@"detail":detail};
        [self.navigationController pushViewController:controller animated:YES];
        
    } else {
        imageItemsToBeUpdated = @{@"title":title,@"detail":detail,@"itemID":itemID,@"imageLink":link};
        [self showCustomCamera];
    }
    
}

- (void)deleteNoteAndImage:(NSNumber *)itemsID image:(UIImage *)image{
    
    NSString *message = image != nil?NSLocalizedLanguage(@"PROJECT_DETAIL_DELETE_IMAGE"):NSLocalizedLanguage(@"PROJECT_DETAIL_DELETE_NOTES");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_BUTTON_YES")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          if (image != nil) {
                                                              [self deleteImage:itemsID];
                                                          } else {
                                                              [self deleteNotes:itemsID];
                                                          }
                                                      }];
    
    [alert addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_BUTTON_NO")
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction *action) {
                                                         
                                                     }];
    
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark - Request For Deleting Notes and Images

- (void)deleteNotes:(NSNumber *)notesID {
    [[DataManager sharedManager] deleteProjectUserNotes:notesID success:^(id object){
        imageNotesItems = nil;
        [self loadNotes];
    
    }failure:^(id object){
        
    }];
}

- (void)deleteImage:(NSNumber *)imageID {
    [[DataManager sharedManager] deleteProjectUserImage:imageID success:^(id object){
        //[self loadImages];
        imageNotesItems = nil;
        [self loadNotes];
    }failure:^(id object){
        
    }];
}

#pragma mark - Custom Camera Method

- (void)showCustomCamera {

    BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isCamera) {
        [self showCameraAnimated:YES];
    } else {
        [self showCustomLibraryAnimated:YES];
    }
}

- (void)showCustomLibraryAnimated:(BOOL)animate {
    CustomPhotoLibraryViewController *controller = [CustomPhotoLibraryViewController new];
    controller.customPhotoLibraryViewControllerDelegate = self;
    [self.navigationController presentViewController:controller animated:animate completion:nil];
}

- (void)showAddPhotoScreenItems:(NSDictionary *)items{
    MobileProjectAddNoteViewController *controller = [MobileProjectAddNoteViewController new];
    
    controller.isAddPhoto = YES;
    controller.capturedImage = capturedImage;
    controller.mobileProjectAddNoteViewControllerDelegate = self;
    if (items != nil && items.count > 0) {
        controller.itemsToBeUpdate = items;
        controller.projectID = items[@"itemID"];
    } else{
        controller.projectID = recordId;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showCameraAnimated:(BOOL)animate{
    
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.extendedLayoutIncludesOpaqueBars = YES;
    self.picker.edgesForExtendedLayout = YES;
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
    self.picker.cameraViewTransform = translate;
    self.customCameraVC =  [CustomCameraViewController new];
    self.customCameraVC.customCameraViewControllerDelegate = self;
    self.customCameraVC.controller = self.picker;
    [self addChildViewController:self.customCameraVC];
        
    UIView *customView = self.customCameraVC.view;
    customView.frame = self.picker.view.frame;
    self.picker.cameraOverlayView = customView;
    self.picker.delegate = self;
    [self presentImagePickerController:self.picker animated:YES];
   
    /*
    PhotoShutterViewController *controller = [PhotoShutterViewController new];
    [self.navigationController pushViewController:controller animated:YES];
    */
    
}

- (void)latestPhotoWithCompletion:(void (^)(UIImage *photo))completion
{
    
    ALAssetsLibrary *library=[[ALAssetsLibrary alloc] init];
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // For this example, we're only interested in the last item [group numberOfAssets]-1 = last.
        if ([group numberOfAssets] > 0) {
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:0
                                 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                     // The end of the enumeration is signaled by asset == nil.
                                     if (alAsset) {
                                         ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                         // Do something interesting with the AV asset.
                                         UIImage *img = [UIImage imageWithCGImage:[representation fullScreenImage]];
                                         
                                         // completion
                                         completion(img);
                                         
                                         // we only need the first (most recent) photo -- stop the enumeration
                                         *innerStop = YES;
                                     }
                                 }];
        }
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
    }];
    
    
}

- (void)presentImagePickerController:(UIViewController *)pickerController animated:(BOOL)animate
{
    if (self.presentedViewController) {
        [self.presentedViewController presentViewController:pickerController animated:animate completion:^{}];
    } else {
        [self.navigationController presentViewController:pickerController animated:animate completion:^{}];
    }
}


#pragma mark - Camera Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image =  [info valueForKey:UIImagePickerControllerOriginalImage];
    self.customCameraVC.capturedImage.image = image;
    capturedImage = image;
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        capturedImage = image;
        [self.picker dismissViewControllerAnimated:YES completion:^{
            [self showAddPhotoScreenItems:imageItemsToBeUpdated];
        }];
    } else {
        //capturedImage = [self reducedImageOnceCapture:image];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        });
        
        /*
        NSData *imageData =  UIImageJPEGRepresentation(image, 1);
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            if (assetURL)
            {
                [self latestPhotoWithCompletion:^(UIImage *photo) {
                    UIImageRenderingMode renderingMode = /* DISABLES CODE */ //(YES) ? UIImageRenderingModeAlwaysOriginal : UIImageRenderingModeAlwaysTemplate;
                    //capturedImage  = [photo imageWithRenderingMode:renderingMode];
        /*
                }];
            }
            else if (error)
            {
                if (error.code == ALAssetsLibraryAccessUserDeniedError || error.code == ALAssetsLibraryAccessGloballyDeniedError)
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Permission needed to access camera roll." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }
        }];
        */
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        imageItemsToBeUpdated = nil;
    }];
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
    [self.customCameraVC setFlashOn:isFlashOn];
}

- (void)tappedCancel {
    [self.picker dismissViewControllerAnimated:YES completion:^{
        self.customCameraVC.customCameraViewControllerDelegate = nil;
    }];
}

- (void)customCameraControlListDidSelect:(id)info {
    if (info != nil && ![info isEqual:@""]) {
        CameraControlListViewItems items = (CameraControlListViewItems)[info[@"type"] intValue];
        switch (items) {
            case CameraControlListViewPreview : {
                
                break;
            }
            case CameraControlListViewUse: {
                if (self.picker) {
                    [self.picker dismissViewControllerAnimated:YES completion:^{
                        [self showAddPhotoScreenItems:imageItemsToBeUpdated];
                    }];
                    
                } else {
                    [self showAddPhotoScreenItems:imageItemsToBeUpdated];
                }
                break;
            }
            case CameraControlListViewRetake: {
                
                break;
            }
            case CameraControlListViewPano: {
                
                break;
            }
            case CameraControlListViewPhoto: {
                
                break;
            }
            case CameraControlListViewLibrary: {

                break;
            }
            case CameraControlListView360: {
                
                break;
            }
            default: {
                
                break;
            }
        }
    }
}

#pragma mark - CustomPhotoLibraryDelegate
- (void)customCameraPhotoLibDidSelect:(UIImage *)image {
    self.customCameraVC.capturedImage.image = image;
    capturedImage = image;
}

#pragma mark - CustomPanorama

- (void)customPanoImageTaken:(UIImage *)image {
    self.customCameraVC.capturedImage.image = image;
    capturedImage = image;
    

}
@end

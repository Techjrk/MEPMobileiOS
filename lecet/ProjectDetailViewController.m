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
#import "DropDownMenuShareList.h"




#import "DB_Project.h"
#import "DB_Company.h"
#import "DB_Participant.h"
#import "ProjectDetailStateViewController.h"


#import "ProjectListViewController.h"




@interface ProjectDetailViewController ()<ProjectStateViewDelegate, ProjectHeaderDelegate,DropDownShareListDelegate,PariticipantsDelegate, ProjectBidderDelegate,ProjectDetailStateViewControllerDelegate,ProjectTrackListViewControllerDelegate>{




    BOOL isShownContentAdjusted;
    BOOL isDropDownSharelistHidden;
    BOOL isDropDownProjectListHidden;
    BOOL isProjectDetailStateHidden;
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
@property (weak,nonatomic) IBOutlet DropDownMenuShareList *dropDownShareListView;
@property (weak, nonatomic) IBOutlet UIView *dimProjectMenuContainerView;;

//Fields
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldCounty;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldProjectId;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldAddress;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldProjectType;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldEstLow;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldStage;

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldCounty;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldEstLow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldStage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldNotes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldParticipants;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectBidder;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDropDownShareHeight;

//Actions
- (IBAction)tappedBackButton:(id)sender;
@end

@implementation ProjectDetailViewController
static const float animationDurationForDropDowMenu = 0.35f;

@synthesize previousRect;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.hidden = YES;
    _containerView.backgroundColor = PROJECT_DETAIL_CONTAINER_BG_COLOR;
    _headerView.projectHeaderDelegate = self;
    [_fieldCounty changeConstraintHeight: _constraintFieldCounty];
    [_fieldProjectId changeConstraintHeight: _constraintFieldProjectID];
    [_fieldAddress changeConstraintHeight: _constraintFieldAddress];
    [_fieldProjectType changeConstraintHeight: _constraintFieldProjectType];
    [_fieldEstLow changeConstraintHeight: _constraintFieldEstLow];
    [_fieldStage changeConstraintHeight: _constraintFieldStage];
    [_notesView changeConstraintHeight:_constraintFieldNotes];
    [_participantsView changeConstraintHeight:_constraintFieldParticipants];
    [_projectBidder changeConstraintHeight:_constraintFieldProjectBidder];
    
    _projectBidder.projectBidderDelegate = self;
    _participantsView.pariticipantsDelegate = self;
    _projectState.projectStateViewDelegate = self;
    
    //ShareList
    _dropDownShareListView.dropDownShareListDelegate = self;
    isDropDownSharelistHidden = YES;
    
    //ProjectList
    //_dropDownProjectListView.dropDownProjectListDelegate = self;
    //isDropDownProjectListHidden = YES;
    
    

    
    [self addTappedGestureForDimBackground];
    [self setAutoLayConstraintInIncompatibleDevice];
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
    
    NSString *address1 = project.address1 == nil ? @"": project.address1;
    [_headerView setHeaderInfo:@{PROJECT_GEOCODE_LAT:project.geocodeLat, PROJECT_GEOCODE_LNG:project.geocodeLng, PROJECT_TITLE:project.title, PROJECT_LOCATION: address1}];
    
    [_fieldCounty setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_COUNTY") line1Text:project.county line2Text:nil];
    
    NSString *projectId = [NSString stringWithFormat:@"%@ %@", project.dodgeNumber, (project.dodgeVersion == nil ? @"":[NSString stringWithFormat:@"(v%@)", project.dodgeVersion]) ];
    [_fieldProjectId setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_ID") line1Text:projectId line2Text:nil];

    NSString *address = [NSString stringWithFormat:@"%@, %@ %@", address1, project.state, project.zip5];
    [_fieldAddress setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ADDRESS") line1Text:address line2Text:nil];
    
    [_fieldProjectType setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_TYPE") line1Text:[project getProjectType] line2Text:nil];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    CGFloat estlowValue = 0;
    
    if (project.estLow != nil) {
        estlowValue = [project.estLow floatValue];
    }
    
    NSString *estLow = [NSString stringWithFormat:@"%@ %@", project.currencyType == nil? @"$":project.currencyType, [formatter stringFromNumber:[NSNumber numberWithFloat:estlowValue]]];
    [_fieldEstLow setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ESTLOW") line1Text:estLow line2Text:nil];
    
    [_fieldStage setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_STAGE") line1Text:project.projectStageName line2Text:nil];
    
    NSMutableArray *bidItems =  [project.relationshipBid allObjects] != nil? [[project.relationshipBid allObjects] mutableCopy] : [NSMutableArray new];
    [_projectBidder setItems:bidItems];
 
    NSMutableArray *participants = [project.relationshipParticipants allObjects] != nil? [[project.relationshipParticipants allObjects] mutableCopy]:[NSMutableArray new];
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

- (void)selectedStateViewItem:(StateView)stateView {
    
    if (stateView == StateViewShare) {
        
        [self showOrHideDropDownShareListMenu];
   
        
    }else if (stateView == StateViewTrack){
        
        
      
        
        [self tappedProjectTrackListButton];
        

       
    }else if (stateView == StateViewHide){
 
        [self tappedProjectDetailStateHideButton];
        
    }
}

- (void)tappedProjectMapViewLat:(CGFloat)lat lng:(CGFloat)lng {
    MapViewController *map = [MapViewController new];
    [map setLocationLat:lat lng:lng];
    [self.navigationController pushViewController:map animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationObjectForOperation:(UINavigationControllerOperation)operation {
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

- (void)tappedParticipant:(id)object {
    DB_Participant *record = object;
    
    [[DataManager sharedManager] companyDetail:record.companyId success:^(id object) {
        CompanyDetailViewController *controller = [CompanyDetailViewController new];
        controller.view.hidden = NO;
        [controller setInfo:object];
        [self.navigationController pushViewController:controller animated:YES];
    } failure:^(id object) {
        
    }];

}

#pragma mark - Delegate and Share List Method

- (void)tappedDropDownShareList:(DropDownShareListItem)shareListItem{
    
    [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"FEATURENOTAVAILABLE")];
    
}

- (void)showOrHideDropDownShareListMenu{
    if (isDropDownSharelistHidden) {
        
        isDropDownSharelistHidden = NO;
        [_dropDownShareListView setHidden:NO];
        [_dimProjectMenuContainerView setHidden:NO];
        
        _dropDownShareListView.alpha  = 0.0f;
        _dimProjectMenuContainerView.alpha = 0.0f;
        
        [UIView animateWithDuration:animationDurationForDropDowMenu animations:^{
            _dropDownShareListView.alpha  = 1.0f;
            _dimProjectMenuContainerView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                isDropDownSharelistHidden = NO;
                
            }
        }];

    }else{
        
        [self hideDropDownShareList];
        
    }
    
}

- (void)hideDropDownShareList{
    
    isDropDownSharelistHidden = YES;
    [_dropDownShareListView setHidden:YES];
}

#pragma mark - Project List Delegate and Method

-(void)tappedDismissedProjectTrackList{
    
    [_projectState clearSelection];
}

- (void)tappedProjectTrackListButton{
    

    
    ProjectListViewController *controller = [ProjectListViewController new];
    //controller.view.hidden = NO;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [controller setProjectStateViewFrame:_projectState];
    
    controller.projectTrackListViewControllerDelegate = self;
    
    [self presentViewController:controller  animated:YES completion:nil];
    
}







#pragma mark - Project Detail State ViewController Methods And Delegate

- (void)tappedProjectDetailStateHideButton{
    ProjectDetailStateViewController *controller = [[ProjectDetailStateViewController alloc] initWithNibName:@"ProjectDetailStateViewController" bundle:nil];
    
    //controller.view.hidden = NO;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.projectDetailStateViewControllerDelegate = self;
    
    [self presentViewController:controller  animated:YES completion:nil];
    
  
    
}

- (void)tappedDismissed{
    
    [_projectState clearSelection];
}

- (void)setAutoLayConstraintInIncompatibleDevice{
    
    if (isiPhone4) {
        //Share List
        _constraintDropDownShareHeight.constant = 90;
    }
    
    if (isiPhone5) {
        //Share List
        _constraintDropDownShareHeight.constant = 90;
        
    }
}

- (void)addTappedGestureForDimBackground{
    
    [[Utilities sharedIntances] addTappGesture:@selector(hideAllDropDownMenu) numberOfTapped:1 targetView:_dimProjectMenuContainerView target:self];
    
}

- (void)hideAllDropDownMenu{
    
    [_projectState clearSelection];
    UIView *viewThatIsVisible;
    
    
    
    if (!isDropDownSharelistHidden){
        
        viewThatIsVisible = _dropDownShareListView;
    }
    
    [UIView animateWithDuration:animationDurationForDropDowMenu animations:^{
        viewThatIsVisible.alpha  = 0.0f;

    } completion:^(BOOL finished) {
        if (finished) {
            
            [self hideDropDownShareList];
     
  
            [_dimProjectMenuContainerView setHidden:YES];
            
        }
    }];
}

- (void)tappedProjectBidder:(id)object {
    DB_Bid *bid = object;
    
    [[DataManager sharedManager] companyDetail:bid.relationshipCompany.recordId success:^(id object) {
        CompanyDetailViewController *controller = [CompanyDetailViewController new];
        controller.view.hidden = NO;
        [controller setInfo:object];
        [self.navigationController pushViewController:controller animated:YES];
    } failure:^(id object) {
        
    }];
}

@end

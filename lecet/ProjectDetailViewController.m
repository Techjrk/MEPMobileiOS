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
#import "DropDownProjectList.h"
#import "ProjectDetailStateView.h"

#import "DB_Project.h"
@interface ProjectDetailViewController ()<ProjectStateViewDelegate, ProjectHeaderDelegate,DropDownShareListDelegate,DropDownProjectListDelegate,ProjectDetailStateDelegate,PariticipantsDelegate, ProjectBidderDelegate>{




    BOOL isShownContentAdjusted;
    BOOL isDropDownSharelistHidden;
    BOOL isDropDownProjectListHidden;
    BOOL isProjectDetailStateHidden;
    
}
@property (weak, nonatomic) IBOutlet ProjectHeaderView *headerView;
@property (weak, nonatomic) IBOutlet ProjectStateView *projectState;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)tappedBackButton:(id)sender;
//Fields
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldCounty;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldProjectId;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldAddress;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldProjectType;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldEstLow;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldStage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldCounty;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldEstLow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldStage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldNotes;
@property (weak, nonatomic) IBOutlet SeeAllView *seeAllView;
@property (weak, nonatomic) IBOutlet NotesView *notesView;
@property (weak, nonatomic) IBOutlet PariticpantsView *participantsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldParticipants;
@property (weak, nonatomic) IBOutlet ProjectBidderView *projectBidder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectBidder;

@property (weak,nonatomic) IBOutlet DropDownMenuShareList *dropDownShareListView;

@property (weak,nonatomic) IBOutlet DropDownProjectList *dropDownProjectListView;

@property (weak,nonatomic) IBOutlet ProjectDetailStateView * projectDetailStateView;

@property (weak, nonatomic) IBOutlet UIView *dimProjectDetailStateView;

@property (weak, nonatomic) IBOutlet UIView *dimProjectMenuContainerView;;

@end

@implementation ProjectDetailViewController

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
    _dropDownProjectListView.dropDownProjectListDelegate = self;
    isDropDownProjectListHidden = YES;
    
    //ProjectDetailStateView
    isProjectDetailStateHidden = YES;
    _projectDetailStateView.projectDetailStateDelegate = self;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (IBAction)tappedBackButton:(id)sender {
    
    if (self.navigationController != nil) {
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = self.previousRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [self dismissViewControllerAnimated:NO completion:^{
                    
                }];
                
            }
        }];
    }
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
    
    
    NSString *projectType = [NSString stringWithFormat:@"%@ %@ %@", project.primaryProjectTypeTitle==nil?@"":project.primaryProjectTypeTitle, project.projectCategoryTitle==nil?@"":project.projectCategoryTitle, project.projectGroupTitle==nil?@"":project.projectGroupTitle];
    
    [_fieldProjectType setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_TYPE") line1Text:projectType line2Text:nil];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    CGFloat estlowValue = 0;
    
    if (project.estLow != nil) {
        estlowValue = [project.estLow floatValue];
    }
    
    NSString *estLow = [NSString stringWithFormat:@"%@ %@", project.currencyType == nil? @"$":project.currencyType, [formatter stringFromNumber:[NSNumber numberWithFloat:estlowValue]]];
    [_fieldEstLow setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ESTLOW") line1Text:estLow line2Text:nil];
    
    [_fieldStage setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_STAGE") line1Text:project.projectStageName line2Text:nil];
    
    [_participantsView setItems:[@[@"",@""] mutableCopy]];
    [_projectBidder setItems:[@[@"",@"", @""] mutableCopy]];
}

- (void)viewWillLayoutSubviews {
}

- (void)viewDidLayoutSubviews {
    //[self layoutContentView];
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
        [self hideDropDownProjectList];
        
    }else if (stateView == StateViewTrack){
        
        [self showOrHideDropDownProjectListMenu];
        [self hideDropDownShareList];
        
    }else if (stateView == StateViewHide){
        
        [self hideDropDownProjectList];
        [self hideDropDownShareList];
        [self showOrHideDropDownProjectDetailState];
        
        
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
    CompanyDetailViewController *controller = [CompanyDetailViewController new];
    controller.view.hidden = NO;
    [controller setInfo:nil];
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - Share List Method and Delegate


- (void)tappedDropDownShareList:(DropDownShareListItem)shareListItem{
    
    
    
}


- (void)showOrHideDropDownShareListMenu{
    if (isDropDownSharelistHidden) {
        
        isDropDownSharelistHidden = NO;
    
        [_dropDownShareListView setHidden:NO];
    
    }else{
        
        isDropDownSharelistHidden = YES;
        [_dropDownShareListView setHidden:YES];
        
    }
    
}


- (void)hideDropDownShareList{
    
    isDropDownSharelistHidden = YES;
    [_dropDownShareListView setHidden:YES];
}



#pragma mark - Proejct List Delegate and Method

- (void)tappedDropDownProjectList:(DropDownProjectListItem)projectListItem{
    
    
}


- (void)showOrHideDropDownProjectListMenu{
    if (isDropDownProjectListHidden) {
        
        isDropDownProjectListHidden = NO;
        [_dropDownProjectListView setHidden:NO];
        
    }else{
        
        isDropDownProjectListHidden = YES;
        [_dropDownProjectListView setHidden:YES];
        
    }
    
}


- (void)hideDropDownProjectList{
    
    
    isDropDownProjectListHidden = YES;
    [_dropDownProjectListView setHidden:YES];
    
}


#pragma mark - Project Detail State Delegate


- (void)tappedProjectDetailState:(ProjectDetailStateItem)projectDetailStteItem{
    
    
    if (projectDetailStteItem == ProjectDetailStateCancel) {
        [self hideProjectDetailStateView];
    }
    
}


- (void)showOrHideDropDownProjectDetailState{
    if (isProjectDetailStateHidden) {
        
        isProjectDetailStateHidden = NO;
        [_projectDetailStateView setHidden:NO];
        [_dimProjectDetailStateView setHidden:NO];
        
        
        
    }else{
        
        isProjectDetailStateHidden = YES;
        [_projectDetailStateView setHidden:YES];
        [_dimProjectDetailStateView setHidden:YES];
        
    }
    
}


- (void)hideProjectDetailStateView{
    
    isProjectDetailStateHidden = YES;
    [_projectDetailStateView setHidden:YES];
    [_dimProjectDetailStateView setHidden:YES];

    
}


- (void)addTappedGestureForDimBackground{
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProjectDetailStateView)];
    tapped.numberOfTapsRequired = 1;
    [_projectDetailStateView addGestureRecognizer:tapped];
    
    
}






- (void)tappedProjectBidder:(id)object {
    CompanyDetailViewController *controller = [CompanyDetailViewController new];
    controller.view.hidden = NO;
    [controller setInfo:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end

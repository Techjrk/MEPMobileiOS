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

@interface ProjectDetailViewController ()<ProjectStateViewDelegate, ProjectHeaderDelegate>{
    BOOL isShownContentAdjusted;
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
    
    _projectState.projectStateViewDelegate = self;
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

- (void)detailsFromBid:(DB_BidRecent *)record {
    
    NSString *address1 = record.address1 == nil ? @"": record.address1;
    [_headerView setHeaderInfo:@{PROJECT_GEOCODE_LAT:record.geocodeLat, PROJECT_GEOCODE_LNG:record.geocodeLng, PROJECT_TITLE:record.title, PROJECT_LOCATION: address1}];
    
    [_fieldCounty setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_COUNTY") line1Text:record.county line2Text:nil];
    
    NSString *projectId = [NSString stringWithFormat:@"%@ %@", record.dodgeNumber, (record.dodgeVersion == nil ? @"":[NSString stringWithFormat:@"(v%@)", record.dodgeVersion]) ];
    [_fieldProjectId setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_ID") line1Text:projectId line2Text:nil];

    
    NSString *address = [NSString stringWithFormat:@"%@, %@ %@", address1, record.state, record.zip5];
    
    [_fieldAddress setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ADDRESS") line1Text:address line2Text:nil];
    
    [_fieldProjectType setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_PROJECT_TYPE") line1Text:@"Sewage Treatment Plant\n(H/Primary)" line2Text:nil];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    CGFloat estlowValue = 10000;
    
    if (record.estLow == nil) {
        estlowValue = [record.estLow floatValue];
    }
    
    NSString *estLow = [NSString stringWithFormat:@"%@ %@", record.currencyType == nil? @"$":record.currencyType, [formatter stringFromNumber:[NSNumber numberWithFloat:estlowValue]]];
    [_fieldEstLow setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_ESTLOW") line1Text:estLow line2Text:nil];
    
    [_fieldStage setTitle:NSLocalizedLanguage(@"PROJECT_DETAIL_STAGE") line1Text:@"Bidding (Primary)" line2Text:nil];
    
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


@end

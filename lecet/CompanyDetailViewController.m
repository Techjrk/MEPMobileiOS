//
//  CompanyDetailViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyDetailViewController.h"

#import "companyDetailsConstants.h"
#import "companyHeaderConstants.h"
#import "CompanyHeaderView.h"
#import "CustomEntryField.h"
#import "AssociatedProjectsView.h"
#import "NotesView.h"
#import "ContactsListView.h"
#import "ProjectBidListView.h"
#import "CompanyStateView.h"
#import "contactFieldConstants.h"
#import "MapViewController.h"
#import "PushZoomAnimator.h"
#import "DB_Company.h"
#import "DB_Bid.h"
#import "DB_Contact.h"

@interface CompanyDetailViewController ()<CompanyHeaderDelegate>{
    BOOL isShownContentAdjusted;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@property (weak, nonatomic) IBOutlet CompanyHeaderView *companyHeader;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAddress;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldTotalProjects;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldTotalProjects;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldTotalValuation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldTotalValuation;
@property (weak, nonatomic) IBOutlet AssociatedProjectsView *fieldAssociatedProjects;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAssociatedProjects;
@property (weak, nonatomic) IBOutlet NotesView *fieldNotes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldNotes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewSpacer;
@property (weak, nonatomic) IBOutlet ContactsListView *fieldContacts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldContacts;
@property (weak, nonatomic) IBOutlet ProjectBidListView *fieldProjectBidList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectBidList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldCompanyState;
@property (weak, nonatomic) IBOutlet CompanyStateView *fieldCompanyState;
- (IBAction)tappedButtonBack:(id)sender;
@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hidden = YES;
    
    _companyHeader.companyCampanyHeaderDelegate = self;
    _containerView.backgroundColor = COMPANY_DETAIL_CONTAINER_BG_COLOR;
    [_fieldAddress changeConstraintHeight:_constraintFieldAddress];
    [_fieldTotalProjects changeConstraintHeight:_constraintFieldTotalProjects];
    [_fieldTotalValuation changeConstraintHeight:_constraintFieldTotalValuation];
    [_fieldAssociatedProjects changeConstraintHeight:_constraintFieldAssociatedProjects];
    [_fieldNotes changeConstraintHeight:_constraintFieldNotes];
    [_fieldContacts changeConstraintHeight:_constraintFieldContacts];
    [_fieldProjectBidList changeConstraintHeight:_constraintFieldProjectBidList];
    [_fieldCompanyState changeConstraintHeight:_constraintFieldCompanyState];
    
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
        CGFloat contentHeight = _fieldProjectBidList.frame.size.height + _fieldProjectBidList.frame.origin.y + (kDeviceHeight * 0.05);
        _constraintContentHeight.constant = contentHeight;
        _scrollView.contentSize = CGSizeMake(kDeviceWidth, contentHeight);
    }
    
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

- (void)setInfo:(id)info {
    DB_Company *record = info;
    
    [_companyHeader setHeaderInfo:@{COMPANY_TITLE:record.name, COMPANY_GEOCODE_LAT:@" 47.606208801269531", COMPANY_GEOCODE_LNG:@"-122.33206939697266"}];
    [_fieldAddress setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_ADDRESS") line1Text:[record address] line2Text:nil];
    [_fieldTotalProjects setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_TOTAL_PROJECTS") line1Text:@"2" line2Text:nil];
    [_fieldTotalValuation setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_TOTAL_VALUATION") line1Text:@"$ 1,128,000" line2Text:nil];

    
    NSMutableArray *contactItem = [NSMutableArray new];
    //NSArray *contactItem = @[ @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypePhone ], CONTACT_FIELD_DATA:@"(734) 591-3400"}, @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeEmail ], CONTACT_FIELD_DATA:@"companyinfo@jaydeecontr.com"}, @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeWeb], CONTACT_FIELD_DATA:@"www.jaydeecontr.com"}];

    if ( record.wwwUrl != nil ) {
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeWeb], CONTACT_FIELD_DATA:record.wwwUrl}];
    }
    
    [_fieldCompanyState setItems:contactItem];

    NSMutableArray *associatedProjects = [@[@"", @"", @"", @""]mutableCopy];
    [_fieldAssociatedProjects setItems:associatedProjects];
    
    
    NSMutableArray *contacts = [record.relationshipCompanyContact allObjects]!= nil? [[record.relationshipCompanyContact allObjects] mutableCopy ]:[NSMutableArray new];
    [_fieldContacts setItems:contacts];
    
    NSMutableArray *bidList = [@[@"", @"", @"", @""]mutableCopy];
    [_fieldProjectBidList setItems:bidList];
    
}

- (IBAction)tappedButtonBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tappedCompanyMapViewLat:(CGFloat)lat lng:(CGFloat)lng {
    MapViewController *map = [MapViewController new];
    [map setLocationLat:lat lng:lng];
    [self.navigationController pushViewController:map animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationObjectForOperation:(UINavigationControllerOperation)operation {
    PushZoomAnimator *animator = [[PushZoomAnimator alloc] init];
    animator.willPop = operation!=UINavigationControllerOperationPush;
    if (!animator.willPop){
        animator.startRect = [_companyHeader mapFrame];
        animator.endRect = self.view.frame;
    } else {
        animator.startRect = self.view.frame;
        animator.endRect = [_companyHeader mapFrame];
    }
    return animator;
}


@end

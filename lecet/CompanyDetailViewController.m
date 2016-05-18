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

@interface CompanyDetailViewController (){
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
    [_fieldAddress setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_ADDRESS") line1Text:@"38881 Schoolcraft Rd\nLivonia, MI 48150-1033" line2Text:nil];
    [_fieldTotalProjects setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_TOTAL_PROJECTS") line1Text:@"2" line2Text:nil];
    [_fieldTotalValuation setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_TOTAL_VALUATION") line1Text:@"$ 1,128,000" line2Text:nil];
    [_fieldAssociatedProjects setItems:[@[@"", @"", @"", @"", @"", @""]mutableCopy]];
    [_fieldContacts setItems:[@[@"", @"", @"", @""]mutableCopy]];
    [_fieldProjectBidList setItems:[@[@"", @"", @"", @""]mutableCopy]];
    [_fieldCompanyState setItems:[@[@"", @"", @""]mutableCopy] ];

}

- (IBAction)tappedButtonBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

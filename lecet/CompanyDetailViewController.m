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
#import "DB_Project.h"
#import "ProjectBidsListViewController.h"
#import "CDAssociatedProjectViewController.h"
#import "ContactAllListViewController.h"
#import "ContactDetailViewController.h"
#import "DB_CompanyContact.h"

@interface CompanyDetailViewController ()<CompanyHeaderDelegate, CompanyStateDelegate, ProjectBidListDelegate,AssociatedProjectDelegate,ContactListViewDelegate>{
    BOOL isShownContentAdjusted;
    NSNumber *companyRecordId;
    NSMutableArray *contactAllList;
    NSString *companyName;
    BOOL usePushZoom;
    NSMutableArray *associatedProjects;
}
//Views
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet CompanyHeaderView *companyHeader;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldAddress;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldTotalProjects;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldTotalValuation;
@property (weak, nonatomic) IBOutlet AssociatedProjectsView *fieldAssociatedProjects;
@property (weak, nonatomic) IBOutlet NotesView *fieldNotes;
@property (weak, nonatomic) IBOutlet ContactsListView *fieldContacts;
@property (weak, nonatomic) IBOutlet ProjectBidListView *fieldProjectBidList;
@property (weak, nonatomic) IBOutlet CompanyStateView *fieldCompanyState;

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldTotalProjects;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldTotalValuation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAssociatedProjects;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldNotes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldContacts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldProjectBidList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldCompanyState;

//Actions
- (IBAction)tappedButtonBack:(id)sender;
@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.hidden = YES;
    _companyHeader.companyCampanyHeaderDelegate = self;
    _fieldCompanyState.companyStateDelegate = self;
    _containerView.backgroundColor = COMPANY_DETAIL_CONTAINER_BG_COLOR;
    [_fieldAddress changeConstraintHeight:_constraintFieldAddress];
    [_fieldTotalProjects changeConstraintHeight:_constraintFieldTotalProjects];
    [_fieldTotalValuation changeConstraintHeight:_constraintFieldTotalValuation];
    [_fieldAssociatedProjects changeConstraintHeight:_constraintFieldAssociatedProjects];
    [_fieldNotes changeConstraintHeight:_constraintFieldNotes];
    [_fieldContacts changeConstraintHeight:_constraintFieldContacts];
    [_fieldProjectBidList changeConstraintHeight:_constraintFieldProjectBidList];
    [_fieldCompanyState changeConstraintHeight:_constraintFieldCompanyState];
    _fieldProjectBidList.projectBidListDelegate = self;
    _fieldAssociatedProjects.associatedProjectDelegate = self;
    _fieldContacts.contactListViewDelegate = self;
    
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
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)setInfo:(id)info {
    DB_Company *record = info;
    
    companyName = record.name;
    companyRecordId = record.recordId;
    [_companyHeader setHeaderInfo:@{COMPANY_TITLE:record.name, COMPANY_GEOCODE_LAT:@" 47.606208801269531", COMPANY_GEOCODE_LNG:@"-122.33206939697266"}];
    [_fieldAddress setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_ADDRESS") line1Text:[record address] line2Text:nil];
    
    
    associatedProjects = [record.relationshipAssociatedProjects allObjects] != nil? [[record.relationshipAssociatedProjects allObjects] mutableCopy]:[NSMutableArray new];
    CGFloat valuation = 0;
    for (DB_Project *project in associatedProjects) {
        valuation +=(project.estLow!=nil?project.estLow.floatValue:0);
    }
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *estLow = [formatter stringFromNumber:[NSNumber numberWithFloat:valuation]];
    
    NSInteger associatedProjectCount = associatedProjects!=nil?associatedProjects.count:0;
    
    [_fieldTotalProjects setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_TOTAL_PROJECTS") line1Text:[NSString stringWithFormat:@"%li",(long)associatedProjectCount] line2Text:nil];
    [_fieldTotalValuation setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_TOTAL_VALUATION") line1Text:[NSString stringWithFormat:@"$ %@",estLow] line2Text:nil];
    
    NSMutableArray *contactItem = [NSMutableArray new];

    NSArray *contactsArray = [record.relationshipCompanyContact allObjects];
    
    if (contactsArray != nil & contactsArray.count>0) {
        DB_CompanyContact *contact = contactsArray[0];
        
        if (contact.phoneNumber != nil) {
            [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypePhone], CONTACT_FIELD_DATA:contact.phoneNumber}];
        }
        
        if (contact.email != nil) {
            [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeEmail], CONTACT_FIELD_DATA:contact.email}];
            
        }
    }
    
    if ( record.wwwUrl != nil ) {
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeWeb], CONTACT_FIELD_DATA:record.wwwUrl}];
    }
    
    [_fieldCompanyState setItems:contactItem];

    [_fieldNotes setNotes:nil];
    
    [_fieldAssociatedProjects setItems:associatedProjects];
    
    NSMutableArray *contacts = [record.relationshipCompanyContact allObjects]!= nil? [[record.relationshipCompanyContact allObjects] mutableCopy ]:[NSMutableArray new];
    
    contactAllList = contacts;
    [_fieldContacts setItems:contacts];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationshipCompany.recordId == %li", companyRecordId.integerValue];
    
    NSArray *fetchRecord = [DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO];

    
    NSMutableArray *bidList = [fetchRecord mutableCopy];
    [_fieldProjectBidList setItems:bidList];
    
}

- (IBAction)tappedButtonBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tappedCompanyMapViewLat:(CGFloat)lat lng:(CGFloat)lng {
    usePushZoom = YES;
    MapViewController *map = [MapViewController new];
    [map setLocationLat:lat lng:lng];
    [self.navigationController pushViewController:map animated:YES];
}

- (void)tappedCompanyState:(CompanyState)companyState {
    [[DataManager sharedManager] featureNotAvailable];
}

- (void)tappedCompnayStateContact:(id)object {
    NSNumber *fieldType = object[CONTACT_FIELD_TYPE];
    NSString *fieldData = object[CONTACT_FIELD_DATA];
    
    switch (fieldType.integerValue) {
        case ContactFieldTypePhone:{
            
            fieldData = [[fieldData stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:fieldData]]];
            break;
        }
         
        case ContactFieldTypeWeb:{
            NSString *field = [fieldData uppercaseString];
            if (![field hasPrefix:@"HTTP://"]) {
                fieldData = [@"http://" stringByAppendingString:fieldData];
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fieldData]];

            break;
        }
            
        case ContactFieldTypeEmail: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto:" stringByAppendingString:fieldData]]];

            break;
        }
    }
}

- (void)tappedProjectItemBidSeeAll:(id)object {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationshipCompany.recordId == %li", companyRecordId.integerValue];
    
    NSArray *fetchRecord = [DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO];
    [self tappedProjectBidsList:fetchRecord];
}

- (id<UIViewControllerAnimatedTransitioning>)animationObjectForOperation:(UINavigationControllerOperation)operation {
    if (usePushZoom) {
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
    return nil;
}

#pragma mark - ProjectList Bidder Dlegate

-(void)tappedProjectItemBidder:(id)object{
    
}

- (void)tappedProjectBidsList:(NSArray *)fetchRecord{
    usePushZoom = NO;
    ProjectBidsListViewController *controller = [ProjectBidsListViewController new];
    [controller setContractorName:companyName];
    [controller setInfoForProjectBids:fetchRecord];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)tappedProjectBids:(id)sender {
    
}

#pragma mark - Associated Project Delegate

- (void)tappededSeeAllAssociateProject {
    usePushZoom = NO;
    CDAssociatedProjectViewController *controller = [CDAssociatedProjectViewController new];
    [controller setContractorName:companyName];
    [controller setInfoForAssociatedProjects:associatedProjects];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - ContactListView Delegate
- (void)selectedContact:(id)item {
    usePushZoom = NO;
    ContactDetailViewController *controller = [ContactDetailViewController new];
    [controller setCompanyContactDetails:item];
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)tappededSeeAllContactsProject {
    [self tappedToSeeAllContact:self];
}


#pragma mark - ContactAll List ViewController Method
- (IBAction)tappedToSeeAllContact:(id)sender {
    usePushZoom = NO;
    ContactAllListViewController *controller = [ContactAllListViewController new];
    [controller setInfoForContactList:contactAllList];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)tapped:(id)sender {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationshipCompany.recordId == %li", companyRecordId.integerValue];
    
    NSArray *fetchRecord = [DB_Bid fetchObjectsForPredicate:predicate key:@"createDate" ascending:NO];
    [self tappedProjectBidsList:fetchRecord];
}


@end

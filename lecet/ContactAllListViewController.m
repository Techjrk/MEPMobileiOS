//
//  ContactAllListViewController.m
//  lecet
//
//  Created by Michael San Minay on 05/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactAllListViewController.h"

#import "ContactAllListView.h"
#import "ProjectNavigationBarView.h"
#import "ProjectAllBidsView.h"
#import "ProjectSortViewController.h"
#import "ContactDetailViewController.h"

@interface ContactAllListViewController ()<ProjectNavViewDelegate, ContactAllListViewDelegate>{
    NSMutableArray *contactList;
}
@property (weak, nonatomic) IBOutlet ContactAllListView *contactAllListView;
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *projectNavBarView;
@end

@implementation ContactAllListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _projectNavBarView.projectNavViewDelegate = self;
    _contactAllListView.contactAllListViewDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_projectNavBarView setProjectTitle:@""];
    [_projectNavBarView setContractorName:NSLocalizedLanguage(@"CONTACT_ALL_LIST_NAVBAR_TITLE")];
    [_contactAllListView setItems:contactList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setInfoForContactList:(NSMutableArray *)contacts {
    
    contactList = contacts;
}


#pragma mark - ProjectNav Delegate

- (void)tappedProjectNav:(ProjectNavItem)projectNavItem {
    
    if (projectNavItem == ProjectNavReOrder) {
        [self tappedReOrderButton];
    }
    if (projectNavItem == ProjectNavBackButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tappedReOrderButton {
    ProjectSortViewController *controller = [ProjectSortViewController new];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller  animated:YES completion:nil];
}

- (void)selectedContact:(id)object {
    ContactDetailViewController *controller = [ContactDetailViewController new];
    [controller setCompanyContactDetails:object];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

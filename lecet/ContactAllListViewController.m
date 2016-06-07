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

@interface ContactAllListViewController ()<ProjectNavViewDelegate>{
    NSMutableArray *contactList;
}
@property (weak, nonatomic) IBOutlet ContactAllListView *contactAllListView;

@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *projectNavBarView;

@end

@implementation ContactAllListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _projectNavBarView.projectNavViewDelegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    //CONTACT_ALL_LIST_NAVBAR_TITLE
    [_projectNavBarView setProjectTitle:@""];
    [_projectNavBarView setContractorName:NSLocalizedLanguage(@"CONTACT_ALL_LIST_NAVBAR_TITLE")];
    [_contactAllListView setItems:contactList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end

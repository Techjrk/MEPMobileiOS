//
//  CompanyTrackingListViewController.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyTrackingListViewController.h"
#import "ProjectNavigationBarView.h"
#import "ProjComTrackingTabView.h"
#import "CompanyTrackingListView.h"
#import "CompanySortViewController.h"
#import "EditViewController.h"

@interface CompanyTrackingListViewController ()<ProjectNavViewDelegate,ProjComTrackingTabViewDelegate,EditViewControllerDelegate,CompanySortDelegate>{
    
    id dataItems;
    id dataItemsFromEdit;
    BOOL firstLoad;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *navBarView;
@property (weak, nonatomic) IBOutlet ProjComTrackingTabView *tabBarView;
@property (weak, nonatomic) IBOutlet CompanyTrackingListView *companyTrackingListView;

@end

@implementation CompanyTrackingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navBarView.projectNavViewDelegate = self;
    _tabBarView.projComTrackingTabViewDelegate = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    if (!firstLoad) {
        firstLoad = YES;
        [_companyTrackingListView setItems:dataItems];
    } else {
        [_companyTrackingListView setItemFrommEditViewController:dataItems];
    }
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(id)item {
    dataItems =item;
}

#pragma mark - Nav View Delegate

- (void)tappedProjectNav:(ProjectNavItem)projectNavItem {

    switch (projectNavItem) {
        case ProjectNavBackButton:{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        }
        case ProjectNavReOrder:{
            CompanySortViewController *controller = [[CompanySortViewController alloc] initWithNibName:@"CompanySortViewController" bundle:nil];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.companySortDelegate = self;
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:controller  animated:NO completion:nil];
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - Tab Delegate

- (void)switchTabButtonStateChange:(BOOL)isOn {
    
    [_companyTrackingListView switchButtonChange:isOn];
    
}

- (void)editTabButtonTapped {
    EditViewController *controller = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    controller.editViewControllerDelegate = self;
    [controller setInfo:[_companyTrackingListView getdata]];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:controller  animated:NO completion:nil];
    
    //[self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - EditViewControllerDelegate

- (void)tappedCancelDoneButton:(id)items {
    dataItems = items;
}
- (void)tappedBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - CompanySort Delegate

- (void)selectedSort:(CompanySortItem)item {
    [[DataManager sharedManager] featureNotAvailable];
}


@end

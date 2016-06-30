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
    id trackingInfo;
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
        [_companyTrackingListView setItemToReload:dataItems];
    }
    [_navBarView setContractorName:trackingInfo[@"name"]];
    
    
    
    NSString *countString = [NSString stringWithFormat:@"%lu %@",[trackingInfo[@"companyIds"] count],NSLocalizedLanguage(@"COMPANIES_COUNT_TITLE")];
    [_navBarView setProjectTitle:countString];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(id)item {
    dataItems =item;
}
- (void)setTrackingInfo:(id)item {
    trackingInfo = item;
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
    [controller setTrackingInfo:trackingInfo];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller  animated:NO completion:nil];

}

#pragma mark - EditViewControllerDelegate

- (void)tappedCancelDoneButton:(id)items {
    dataItems = items;
    
    NSString *countString = [NSString stringWithFormat:@"%lu %@",(unsigned long)[dataItems count],NSLocalizedLanguage(@"COMPANIES_COUNT_TITLE")];
    [_navBarView setProjectTitle:countString];
    [_companyTrackingListView setItemToReload:dataItems];
}
- (void)tappedBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - CompanySort Delegate

- (void)selectedSort:(CompanySortItem)item {
    switch (item) {
        case CompanySortItemLastUpdated: {
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
            dataItems = [[[_companyTrackingListView getdata] sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
            [_companyTrackingListView setItemToReload:dataItems];
            break;
        }
        case CompanySortItemLastAlphabetical: {
            
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            dataItems = [[[_companyTrackingListView getdata] sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
            [_companyTrackingListView setItemToReload:dataItems];
            break;
        }

    }
}



@end

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
@interface CompanyTrackingListViewController ()<ProjectNavViewDelegate,ProjComTrackingTabViewDelegate>
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[DataManager sharedManager] featureNotAvailable];
}

@end

//
//  ProjectBidsListViewController.m
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBidsListViewController.h"

#import "ProjectNavigationBarView.h"
#import "ProjectTabView.h"
#import "ProjectAllBidsView.h"
#import "ProjectSortViewController.h"

@interface ProjectBidsListViewController ()<ProjectNavViewDelegate,ProjectSortViewControllerDelegate>{
    NSMutableArray *bidList;
    NSString *companyName;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *projectNavigationView;
@property (weak, nonatomic) IBOutlet ProjectTabView *projectTabView;
@property (weak, nonatomic) IBOutlet ProjectAllBidsView *projectAllBidsView;
@end

@implementation ProjectBidsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _projectNavigationView.projectNavViewDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_projectNavigationView setContractorName:companyName];
    [_projectAllBidsView setItems:bidList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setContractorName:(NSString *)name {
    companyName =name;
    
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
    controller.projectSortViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller  animated:YES completion:nil];
}

#pragma mark - ProjectSortViewController Delegate
- (void)selectedProjectSort:(ProjectSortItems)projectSortItem{
    if (projectSortItem == ProjectSortBidDate) {
        
        NSArray *bids = [bidList mutableCopy];
        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
        NSArray *sorted = [bids sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
        NSLog(@"Test Sorting = %@",sorted);
        
    }
}

#pragma mark - Project Bids Delegate
- (void)setInfoForProjectBids:(NSArray *)bids {
    bidList = [bids mutableCopy];
    
}

- (void)tappedProjectItemBidder:(id)object {
    
}

- (void)tappedProjectItemBidSeeAll:(id)object {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

@end

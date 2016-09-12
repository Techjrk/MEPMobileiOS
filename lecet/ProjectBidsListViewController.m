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
#import "ProjectDetailViewController.h"
#import "DB_Project.h"

@interface ProjectBidsListViewController ()<ProjectNavViewDelegate,ProjectSortViewControllerDelegate, ProjectAllBidsViewDelegate, ProjectTabViewDelegate>{
    NSMutableArray *bidList, *upcomingBid, *pastBid;
    NSString *companyName;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *projectNavigationView;
@property (weak, nonatomic) IBOutlet ProjectTabView *projectTabView;
@property (weak, nonatomic) IBOutlet ProjectAllBidsView *projectAllBidsView;
@end

@implementation ProjectBidsListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:[[self class] description] bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupList];
    
    _projectNavigationView.projectNavViewDelegate = self;
    _projectAllBidsView.projectAllBidsViewDelegate = self;
    _projectTabView.projectTabViewDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_projectNavigationView setContractorName:companyName];
    [_projectAllBidsView setItems:bidList];
}

- (void)setupList {

    if (bidList == nil) {
        upcomingBid = [NSMutableArray new];
        pastBid = [NSMutableArray new];
        bidList = [NSMutableArray new];

    }
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
    NSArray *sorted;
    
    if (projectSortItem == ProjectSortBidDate) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"relationshipProject.bidYearMonthDay" ascending:NO];
        
    }
    if (projectSortItem == ProjectSortLastUpdated) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"relationshipProject.lastPublishDate" ascending:NO];
    }
    
    if (projectSortItem == ProjectSortDateAdded) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"relationshipProject.firstPublishDate" ascending:NO];
        
    }
    if (projectSortItem == ProjectSortHightToLow) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"relationshipProject.estLow" ascending:YES];
    }
    if (projectSortItem == ProjectSortLowToHigh) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"relationshipProject.estHigh" ascending:NO];
    }
    
    bidList = [sorted mutableCopy];
    [_projectAllBidsView setItems:bidList];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSArray *)sortedAssociateProjectsDescriptorKey:(NSString *)keyString ascending:(BOOL)asc {
    NSArray *bids = [bidList mutableCopy];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:keyString ascending:asc];
    NSArray *sorted = [bids sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    return sorted;
}

- (void)selectedAssociatedProjectItem:(id)object {
    ProjectDetailViewController *detail = [ProjectDetailViewController new];
    detail.view.hidden = NO;
    DB_Project *project = object;
    [detail detailsFromProject:project];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - Misc
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

#pragma mark - Project Bids Delegate
- (void)setInfoForProjectBids:(NSArray *)bids {

    [self setupList];
    
    NSDate *currentDate = [NSDate date];
    
    for (DB_Bid *bidItem in bids) {
        
        DB_Project *project = bidItem.relationshipProject;
        
        if (project.bidDate) {
            
            NSDate *bidDate =[DerivedNSManagedObject dateFromDateAndTimeString:project.bidDate];
            
            NSTimeInterval interval = [currentDate timeIntervalSinceDate:bidDate];
            if(  interval > 0) {
                [pastBid addObject:bidItem];
            } else {
                [upcomingBid addObject:bidItem];
            }
            
        } else {
            [upcomingBid addObject:bidItem];
        }
    }
    
}

- (void)selectedProjectAllBidItem:(id)object {

    ProjectDetailViewController *detail = [ProjectDetailViewController new];
    detail.view.hidden = NO;
    DB_Bid *bid = object;
    [detail detailsFromProject:bid.relationshipProject];
    [self.navigationController pushViewController:detail animated:YES];

}

- (void)tappedProjectTab:(ProjectTabItem)projectTabItem {
    if (projectTabItem == ProjectTabPast) {
        bidList = pastBid;
    } else {
        bidList = upcomingBid;
    }
    
    [_projectTabView setCounts:upcomingBid.count past:pastBid.count];
    [_projectAllBidsView setItems:bidList];

}

@end

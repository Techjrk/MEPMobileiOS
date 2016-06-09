//
//  CDAssociatedProjectViewController.m
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CDAssociatedProjectViewController.h"
#import "ProjectNavigationBarView.h"
#import "ProjectSortViewController.h"
#import "ProjectAllAssociatedProjectView.h"
#import "ProjectDetailViewController.h"

@interface CDAssociatedProjectViewController ()<ProjectNavViewDelegate,ProjectSortViewControllerDelegate, ProjectAllAssociatedProjectViewDelegate>{
    NSString *companyName;
    NSMutableArray *associatedProjectList;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *projectNavBarView;
@property (weak, nonatomic) IBOutlet ProjectAllAssociatedProjectView *projectAllAssociatedProjectListView;

//@property (strong,nonatomic) NSMutableArray *associatedProjectList;

@end

@implementation CDAssociatedProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _projectNavBarView.projectNavViewDelegate = self;
    _projectAllAssociatedProjectListView.projectAllAssociatedProjectViewDelegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [_projectNavBarView setContractorName:companyName];
    [_projectNavBarView setProjectTitle:NSLocalizedLanguage(@"ASSOCIATE_ALL_LIST_PROJECT")];
    [_projectAllAssociatedProjectListView setItems:associatedProjectList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setContractorName:(NSString *)name {
    companyName = name;
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


-(void)setInfoForAssociatedProjects:(NSMutableArray *)associatedProjects {
    associatedProjectList = associatedProjects;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ProjectSortView Delegate
- (void)selectedProjectSort:(ProjectSortItems)projectSortItem{
    NSArray *sorted;
    
    if (projectSortItem == ProjectSortBidDate) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"bidDate" ascending:NO];
        
    }
    if (projectSortItem == ProjectSortLastUpdated) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"lastPublishDate" ascending:NO];
    }

    if (projectSortItem == ProjectSortDateAdded) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"firstPublishDate" ascending:NO];
        
    }
    if (projectSortItem == ProjectSortHightToLow) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"estLow" ascending:NO];
    }
    if (projectSortItem == ProjectSortLowToHigh) {
        sorted = [self sortedAssociateProjectsDescriptorKey:@"estLow" ascending:YES];
    }
    
    associatedProjectList = [sorted mutableCopy];
    [_projectAllAssociatedProjectListView setItems:associatedProjectList];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSArray *)sortedAssociateProjectsDescriptorKey:(NSString *)keyString ascending:(BOOL)asc {
    NSArray *bids = [associatedProjectList mutableCopy];
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

@end

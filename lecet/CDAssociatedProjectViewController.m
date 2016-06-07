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

@interface CDAssociatedProjectViewController ()<ProjectNavViewDelegate>{
    NSMutableArray *associatedProjectList;
    NSString *companyName;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *projectNavBarView;
@property (weak, nonatomic) IBOutlet ProjectAllAssociatedProjectView *projectAllAssociatedProjectListView;

@end

@implementation CDAssociatedProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _projectNavBarView.projectNavViewDelegate = self;
    
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

@end

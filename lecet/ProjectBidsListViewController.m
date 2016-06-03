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




@interface ProjectBidsListViewController ()<ProjectNavViewDelegate>{
    
    NSMutableArray *bidList;
    
}

@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *projectNavigationView;

@property (weak, nonatomic) IBOutlet ProjectTabView *projectTabView;
@property (weak, nonatomic) IBOutlet ProjectAllBidsView *projectAllBidsView;



@end

@implementation ProjectBidsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _projectNavigationView.projectNavViewDelegate = self;
    
  
}

-(void)viewWillAppear:(BOOL)animated{
    [_projectAllBidsView setItems:bidList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - ProjectNav Delegate

- (void)tappedProjectNav:(ProjectNavItem)projectNavItem{
    
    if (projectNavItem == ProjectNavReOrder) {
        
        [self tappedReOrderButton];
        
    }
    if (projectNavItem == ProjectNavBackButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
        
}

-(void)tappedReOrderButton{
    ProjectSortViewController *controller = [ProjectSortViewController new];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller  animated:YES completion:nil];
}



#pragma mark - Project Bids Delegate
-(void)setInfoForProjectBids:(NSArray *)bids{
    
    bidList = [bids mutableCopy];
  
}


-(void)tappedProjectItemBidder:(id)object{
    
}
-(void)tappedProjectItemBidSeeAll:(id)object{
    
}




@end

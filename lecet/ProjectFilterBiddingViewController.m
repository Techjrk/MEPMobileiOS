//
//  ProjectFilterBiddingViewController.m
//  lecet
//
//  Created by Michael San Minay on 23/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterBiddingViewController.h"
#import "ProjectFilterSelectionViewList.h"
#import "ProfileNavView.h"

@interface ProjectFilterBiddingViewController ()<ProfileNavViewDelegate,ProjectFilterSelectionViewListDelegate>
@property (weak, nonatomic) IBOutlet ProjectFilterSelectionViewList *projectFilterSlectionViewList;
@property (weak, nonatomic) IBOutlet ProfileNavView *navView;

@end

@implementation ProjectFilterBiddingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView.profileNavViewDelegate = self;
    _projectFilterSlectionViewList.projectFilterSelectionViewListDelegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    
    NSArray *array = @[@"Any",@"Last 24 Hours",@"Last 7 Days",@"Last 30 Days",@"Last 60 Days",@"Last 90 Days",@"Last 6 Months",@"Last 12 Months"];
    [_projectFilterSlectionViewList setInfo:array];
    
    [_navView setNavTitleLabel:NSLocalizedLanguage(@"PROJECT_FILTER_BIDDING_TITLE")];
    [_navView setNavRightButtonTitle:NSLocalizedLanguage(@"PROJECT_FILTER_BIDDING_RIGHTBUTTON_TITLE")];
    [_navView setRigthBorder:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavViewDelegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    switch (profileNavItem) {
        case ProfileNavItemBackButton:{
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ProfileNavItemSaveButton:{
            
            break;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ProjectFilterViewList Delegate

- (void)selectedItem:(NSDictionary *)dict {
    
    NSLog(@"Item %@",dict);
}

@end

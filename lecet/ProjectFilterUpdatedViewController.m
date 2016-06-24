//
//  ProjectFilterUpdatedViewController.m
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterUpdatedViewController.h"
#import "ProjectFilterSelectionViewList.h"
#import "ProfileNavView.h"
#import "projectFilterSelectionConstant.h"

@interface ProjectFilterUpdatedViewController ()<ProfileNavViewDelegate,ProjectFilterSelectionViewListDelegate>
@property (weak, nonatomic) IBOutlet ProfileNavView *navView;
@property (weak, nonatomic) IBOutlet ProjectFilterSelectionViewList *projectFilterSlectionViewList;

@end

@implementation ProjectFilterUpdatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView.profileNavViewDelegate = self;
    _projectFilterSlectionViewList.projectFilterSelectionViewListDelegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    
    
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:@"Any",PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:@"Last 24 Hours",PROJECT_SELECTION_VALUE:@(24),PROJECT_SELECTION_TYPE:@(ProjectFilterItemHours)},
                       @{PROJECT_SELECTION_TITLE:@"Last 7 Days",PROJECT_SELECTION_VALUE:@(7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 30 Days",PROJECT_SELECTION_VALUE:@(30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 90 Days",PROJECT_SELECTION_VALUE:@(90),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 6 Months",PROJECT_SELECTION_VALUE:@(6),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       @{PROJECT_SELECTION_TITLE:@"Last 12 Months",PROJECT_SELECTION_VALUE:@(12),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       ];
    
    
    
    
    [_projectFilterSlectionViewList setInfo:array];
    
    [_navView setNavTitleLabel:NSLocalizedLanguage(@"PROJECT_FILTER_UPDATED_TITLE")];
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

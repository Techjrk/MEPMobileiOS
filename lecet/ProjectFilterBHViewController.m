//
//  ProjectFilterBHViewController.m
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterBHViewController.h"
#import "ProjectFilterSelectionViewList.h"
#import "ProfileNavView.h"


typedef enum  {
    ProjectFilterItemAny = 0,
    ProjectFilterItemHours = 1,
    ProjectFilterItemDays = 2,
    ProjectFilterItemMonths = 3,
} ProjectFilterItem;


#define PROJECT_SELECTION_TITLE @"TITLE"
#define PROJECT_SELECTION_VALUE @"VALUE"
#define PROJECT_SELECTION_TYPE  @"TYPE"

@interface ProjectFilterBHViewController ()<ProfileNavViewDelegate,ProjectFilterSelectionViewListDelegate>
@property (weak, nonatomic) IBOutlet ProfileNavView *navView;
@property (weak, nonatomic) IBOutlet ProjectFilterSelectionViewList *projectFilterSlectionViewList;


@end

@implementation ProjectFilterBHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView.profileNavViewDelegate = self;
    _projectFilterSlectionViewList.projectFilterSelectionViewListDelegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    
    
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BOTH"),PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BLDG"),PROJECT_SELECTION_VALUE:@(102),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_HIGHWAY"),PROJECT_SELECTION_VALUE:@(101),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       ];
    
    
    [_projectFilterSlectionViewList setInfo:array];
    
    [_navView setNavTitleLabel:NSLocalizedLanguage(@"PROJECT_FILTER_BH_TITLE")];
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

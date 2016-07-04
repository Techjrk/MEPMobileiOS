//
//  ProjectFilterSelectionViewController.m
//  lecet
//
//  Created by Michael San Minay on 04/07/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterSelectionViewController.h"

@interface ProjectFilterSelectionViewController ()




@end

@implementation ProjectFilterSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //_navView.profileNavViewDelegate = self;
   // _projectFilterSlectionViewList.projectFilterSelectionViewListDelegate = self;
    
    
    
   /* NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BOTH"),PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BLDG"),PROJECT_SELECTION_VALUE:@(102),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_HIGHWAY"),PROJECT_SELECTION_VALUE:@(101),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       ];
    */
    //[_projectFilterSlectionViewList setInfo:array];
    
    //[_navView setNavTitleLabel:_navTitle];
    //[_navView setNavRightButtonTitle:_navRightButtonTitle];
    //[_navView setRigthBorder:10];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

#pragma mark - NavViewDelegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    switch (profileNavItem) {
        case ProfileNavItemBackButton:{
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ProfileNavItemSaveButton:{
          //  [_projectFilterSelectionViewControllerDelegate tappedApplyButton:dataSelected];
            break;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ProjectFilterViewList Delegate

- (void)selectedItem:(NSDictionary *)dict {
  //  dataSelected = dict;
}
*/

@end

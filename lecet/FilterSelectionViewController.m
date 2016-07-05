//
//  FilterSelectionViewController.m
//  lecet
//
//  Created by Michael San Minay on 05/07/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "FilterSelectionViewController.h"
#import "ProfileNavView.h"
#import "ProjectFilterSelectionViewList.h"

@interface FilterSelectionViewController ()<ProjectFilterSelectionViewListDelegate,ProfileNavViewDelegate>{
    NSDictionary *dataSelected;
}
@property (weak, nonatomic) IBOutlet ProfileNavView *navView;
@property (weak, nonatomic) IBOutlet ProjectFilterSelectionViewList *projectFilterSlectionViewList;

@end

@implementation FilterSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _navView.profileNavViewDelegate = self;
    _projectFilterSlectionViewList.projectFilterSelectionViewListDelegate = self;
    
    [_projectFilterSlectionViewList setInfo:_dataInfo];
    
    [_navView setNavTitleLabel:_navTitle];
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
            [_filterSelectionViewControllerDelegate tappedApplyButton:dataSelected];
            break;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ProjectFilterViewList Delegate

- (void)selectedItem:(NSDictionary *)dict {
      dataSelected = dict;
}
@end

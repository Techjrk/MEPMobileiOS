//
//  ProjectFilterLocationViewController.m
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterLocationViewController.h"
#import "ProjectFilterSearchNavView.h"
#import "ProjectFilterCollapsibleListView.h"

@interface ProjectFilterLocationViewController ()<ProjectFilterSearchNavViewDelegate>
@property (weak, nonatomic) IBOutlet ProjectFilterSearchNavView *navView;
@property (weak, nonatomic) IBOutlet ProjectFilterCollapsibleListView *listView;


@end

@implementation ProjectFilterLocationViewController
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"
#define SELECTIONFLAGNAME           @"selectionFlag"
#define DROPDOWNFLAGNAME            @"dropDownFlagName"
#define TITLENAME                   @"TITLE"
#define SUBCATEGORYDATA             @"SubData"
#define SECONDSUBCATDATA            @"SECONDSUBCATDATA"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _navView.projectFilterSearchNavViewDelegate = self;
    [self enableTapGesture:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    NSArray *array = @[@{TITLENAME:@"One",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                         SUBCATEGORYDATA:
                             @[@{TITLENAME:@"SubOne",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                                 SECONDSUBCATDATA:@[
                                         @{TITLENAME:@"SecSubOne",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag}
                                         ]
                                 }]
                         },
                       @{TITLENAME:@"Two",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                         SUBCATEGORYDATA:@[]
                         },
                       @{TITLENAME:@"three",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                         SUBCATEGORYDATA:@[
                                 @{TITLENAME:@"SubThreeOne",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag},
                                 @{TITLENAME:@"SubThreeTwo",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag},
                                 @{TITLENAME:@"SubThreeThree",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag}]
                         },
                       @{TITLENAME:@"Four",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                         SUBCATEGORYDATA:@[]
                         },
                       @{TITLENAME:@"Five",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,
                         SUBCATEGORYDATA:@[]
                         }
                       ];
    
    [_listView setInfo:array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark Nav Delegate
- (void)tappedFilterSearchNavButton:(ProjectFilterSearchNavItem)item {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

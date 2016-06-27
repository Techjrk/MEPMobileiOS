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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _navView.projectFilterSearchNavViewDelegate = self;
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

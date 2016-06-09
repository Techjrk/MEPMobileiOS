//
//  MyProfileViewController.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ProfileNavView.h"

@interface MyProfileViewController ()<ProfileNavViewDelegate>
@property (weak, nonatomic) IBOutlet ProfileNavView *profileNavView;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_profileNavView setNavTitleLabel:@"My Profile"];
    _profileNavView.profileNavViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav View Delegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


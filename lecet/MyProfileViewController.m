//
//  MyProfileViewController.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ProfileNavView.h"
#import "MyProfileView.h"

@interface MyProfileViewController ()<ProfileNavViewDelegate> {
    
    id myProfileInfo;
}
@property (weak, nonatomic) IBOutlet ProfileNavView *profileNavView;
@property (weak, nonatomic) IBOutlet MyProfileView *myProfileView;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_profileNavView setNavTitleLabel:@"My Profile"];
    _profileNavView.profileNavViewDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_myProfileView setInfo:myProfileInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav View Delegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setInfo:(id)info {
    myProfileInfo = info;
}

@end


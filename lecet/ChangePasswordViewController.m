//
//  ChangePasswordViewController.m
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ProfileNavView.h"
#import "ChangePasswordView.h"
#import "ProfileNavView.h"

@interface ChangePasswordViewController ()<ProfileNavViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet ProfileNavView *profileNavView;
@property (weak, nonatomic) IBOutlet ChangePasswordView *chnagePasswordView;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _profileNavView.profileNavViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ProfileNav Delegate
- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

//
//  CustomLandscapeNavigationViewController.m
//  lecet
//
//  Created by Michael San Minay on 27/04/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CustomLandscapeNavigationViewController.h"

@interface CustomLandscapeNavigationViewController ()

@end

@implementation CustomLandscapeNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)isNavigationBarHidden {
    return NO;
}





@end

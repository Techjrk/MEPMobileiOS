//
//  IntentViewController.m
//  ProjectNearMeUI
//
//  Created by Harry Herrys Camigla on 7/25/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "IntentViewController.h"

@interface IntentViewController ()

@end

@implementation IntentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - INUIHostedViewControlling

// Prepare your view controller for the interaction to handle.
- (void)configureWithInteraction:(INInteraction *)interaction context:(INUIHostedViewContext)context completion:(void (^)(CGSize))completion {
    // Do configuration here, including preparing views and calculating a desired size for presentation.
    
    if (completion) {
        completion([self desiredSize]);
    }
}

- (CGSize)desiredSize {
    return [self extensionContext].hostedViewMaximumAllowedSize;
}

@end

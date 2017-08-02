//
//  ProjectNearIntentViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 7/31/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearIntentViewController.h"

@interface ProjectNearIntentViewController ()

@end

@implementation ProjectNearIntentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)configureViewForParameters:(NSSet<INParameter *> *)parameters ofInteraction:(INInteraction *)interaction interactiveBehavior:(INUIInteractiveBehavior)interactiveBehavior context:(INUIHostedViewContext)context completion:(void (^)(BOOL, NSSet<INParameter *> * _Nonnull, CGSize))completion {
    
}
- (CGSize)desiredSize {
    return [self extensionContext].hostedViewMaximumAllowedSize;
}

@end

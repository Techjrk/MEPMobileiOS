//
//  BaseViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UINavigationControllerDelegate>{
    BOOL previousControllerHidden;
}
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapRecognizer];
    [self enableTapGesture:NO];
    self.navigationController.delegate = self;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
     [self.view endEditing:YES];
}

- (void)enableTapGesture:(BOOL)enable {
    _tapRecognizer.enabled = enable;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    BaseViewController *fromViewController = (BaseViewController*)fromVC;
    BaseViewController *toViewController = (BaseViewController*)toVC;
    
    BaseViewController *controller = operation != UINavigationControllerOperationPop?fromViewController:toViewController;
    
    controller.navigationController.delegate = controller;
    
    return [controller animationObjectForOperation:operation];
}

- animationObjectForOperation:(UINavigationControllerOperation)operation {
    return nil;
}

@end

//
//  BaseViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapRecognizer];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
     [self.view endEditing:YES];
}

@end

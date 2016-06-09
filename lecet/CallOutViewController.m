//
//  CallOutViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/8/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CallOutViewController.h"

#import "CustomCallOut.h"

@interface CallOutViewController ()<UIPopoverPresentationControllerDelegate>{
    NSDictionary *infoDict;
}
@property (weak, nonatomic) IBOutlet CustomCallOut *callOut;
@end

@implementation CallOutViewController
@synthesize sourceView;

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.delegate = self;
    }
    return self;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_callOut setInfo:infoDict];

}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    CGPoint point = [sender locationInView:view];
    UIView* subview = [view hitTest:point withEvent:nil];
    
    if ([subview isEqual:self.view]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGSize)preferredContentSize {
    return CGSizeMake(kDeviceWidth * 0.44, kDeviceHeight * 0.245);
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (void)setInfo:(id)info {
    infoDict = [info copy];
}

@end

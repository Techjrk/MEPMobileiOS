//
//  CallOutViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/8/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CallOutViewController.h"

#import "CustomCallOut.h"
#import "ProjectAnnotationView.h"
#import "ProjectDetailViewController.h"

@interface CallOutViewController ()<UIPopoverPresentationControllerDelegate>{
    NSDictionary *infoDict;
}
@property (weak, nonatomic) IBOutlet CustomCallOut *callOut;
@end

@implementation CallOutViewController
@synthesize sourceView;
@synthesize projectPin;
@synthesize parentCtrl;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationViewProject:) name:NOTIFICATION_VIEW_PROJECT object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_callOut setInfo:infoDict];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    ProjectAnnotationView *annotation = (ProjectAnnotationView*)self.projectPin;
    annotation.image = annotation.isPreBid?[UIImage imageNamed:@"icon_pinGreen"]:[UIImage imageNamed:@"icon_pinRed"];

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

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    CGPoint point = [sender locationInView:view];
    UIView* subview = [view hitTest:point withEvent:nil];
    
    if ([subview isEqual:self.view]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }

}

- (void)setInfo:(id)info {
    infoDict = [info copy];
}

- (void)NotificationViewProject:(NSNotification*)notification {
    
    NSNumber *recordId = notification.object;
    [[DataManager sharedManager] projectDetail:recordId success:^(id object) {
        
        ProjectDetailViewController *detail = [ProjectDetailViewController new];
        detail.view.hidden = NO;
        [detail detailsFromProject:object];
        
        [self.parentCtrl.navigationController pushViewController:detail animated:YES];
    } failure:^(id object) {
    }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

@end

//
//  PanoramaViewerViewController.m
//  lecet
//
//  Created by Michael San Minay on 27/04/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "PanoramaViewerViewController.h"

@interface PanoramaViewerViewController ()

@end

@implementation PanoramaViewerViewController

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (instancetype)init {
    self = [super init];

    return self;
}
*/
- (void)loadView {
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    _panoViewer = [[PanoViewer alloc] initWithFrame:CGRectMake(0, 0, kDeviceHeight, kDeviceWidth)];
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(showNavBar:)];
    [singleFingerTap requireGestureRecognizerToFail:_panoViewer.doubleTapGR];

    self.view = _panoViewer;
    
}

- (void)showNavBar:(UIGestureRecognizer*)gestureRecognizer
{
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    return;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationController:self.navigationController];

    [self startViewer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopViewer];
    [super viewWillDisappear:animated];
}

#pragma mark DMD Viewer

- (void)startViewer
{
    [_panoViewer performSelector:@selector(start) onThread:[Monitor instance].engineMgr.thread withObject:nil waitUntilDone:NO];
}

- (void)stopViewer
{
    [_panoViewer performSelector:@selector(stop) onThread:[Monitor instance].engineMgr.thread withObject:nil waitUntilDone:NO];
}

- (void)setupNavigationController:(UINavigationController*)nav
{
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nav.toolbarHidden = YES;
    nav.toolbar.barStyle = UIBarStyleBlack;
    nav.toolbar.translucent = YES;
    nav.navigationBar.hidden = NO;
    nav.navigationBar.barStyle = UIBarStyleBlack;
    nav.navigationBar.translucent = YES;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(continueShooting:)] ;
    nav.topViewController.navigationItem.rightBarButtonItem = back;
}

- (void)continueShooting:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end

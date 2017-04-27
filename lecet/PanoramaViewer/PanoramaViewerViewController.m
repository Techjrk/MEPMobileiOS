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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init {
    self = [super init];

    return self;
}

- (void)loadView {
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    _panoViewer = [[PanoViewer alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
    self.view = _panoViewer;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self startViewer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopViewer];
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

@end

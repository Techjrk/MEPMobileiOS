//
//  PanoramaViewerViewController.m
//  lecet
//
//  Created by Michael San Minay on 27/04/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "PanoramaSceneViewController.h"

#pragma mark - FONT
#define FONT_NAV_BUTTON                     fontNameWithSize(FONT_NAME_LATO_BOLD, 14)

#pragma mark - COLOR
#define COLOR_FONT_NAV_BUTTON               RGB(168,195,230)

@interface PanoramaSceneViewController () {
    NSTimer *hideTimer;
}
@property (weak, nonatomic) IBOutlet UIView *navView;
//@property (strong, nonatomic) NSTimer *hideTimer;

@end

@implementation PanoramaSceneViewController

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setHideTimer:1.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {

    self.panoViewer = [[PanoViewer alloc] initWithFrame:CGRectMake(0, 0, kDeviceHeight, kDeviceWidth)];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(showNavBar:)];
    [singleFingerTap requireGestureRecognizerToFail:_panoViewer.doubleTapGR];
    [self.panoViewer addGestureRecognizer:singleFingerTap];


    self.view = self.panoViewer;
    [self.view addSubview:self.navView];
}

- (void)showNavBar:(UIGestureRecognizer*)gestureRecognizer
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setHideTimer:5.0];

    return;
}

- (void)hideNavBar:(NSTimer*)theTimer
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    hideTimer = nil;
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
- (IBAction)tappedDoneButton:(id)sender {
    if (self.panoramaViewerViewControllerDelegate == nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.panoramaViewerViewControllerDelegate tappedDoneButtonPanoramaViewer];
    }
}

#pragma mark DMD Viewer

- (void)startViewer
{
    [_panoViewer performSelector:@selector(start) onThread:[Monitor instance].engineMgr.thread withObject:self.image waitUntilDone:NO];
}

- (void)stopViewer
{
    [_panoViewer performSelector:@selector(stop) onThread:[Monitor instance].engineMgr.thread withObject:self.image waitUntilDone:NO];
}


#pragma mark - MISC METHOD

- (void)setupNavigationController:(UINavigationController*)nav
{
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nav.toolbarHidden = YES;
    nav.toolbar.barStyle = UIBarStyleBlackTranslucent;
    nav.toolbar.translucent = YES;
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    nav.navigationBar.translucent = YES;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tappedDoneButton:)];
    [back setTitle:@"DONE"];
    [back setTitleTextAttributes:@{NSFontAttributeName:FONT_NAV_BUTTON,NSForegroundColorAttributeName:COLOR_FONT_NAV_BUTTON}  forState:UIControlStateNormal];
    
    nav.topViewController.navigationItem.rightBarButtonItem = back;
}

- (void)continueShooting:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)setHideTimer:(NSTimeInterval)ti
{
    [hideTimer invalidate];
    hideTimer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(hideNavBar:) userInfo:nil repeats:NO];
}



@end

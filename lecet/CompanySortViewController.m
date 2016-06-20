//
//  CompanySortViewController.m
//  lecet
//
//  Created by Michael San Minay on 19/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanySortViewController.h"
#import "CompanySortView.h"
#import "TriangleView.h"

@interface CompanySortViewController ()<CompanySortDelegate>
@property (weak, nonatomic) IBOutlet CompanySortView *companySortView;
@property (weak, nonatomic) IBOutlet UIView *tempNavBar;
@property (weak, nonatomic) IBOutlet UIView *backgrounView;
@property (weak, nonatomic) IBOutlet TriangleView *triangleView;

@end

@implementation CompanySortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _companySortView.companySortDelegate = self;
    [self enableTapGesture:YES];
    [self addTappedGesture];
    
    [_triangleView setObjectColor:COMPANYTRACKINGVIEW_VIEW_BG_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTappedGesture {
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDropDownViewController)];
    tapped.numberOfTapsRequired = 1;
    [_backgrounView addGestureRecognizer:tapped];
    
    UITapGestureRecognizer *tappedNav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDropDownViewController)];
    tappedNav.numberOfTapsRequired = 1;
    [_tempNavBar addGestureRecognizer:tappedNav];
}
- (void)dismissDropDownViewController {
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}
#pragma mark - CompanySortViewDelegate

- (void)selectedSort:(CompanySortItem)item {
    
    [_companySortDelegate selectedSort:item];
    [[DataManager sharedManager] featureNotAvailable];
    
}



@end

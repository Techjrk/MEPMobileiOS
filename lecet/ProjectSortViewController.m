//
//  ProjectSortViewController.m
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectSortViewController.h"
#import "TriangleView.h"
#import "ProjectSortView.h"

@interface ProjectSortViewController ()<ProjectSortViewDelegate,ProjectSortViewDelegate>
@property (weak, nonatomic) IBOutlet ProjectSortView *projectSortView;

@property (weak, nonatomic) IBOutlet TriangleView *triangleView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIView *tempNavigationBar;

@end

@implementation ProjectSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_triangleView setObjectColor:PROJECTSORT_TITLEVIEW_BG_COLOR];
    [self addTappedGesture];
    _projectSortView.projectSortViewDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Project Sort View Delegate
- (void)selectedProjectSort:(ProjectSortItems)projectSortItem {
    
    [_projectSortViewControllerDelegate selectedProjectSort:projectSortItem];
    
}

- (void)addTappedGesture {
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDropDownViewController)];
    tapped.numberOfTapsRequired = 1;
    [_backGroundView addGestureRecognizer:tapped];
    
    
    UITapGestureRecognizer *tappedNav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDropDownViewController)];
    tappedNav.numberOfTapsRequired = 1;
    [_tempNavigationBar addGestureRecognizer:tappedNav];
}

- (void)dismissDropDownViewController {
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}



@end

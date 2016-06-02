//
//  ProjectSortViewController.m
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectSortViewController.h"
#import "ProjectSortView.h"
#import "TriangleView.h"

@interface ProjectSortViewController ()<ProjectSortViewDelegate>
@property (weak, nonatomic) IBOutlet ProjectSortView *projectSortView;

@property (weak, nonatomic) IBOutlet TriangleView *triangleView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end

@implementation ProjectSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_triangleView setObjectColor:[UIColor whiteColor]];
    [self addTappedGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Project Sort View Delegate
-(void)selectedProjectSort:(ProjectSortItems)projectSortItem{
    
    [[DataManager sharedManager] featureNotAvailable];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)addTappedGesture{
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDropDownViewController)];
    tapped.numberOfTapsRequired = 1;
    [_backGroundView addGestureRecognizer:tapped];
    
}


- (void)dismissDropDownViewController{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}


@end

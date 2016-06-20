//
//  EditViewController.m
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "EditViewController.h"
#import "ProjectNavigationBarView.h"
#import "EditTabView.h"

@interface EditViewController ()<ProjectNavViewDelegate>
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *navView;
@property (weak, nonatomic) IBOutlet EditTabView *tabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEditViewHeight;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView.projectNavViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tappedProjectNav:(ProjectNavItem)projectNavItem {
    switch (projectNavItem) {
        case ProjectNavBackButton:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ProjectNavReOrder:{
            [[DataManager sharedManager] featureNotAvailable];
            break;
        }
            
    }
}

@end

//
//  ProjectDetailStateViewController.m
//  lecet
//
//  Created by Michael San Minay on 27/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectDetailStateViewController.h"
#import "ProjectDetailStateView.h"


@interface ProjectDetailStateViewController ()<ProjectDetailStateDelegate>{
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDetailStateViewHeight;
@property (weak, nonatomic) IBOutlet ProjectDetailStateView *projectDetailSateView;

@end

@implementation ProjectDetailStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //ProjectDetailStateView
    _projectDetailSateView.projectDetailStateDelegate = self;
    
    [self addTappedGesture];
    
    
    [self setAutoLayConstraintInIncompatibleDevice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProjectDetailState)];
    tapped.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapped];
    
}

- (void)hideProjectDetailState{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setAutoLayConstraintInIncompatibleDevice{
    
    if (isiPhone4) {

        
        //Share List
        _constraintDetailStateViewHeight.constant = 20;
    }
    
    
    
    
}


#pragma mark - Project Detail State Delegate


- (void)tappedProjectDetailState:(ProjectDetailStateItem)projectDetailStteItesm{

    if (projectDetailStteItesm == ProjectDetailStateCancel) {
        
        [self hideProjectDetailState];
        
        
    }else{
        
        [[DataManager sharedManager] promptMessage:@"Hide Project been Tapped"];
        
    }

}


@end

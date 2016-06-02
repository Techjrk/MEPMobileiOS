//
//  ProjectShareViewController.m
//  lecet
//
//  Created by Michael San Minay on 01/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectShareViewController.h"
#import "DropDownMenuShareList.h"
#define SYSTEM_VERSION_LESS_THAN(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
@interface ProjectShareViewController ()<DropDownShareListDelegate>{
    
    CGRect projectStateViewFrame;
    CGRect dropDonwShareListFrame;
}
@property (weak, nonatomic) IBOutlet UIView *tempProjectStateView;
@property (weak, nonatomic) IBOutlet DropDownMenuShareList *shareListView;

@end

@implementation ProjectShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _shareListView.dropDownShareListDelegate = self;
    [self addTappedGesture];
}


-(void)viewDidLayoutSubviews{
    
    [_tempProjectStateView setFrame:projectStateViewFrame];
  //  [_shareListView setFrame:dropDonwShareListFrame];
    
    CGRect frame = _shareListView.frame;
    
    frame.origin.y = dropDonwShareListFrame.origin.y;
    
    [_shareListView setFrame:frame];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DropDown ShareListView Delegate

- (void)tappedDropDownShareList:(DropDownShareListItem)shareListItem{
    
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



-(void)setProjectState:(UIView *)stateView {
    
    CGPoint viewCenter = CGPointMake(stateView.bounds.origin.x + stateView.bounds.size.width/2,
                                     (stateView.bounds.origin.y /2) + stateView.bounds.size.height/ 2);
    CGPoint p = [stateView convertPoint:viewCenter toView:self.view];
    
    
    CGRect frame = stateView.frame;
    projectStateViewFrame = frame;
    dropDonwShareListFrame = _shareListView.frame;
    
    if (isiPhone6Plus) {
        
        
        
        if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
            
            projectStateViewFrame.origin.y = p.y - (p.y * 0.67f);
            
            dropDonwShareListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) ;
        }else{
            
            projectStateViewFrame.origin.y = p.y;
            dropDonwShareListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 5;
            
        }
        
        
        
    }
    
    if (isiPhone5 || isiPhone6) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
            
            projectStateViewFrame.origin.y = p.y - (p.y * 0.5f);
            
            dropDonwShareListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 5;
            
            
        }else{
            
            projectStateViewFrame.origin.y = p.y;
            dropDonwShareListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 5;
            
        }
        
        
        
    }
    
    if (isiPhone4) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
            
            projectStateViewFrame.origin.y = p.y - (p.y * 0.5f);
            
            dropDonwShareListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 2;
            
            
        }else{
            
            projectStateViewFrame.origin.y = p.y;
            
            dropDonwShareListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 2;
            
            
        }
        
    }
}


- (void)addTappedGesture{
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDropDownViewController)];
    tapped.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapped];
    
}


- (void)dismissDropDownViewController{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    [_projectShareListViewControllerDelegate tappedDismissedProjectShareList];
}



@end

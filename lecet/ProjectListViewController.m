//
//  ProjectListViewController.m
//  lecet
//
//  Created by Michael San Minay on 27/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectListViewController.h"
#import "DropDownProjectList.h"

#define SYSTEM_VERSION_LESS_THAN(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface ProjectListViewController ()<DropDownProjectListDelegate>{
    
    CGRect projectStateViewFrame;
    CGRect dropDonwProjectListFrame;
    
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProjectListTop;
@property (weak, nonatomic) IBOutlet UIView *tempProjectStateView;

@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@property (weak,nonatomic) IBOutlet DropDownProjectList *dropDownProjectListView;



@end

@implementation ProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTappedGesture];
    _dropDownProjectListView.dropDownProjectListDelegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLayoutSubviews {

    [_tempProjectStateView setFrame:projectStateViewFrame];
    [_dropDownProjectListView setFrame:dropDonwProjectListFrame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProjectStateViewFrame:(UIView *)stateView {
    
    CGPoint viewCenter = CGPointMake(stateView.bounds.origin.x + stateView.bounds.size.width/2,
                                       stateView.bounds.origin.y + stateView.bounds.size.height/ 2);
    CGPoint p = [stateView convertPoint:viewCenter toView:self.view];
    CGRect frame = stateView.frame;
    projectStateViewFrame = frame;
    dropDonwProjectListFrame = _dropDownProjectListView.frame;
    
    if (isiPhone6Plus) {

        if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
            projectStateViewFrame.origin.y = p.y - (p.y * 0.67f);
            dropDonwProjectListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) ;
        }else{
            projectStateViewFrame.origin.y = p.y;
            dropDonwProjectListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 5;
        }
    }
    
    if (isiPhone5 || isiPhone6) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
            projectStateViewFrame.origin.y = p.y - (p.y * 0.5f);
            dropDonwProjectListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 5;
            
        }else{
            projectStateViewFrame.origin.y = p.y;
            dropDonwProjectListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 5;
        }
    }
    
    if (isiPhone4) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
            projectStateViewFrame.origin.y = p.y - (p.y * 0.5f);
            dropDonwProjectListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 2;
            
        }else {
            projectStateViewFrame.origin.y = p.y;
            dropDonwProjectListFrame.origin.y = (projectStateViewFrame.origin.y + projectStateViewFrame.size.height) - 2;
        }
        
    }
    
}


- (void)addTappedGesture {
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProjectTrackList)];
    tapped.numberOfTapsRequired = 1;
    [_viewBackground addGestureRecognizer:tapped];
    
    UITapGestureRecognizer *tappedHiddenProjectState = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProjectTrackList)];
    tappedHiddenProjectState.numberOfTapsRequired = 1;
    [_tempProjectStateView addGestureRecognizer:tappedHiddenProjectState];
    
}

- (void)hideProjectTrackList {
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    [_projectTrackListViewControllerDelegate tappedDismissedProjectTrackList];
}



#pragma mark - DropDownProlist Delegate

- (void)selectedDropDownProjectList:(NSIndexPath *)indexPath {
    [[DataManager sharedManager] featureNotAvailable];
    
}
@end

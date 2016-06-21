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
#import "SelectMoveView.h"
#import "PopupViewController.h"

@interface EditViewController ()<ProjectNavViewDelegate,SelectMoveViewDelegate,EditTabViewDelegate>{
    BOOL isInEditMode;;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *navView;
@property (weak, nonatomic) IBOutlet EditTabView *tabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEditViewHeight;
@property (weak, nonatomic) IBOutlet SelectMoveView *selectMoveView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _constraintEditViewHeight.constant = 0;
    _navView.projectNavViewDelegate = self;
    _selectMoveView.selectMoveViewDelegate = self;
    _tabView.editTabViewDelegate = self;
    
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

- (void)tappedMoveItem:(id)object shouldMove:(BOOL)shouldMove {
   
    
}

#pragma mark - CustomCollectionView Delegate

#pragma mark - EdittabViewDelgate
- (void)selectedEditTabButton:(EditTabItem)item {
    
    
    [self chageEditMode:NO];
    
}


#pragma mark - Misc Method
- (void)chageEditMode:(BOOL)editMode {
    isInEditMode = editMode;
   
    
    if (!isInEditMode) {
        _constraintEditViewHeight.constant = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
           _constraintEditViewHeight.constant = kDeviceHeight * 0.09;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    
}




@end

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
#import "EditViewList.h"
#import "CompanySortViewController.h"

@interface EditViewController ()<ProjectNavViewDelegate,SelectMoveViewDelegate,EditTabViewDelegate,EditViewListDelegate>{
    BOOL isInEditMode;;
    NSMutableArray *collectionDataItems;
}
@property (weak, nonatomic) IBOutlet ProjectNavigationBarView *navView;
@property (weak, nonatomic) IBOutlet EditTabView *tabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEditViewHeight;
@property (weak, nonatomic) IBOutlet SelectMoveView *selectMoveView;
@property (weak, nonatomic) IBOutlet EditViewList *editViewList;

@end

@implementation EditViewController
#define BOTTOMVIEW_BG_COLOR RGB(5, 35, 74)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _constraintEditViewHeight.constant = 0;
    _navView.projectNavViewDelegate = self;
    _selectMoveView.selectMoveViewDelegate = self;
    _tabView.editTabViewDelegate = self;
    _editViewList.editViewListDelegate = self;
    
    [_selectMoveView setBackgroundColor:BOTTOMVIEW_BG_COLOR];
}

- (void)viewWillAppear:(BOOL)animated {
    [_editViewList setInfo:collectionDataItems];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(id)items {
    collectionDataItems = items;
    
}

#pragma mark - Nav Delegate
- (void)tappedProjectNav:(ProjectNavItem)projectNavItem {
    switch (projectNavItem) {
        case ProjectNavBackButton:{
            [self dismissViewControllerAnimated:NO completion:^{
                [_editViewControllerDelegate tappedCancelDoneButton:collectionDataItems];
                [_editViewControllerDelegate tappedBackButton];
                
            }];
            
            break;
        }
        case ProjectNavReOrder:{
            CompanySortViewController *controller = [[CompanySortViewController alloc] initWithNibName:@"CompanySortViewController" bundle:nil];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:controller  animated:NO completion:nil];
            break;
        }
            
    }
}

- (void)tappedMoveItem:(id)object shouldMove:(BOOL)shouldMove {
   
    
}

#pragma mark - CustomCollectionView Delegate

#pragma mark - EdittabViewDelgate
- (void)selectedEditTabButton:(EditTabItem)item {

    [self dismissViewControllerAnimated:NO completion:^{
        [_editViewControllerDelegate tappedCancelDoneButton:collectionDataItems];
    }];
    
    
    
}



#pragma mark - Misc Method
- (void)chageEditMode:(BOOL)editMode count:(int)count{
    isInEditMode = editMode;
   
    if (!isInEditMode) {
        _constraintEditViewHeight.constant = 0;
        CGFloat heightPopUpView = kDeviceHeight * (count > 0?0.09:0);
        
        [UIView animateWithDuration:0.25 animations:^{
            _constraintEditViewHeight.constant = heightPopUpView;
            
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

#pragma mark - EditViewListDelegate

- (void)selectedButtonCountInCell:(int)count {
    
    [_selectMoveView setSelectionCount:(NSInteger)count];
    [self chageEditMode:NO count:count];
}



@end

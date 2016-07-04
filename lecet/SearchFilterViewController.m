//
//  SearchFilterViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchFilterViewController.h"

#import "ProjectFilterView.h"
#import "CompanyFilterView.h"
#import "FilterEntryView.h"
#import "FilterLabelView.h"
#import "FilterViewController.h"
#import "ListItemExpandingViewCell.h"
#import "WorkOwnerTypesViewController.h"
#import "ProjectFilterTypesViewController.h"
#import "ProjectFilterLocationViewController.h"
#import "ProjectFilterBiddingViewController.h"
#import "ProjectFilterUpdatedViewController.h"
#import "ProjectFilterBHViewController.h"
#import "ValuationViewController.h"
#import "ProjectFilterSelectionViewController.h"
#import "TesrViewController.h"

#define TITLE_FONT                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 14)
#define TITLE_COLOR                         RGB(255, 255, 255)

#define BUTTON_FILTER_FONT                  fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 14)
#define BUTTON_FILTER_COLOR                 RGB(168, 195, 230)

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)

#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"
#define SELECTIONFLAGNAME           @"selectionFlag"

@interface SearchFilterViewController ()<ProjectFilterViewDelegate,WorkOwnerTypesViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topHeader;
@property (weak, nonatomic) IBOutlet UIView *markerView;
@property (weak, nonatomic) IBOutlet UIButton *buttonProject;
@property (weak, nonatomic) IBOutlet UIButton *buttonCompany;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonApply;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet ProjectFilterView *projectFilter;
@property (weak, nonatomic) IBOutlet UIScrollView *projectScrollView;
@property (weak, nonatomic) IBOutlet CompanyFilterView *companyFilter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMarkerLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProjectFilterHeight;
- (IBAction)tappedButton:(id)sender;
- (IBAction)tappedButtonCancel:(id)sender;
- (IBAction)tappedButtonApply:(id)sender;
@end

@implementation SearchFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topHeader.backgroundColor = TOP_HEADER_BG_COLOR;
    _markerView.backgroundColor = BUTTON_MARKER_COLOR;
    
    _buttonProject.titleLabel.font = BUTTON_FONT;
    [_buttonProject setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [_buttonProject setTitle:NSLocalizedLanguage(@"SEARCH_FILTER_PROJECT") forState:UIControlStateNormal];

    _buttonCompany.titleLabel.font = BUTTON_FONT;
    [_buttonCompany setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [_buttonCompany setTitle:NSLocalizedLanguage(@"SEARCH_FILTER_COMPANY") forState:UIControlStateNormal];

    [_buttonCancel setTitleColor:BUTTON_FILTER_COLOR forState:UIControlStateNormal];
    _buttonCancel.titleLabel.font = BUTTON_FILTER_FONT;
    [_buttonCancel setTitle:NSLocalizedLanguage(@"SEARCH_FILTER_CANCEL") forState:UIControlStateNormal];

    [_buttonApply setTitleColor:BUTTON_FILTER_COLOR forState:UIControlStateNormal];
    _buttonApply.titleLabel.font = BUTTON_FILTER_FONT;
    [_buttonApply setTitle:NSLocalizedLanguage(@"SEARCH_FILTER_APPLY") forState:UIControlStateNormal];
    
    _labelTitle.font = TITLE_FONT;
    _labelTitle.textColor = TITLE_COLOR;
    _labelTitle.text = NSLocalizedLanguage(@"SEARCH_FILTER_TITLE");
    
    [_projectFilter setConstraint:_constraintProjectFilterHeight];
    _projectFilter.scrollView = _projectScrollView;
    _projectFilter.projectFilterViewDelegate = self;
    _companyFilter.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}


- (IBAction)tappedButton:(id)sender {
    UIButton *button = sender;

    _constraintMarkerLeading.constant = button.frame.origin.x;
    
    
    [UIView animateWithDuration:0.25 animations:^{
    
        [self.view layoutIfNeeded];
    
    } completion:^(BOOL finished) {
        
        if (finished) {
            _projectScrollView.hidden = _constraintMarkerLeading.constant != 0;
            _companyFilter.hidden = !_projectScrollView.hidden;
        }
    }];
    
}

- (IBAction)tappedButtonCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)tappedButtonApply:(id)sender {
    [[DataManager sharedManager] featureNotAvailable];
    
}

#pragma mark - ProjectFilterViewDelegate
#pragma mark - Owner Types

- (void)tappedFilterItem:(id)object {
    
    
    FilterModel model = 0;
    BOOL shouldProcess = NO;
    
    if ([object class] == [FilterLabelView class]) {
        
        model = [(FilterLabelView*)object filterModel];
        shouldProcess = YES;
        
    } else if([object class] == [FilterEntryView class]) {
        
        model = [(FilterEntryView*)object filterModel];
        shouldProcess = YES;
    }
    
    if (shouldProcess) {
        
        switch (model) {
            case FilterModelLocation: {
                ProjectFilterLocationViewController *controller = [ProjectFilterLocationViewController new];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case FilterModelType: {
                [self pushProjectFilterTypes];
                break;
            }
                
            case FilterModelValue: {
                ValuationViewController *controller =  [ValuationViewController new];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case FilterModelUpdated: {
                ProjectFilterUpdatedViewController *controller = [ProjectFilterUpdatedViewController new];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case FilterModelJurisdiction: {
                
                FilterViewController *controller = [FilterViewController new];
                
                NSMutableDictionary *dict1 = [@{LIST_VIEW_NAME:@"VALUE01"} mutableCopy];
                NSMutableDictionary *dict2 = [@{LIST_VIEW_NAME:@"VALUE02"} mutableCopy];
                NSMutableDictionary *dict3 = [@{LIST_VIEW_NAME:@"VALUE03"} mutableCopy];
                
                NSDictionary *dictArray1 = [@{LIST_VIEW_NAME:@"SUB01", LIST_VIEW_SUBITEMS:@[dict1, dict2, dict3]}mutableCopy];
                NSDictionary *dictArray2 = [@{LIST_VIEW_NAME:@"SUB02",LIST_VIEW_SUBITEMS:@[dict1, dict2, dict3]}mutableCopy];
                NSDictionary *dictArray3 = [@{LIST_VIEW_NAME:@"SUB03",LIST_VIEW_SUBITEMS:@[dict1, dict2, dict3]}mutableCopy];
                NSDictionary *dictArray4 = [@{LIST_VIEW_NAME:@"SUB04",LIST_VIEW_SUBITEMS:@[dict1, dict2, dict3]}mutableCopy];
                NSDictionary *dictArray5 = [@{LIST_VIEW_NAME:@"SUB05",LIST_VIEW_SUBITEMS:@[dict1, dict2, dict3]}mutableCopy];
                NSDictionary *dictArray6 = [@{LIST_VIEW_NAME:@"SUB06",LIST_VIEW_SUBITEMS:@[dictArray5, dict2, dict3]}mutableCopy];
                
                
                /*
                 controller.listViewItems = [@[@{LIST_VIEW_NAME:@"ITEM01", LIST_VIEW_SUBITEMS:@[dictArray1, dict1]},
                 @{LIST_VIEW_NAME:@"ITEM02",LIST_VIEW_SUBITEMS:@[dictArray2, dict2]},
                 @{LIST_VIEW_NAME:@"ITEM03",LIST_VIEW_SUBITEMS:@[dictArray3, dictArray4]}] mutableCopy];
                 */
                
                controller.listViewItems = [@[@{LIST_VIEW_NAME:@"ITEM01", LIST_VIEW_SUBITEMS:@[dictArray1, dict1]}, @{LIST_VIEW_NAME:@"ITEM02",LIST_VIEW_SUBITEMS:@[dictArray2, dict2, dictArray6]}, @{LIST_VIEW_NAME:@"ITEM03",LIST_VIEW_SUBITEMS:@[dictArray3, dictArray4]}] mutableCopy];
                
                
                [self.navigationController pushViewController:controller animated:YES];
                
                break;
            }
                
            case FilterModelStage: {
                break;
            }
                
            case FilterModelBidding: {
                
                ProjectFilterBiddingViewController *controller = [ProjectFilterBiddingViewController new];
                [self.navigationController pushViewController:controller animated:YES];
                
                break;
            }
                
            case FilterModelBH: {
                //ProjectFilterBHViewController *controller = [ProjectFilterBHViewController new];
                //[self.navigationController pushViewController:controller animated:YES];
                /*
                NSArray *array = @[
                                   @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BOTH"),PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                                   @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BLDG"),PROJECT_SELECTION_VALUE:@(102),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                                   @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_HIGHWAY"),PROJECT_SELECTION_VALUE:@(101),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                                   ];
                */
                
                
                ProjectFilterSelectionViewController *controller = [ProjectFilterSelectionViewController new];
                /*
                controller.projectFilterSelectionViewControllerDelegate = self;
                controller.dataInfo  = array;
                controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_BH_TITLE");
                controller.navRightButtonTitle = NSLocalizedLanguage(@"PROJECT_FILTER_BIDDING_RIGHTBUTTON_TITLE");
                */
                
                [self.navigationController pushViewController:controller animated:YES];
                
                break;
            }
                
            case FilterModelOwner: {
                
                NSMutableArray *obj = [@[@{@"title":@"Federal",@"id":@(1)},
                                         @{@"title":@"Local Government",@"id":@(2)},
                                         @{@"title":@"Military",@"id":@(3)},
                                         @{@"title":@"Private",@"id":@(4)},
                                         @{@"title":@"State",@"id":@(5)}
                                         ] mutableCopy];
                
                WorkOwnerTypesViewController *controller = [WorkOwnerTypesViewController new];
                [controller setInfo:obj];
                [controller setNavTitle:NSLocalizedLanguage(@"OWNER_TYPES_TITLE")];
                controller.workOwnerTypesViewControllerDelegate = self;
                [self.navigationController pushViewController:controller animated:YES];

                break;
            }
                
            case FilterModelWork: {
                [self pushWorkTypes];
                break;
            }
        }
        
    }

}

#pragma mark - Work Types
- (void)pushWorkTypes {
    [[DataManager sharedManager] workTypes:^(id obj){
        
        WorkOwnerTypesViewController *controller = [WorkOwnerTypesViewController new];
        [controller setInfo:obj];
        [controller setNavTitle:NSLocalizedLanguage(@"WORK_TYPES_TITLE")];
        controller.workOwnerTypesViewControllerDelegate =self;
        [self.navigationController pushViewController:controller animated:YES];
        
        
    }failure:^(id failObject){
        
    }];
}

#pragma mark - ProjectFilter Types

- (void)pushProjectFilterTypes {
    
    [[DataManager sharedManager] projectGroupRequest:^(id obj){
        
        [[DataManager sharedManager] projectCategoryList:^(id catObj){
            
            ProjectFilterTypesViewController *controller = [ProjectFilterTypesViewController new];
            [controller setInfoGroupList:obj categoryList:catObj];
            [self.navigationController pushViewController:controller animated:YES];
            
        }failure:^(id catFailObj){
            
        }];
    
    }failure:^(id obj){
        
    }];
    
}

#pragma mark - WorkOwnerTypes Delegate

- (void)workOwnerTypesSelectedItems:(id)item {
    
}

#pragma mark - projectFilterSelectionViewControllerDelegate 

- (void)tappedApplyButton:(id)items {
    
}

@end

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
#import "ValuationViewController.h"
#import "FilterSelectionViewController.h"

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

@interface SearchFilterViewController ()<ProjectFilterViewDelegate, CompanyFilterViewDelegate,WorkOwnerTypesViewControllerDelegate,FilterSelectionViewControllerDelegate,ProjectFilterTypesViewControllerDelegate,ProjectFilterLocationViewControllerDelegate,ValuationViewControllerDelegate>{
    
    FilterModel selectedModel;
}
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
    _labelTitle.tintColor = [UIColor whiteColor];
    
    [_projectFilter setConstraint:_constraintProjectFilterHeight];
    _projectFilter.scrollView = _projectScrollView;
    _projectFilter.projectFilterViewDelegate = self;
    _companyFilter.hidden = YES;
    _companyFilter.companyFilterViewDelegate = self;

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

- (NSMutableArray*) createSubItems {

    ListViewItemArray *subItems = [ListViewItemArray new];
    ListViewItemDictionary *subItem = [ListItemCollectionViewCell createItem:@"EMOD" value:@"" model:@"jurisdiction"];
    [subItems addObject:subItem];
    
    ListViewItemArray *children = [ListViewItemArray new];
    ListViewItemDictionary *child = [ListItemCollectionViewCell createItem:@"53" value:@"" model:@"jurisdiction"];
    [children addObject:child];
    
    subItem[LIST_VIEW_SUBITEMS] = children;

    return subItems;
}

- (void)tappedProjectFilterItem:(id)object view:(UIView *)view {
    
    FilterModel model = 0;
    BOOL shouldProcess = NO;
    
    if ([object class] == [FilterLabelView class]) {
        
        model = [(FilterLabelView*)object filterModel];
        shouldProcess = YES;
        
        
    } else if([object class] == [FilterEntryView class]) {
        
        model = [(FilterEntryView*)object filterModel];
        shouldProcess = YES;
    }
    selectedModel = model;
    
    if (shouldProcess) {
        
        switch (model) {
            case FilterModelLocation: {
                [self filterLocation:view];
                break;
            }
                
            case FilterModelType: {
                [self filterTypes:view];
                break;
            }
                
            case FilterModelValue: {
                [self filterValue:view];
                break;
            }
                
            case FilterModelUpdated: {
                [self filterUpdatedWithin:view];
                break;
            }
                
            case FilterModelJurisdiction: {
                [self filterJurisdiction:view];
                break;
            }
                
            case FilterModelStage: {
                [self filterStage:view];
                break;
            }
                
            case FilterModelBidding: {
                [self filterBiddingWithin:view];
                break;
            }
                
            case FilterModelBH: {
                [self filterBH:view];
                break;
            }
                
            case FilterModelOwner: {
                [self filterOwner:view];
                break;
            }
                
            case FilterModelWork: {
                [self pushWorkTypes:view];
                break;
            }
                
            default: {
                break;
            }
        }
        
    }

}

- (void)tappedCompanyFilterItem:(id)object view:(UIView *)view {
    
    FilterModel model = 0;
    BOOL shouldProcess = NO;
    
    if ([object class] == [FilterLabelView class]) {
        
        model = [(FilterLabelView*)object filterModel];
        shouldProcess = YES;
        
    } else if([object class] == [FilterEntryView class]) {
        
        model = [(FilterEntryView*)object filterModel];
        shouldProcess = YES;
    }
    selectedModel = model;
    if (shouldProcess) {
        
        switch (model) {
            
            case FilterModelLocation: {
                [self filterLocation:view];
                break;
            }
            
            case FilterModelValue: {
                [self filterValue:view];
                break;
            }
                
            case FilterModelJurisdiction: {
                [self filterJurisdiction:view];
                break;
            }
                
            case FilterModelBidding: {
                [self filterBiddingWithin:view];
                break;
            }
                
            case FilterModelProjectType: {
                [self filterProjectTypes:view];
                break;
            }
                
            default: {
                break;
            }
        }
    }
}

- (void)filterJurisdiction:(UIView*)view {
    
    ListViewItemArray *listItems = [ListViewItemArray new];
    
    NSMutableDictionary *item01 = [ListItemCollectionViewCell createItem:@"CECA" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item01];
    item01[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item02 = [ListItemCollectionViewCell createItem:@"EAST" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item02];
    item02[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item03 = [ListItemCollectionViewCell createItem:@"GTLK" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item03];
    item03[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item04 = [ListItemCollectionViewCell createItem:@"MATL" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item04];
    item04[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item05 = [ListItemCollectionViewCell createItem:@"MWST" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item05];
    item05[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item06 = [ListItemCollectionViewCell createItem:@"NENG" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item06];
    item06[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item07 = [ListItemCollectionViewCell createItem:@"NWST" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item07];
    item07[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item08 = [ListItemCollectionViewCell createItem:@"OVSS" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item08];
    item08[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item09 = [ListItemCollectionViewCell createItem:@"PWST" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item09];
    item09[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    NSMutableDictionary *item10 = [ListItemCollectionViewCell createItem:@"WMOK" value:@"" model:@"jurisdiction"];
    
    [listItems addObject:item10];
    
    item10[LIST_VIEW_SUBITEMS] = [self createSubItems];
    
    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_JURISRICTION");
    controller.listViewItems = listItems;
    controller.singleSelect = YES;
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)filterStage:(UIView*)view {
    
    ListViewItemArray *listItems = [ListViewItemArray new];
    
    [[DataManager sharedManager] parentStage:^(id object) {
        
        for (NSDictionary *item in object) {
            
            ListViewItemDictionary *listItem = [ListItemCollectionViewCell createItem:item[@"name"] value:item[@"id"] model:@"parentStage"];
            
            NSArray *stages = [DerivedNSManagedObject objectOrNil:item[@"stages"]];
            
            if (stages != nil) {
                
                ListViewItemArray *subItems = [ListViewItemArray new];
                
                for (NSDictionary *stage in stages) {
                    
                    ListViewItemDictionary *subItem = [ListItemCollectionViewCell createItem:stage[@"name"] value:stage[@"id"] model:@"stage"];
                    [subItems addObject:subItem];
                    
                }
                
                listItem[LIST_VIEW_SUBITEMS] = subItems;
            }
            
            [listItems addObject:listItem];
            
        }
        
        FilterViewController *controller = [FilterViewController new];
        controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_STAGES");
        controller.listViewItems = listItems;
        controller.singleSelect = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } failure:^(id object) {
        
    }];

}

- (void)filterProjectTypes:(UIView*)view {
    
    [[DataManager sharedManager] projectTypes:^(id groups) {
        
        ListViewItemArray *listItems = [ListViewItemArray new];

        for (NSDictionary *group in groups) {
            
            ListViewItemDictionary *groupItem = [ListItemCollectionViewCell createItem:group[@"title"] value:group[@"id"] model:@"projectGroup"];
            
            NSArray *categories = [DerivedNSManagedObject objectOrNil:group[@"projectCategories"]];
            
            if (categories) {
   
                ListViewItemArray *groupItems = [ListViewItemArray new];
                
                for (NSDictionary *category in categories) {
                    
                    ListViewItemDictionary *categoryItem = [ListItemCollectionViewCell createItem:category[@"title"] value:category[@"id"] model:@"projectCategory"];
                    [groupItems addObject:categoryItem];
                    
                    NSArray *projectTypes = [DerivedNSManagedObject objectOrNil:category[@"projectTypes"]];
                    
                    if (projectTypes) {
                        
                        ListViewItemArray *projectTypeItems = [ListViewItemArray new];
                        
                        for (NSDictionary *projectType in projectTypes) {
                            
                            ListViewItemDictionary *projectTypeItem = [ListItemCollectionViewCell createItem:projectType[@"title"] value:projectType[@"id"] model:@"projectType"];
                            
                            [projectTypeItems addObject:projectTypeItem];
                        }
      
                        categoryItem[LIST_VIEW_SUBITEMS] = projectTypeItems;
                        
                    }
                    
                }
                
                groupItem[LIST_VIEW_SUBITEMS] = groupItems;
                
            }
            
            [listItems addObject:groupItem];
            
        }
        
        FilterViewController *controller = [FilterViewController new];
        controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_PROJECTTYPE");
        controller.listViewItems = listItems;
        controller.singleSelect = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } failure:^(id object) {
        
    }];
}

#pragma mark - Work Types

- (void)pushWorkTypes:(UIView*)view {
    [[DataManager sharedManager] workTypes:^(id obj){
        
        WorkOwnerTypesViewController *controller = [WorkOwnerTypesViewController new];
        [controller setInfo:obj];
        [controller setNavTitle:NSLocalizedLanguage(@"WORK_TYPES_TITLE")];
        controller.workOwnerTypesViewControllerDelegate =self;
        [self.navigationController pushViewController:controller animated:YES];
        
    }failure:^(id failObject){
        
    }];
}

- (void)filterLocation:(UIView*)view {

    ProjectFilterLocationViewController *controller = [ProjectFilterLocationViewController new];
    controller.projectFilterLocationViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)filterValue:(UIView*)view {
    
    ValuationViewController *controller =  [ValuationViewController new];
    controller.valuationViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)filterUpdatedWithin:(UIView*)view {
    
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:@"Any",PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:@"Last 24 Hours",PROJECT_SELECTION_VALUE:@(24),PROJECT_SELECTION_TYPE:@(ProjectFilterItemHours)},
                       @{PROJECT_SELECTION_TITLE:@"Last 7 Days",PROJECT_SELECTION_VALUE:@(7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 30 Days",PROJECT_SELECTION_VALUE:@(30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 90 Days",PROJECT_SELECTION_VALUE:@(90),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 6 Months",PROJECT_SELECTION_VALUE:@(6),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       @{PROJECT_SELECTION_TITLE:@"Last 12 Months",PROJECT_SELECTION_VALUE:@(12),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       ];
    
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
    [controller setDataInfo:array];
    controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_UPDATED_TITLE");
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)filterBiddingWithin:(UIView*)view {
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:@"Any",PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:@"Last 24 Hours",PROJECT_SELECTION_VALUE:@(24),PROJECT_SELECTION_TYPE:@(ProjectFilterItemHours)},
                       @{PROJECT_SELECTION_TITLE:@"Last 7 Days",PROJECT_SELECTION_VALUE:@(7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 30 Days",PROJECT_SELECTION_VALUE:@(30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 90 Days",PROJECT_SELECTION_VALUE:@(90),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 6 Months",PROJECT_SELECTION_VALUE:@(6),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       @{PROJECT_SELECTION_TITLE:@"Last 12 Months",PROJECT_SELECTION_VALUE:@(12),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       ];
    
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
    [controller setDataInfo:array];
    controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_BIDDING_TITLE");
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)filterBH:(UIView*)view {
    
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BOTH"),PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BLDG"),PROJECT_SELECTION_VALUE:@(102),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_HIGHWAY"),PROJECT_SELECTION_VALUE:@(101),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       ];
    
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
    [controller setDataInfo:array];
    controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_BH_TITLE");
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)filterOwner:(UIView*)view {
 
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

}

#pragma mark - ProjectFilter Types

- (void)filterTypes:(UIView*)view {
    
    [[DataManager sharedManager] projectGroupRequest:^(id obj){
        ProjectFilterTypesViewController *controller = [ProjectFilterTypesViewController new];
        [controller setDataInfo:obj];
        controller.projectFilterTypesViewControllerDelegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }failure:^(id obj){
        
    }];
}

#pragma mark - FilterTypes Delegate

- (void)tappedTypesApplyButton:(id)items {
    
}

#pragma mark - Location Delegate

- (void)tappedLocationApplyButton:(id)items {
    
}

#pragma mark - WorkOwnerTypes Delegate

- (void)tappedApplyWorkOwnerButton:(id)item {
    
        NSDictionary *emptyDic= @{@"title":NSLocalizedLanguage(@"PROJECT_FILTER_ANY")};
        NSDictionary *value = item != nil?item:emptyDic;
        [_projectFilter setFilterModelInfo:selectedModel value:value];
   
}

#pragma mark - FilterSelectionViewControllerDelegate

- (void)tappedApplyButton:(id)items {
    
    NSDictionary *dict = items;
    if (_companyFilter.hidden) {
        [_projectFilter setFilterModelInfo:selectedModel value:dict];
    } else {
        [_companyFilter setFilterModelInfo:selectedModel value:dict];
    }
}

#pragma mark - Valuation Delegate

- (void)tappedValuationApplyButton:(id)items {
    
}


@end

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
#import "ProjectFilterSelectionViewList.h"

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

@interface SearchFilterViewController ()<ProjectFilterViewDelegate, CompanyFilterViewDelegate,WorkOwnerTypesViewControllerDelegate,FilterSelectionViewControllerDelegate,ProjectFilterTypesViewControllerDelegate,ProjectFilterLocationViewControllerDelegate,ValuationViewControllerDelegate, FilterViewControllerDelegate>{
    
    FilterModel selectedModel;
    NSMutableArray *selectedLocationItems;
    id  objectEntry;
    ListViewItemArray *listItemsJurisdictions;
    ListViewItemArray *listItemsProjectStageId;
    ListViewItemArray *listItemsProjectTypeId;
    NSDictionary *dataSelected;
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

    NSMutableDictionary *companyDictFilter = _companyFilter.searchFilter;
    NSMutableDictionary *projectDictFilter = _projectFilter.searchFilter;

    if (_companyFilter.hidden) {
        
        NSMutableDictionary *projectLocDict = projectDictFilter[@"projectLocation"];
        
        if (projectLocDict != nil) {

            if (companyDictFilter == nil) {
                companyDictFilter = [NSMutableDictionary new];
                _companyFilter.searchFilter = companyDictFilter;
            }

            NSString *city = projectLocDict[@"city"];
            if (city != nil) {
                companyDictFilter[@"city"] = city;
            }
            
            NSString *state = projectLocDict[@"state"];
            if (state != nil) {
                companyDictFilter[@"state"] = state;
            }
            
            NSString *zip = projectLocDict[@"zip"];
            if (zip != nil) {
                companyDictFilter[@"zip"] = zip;
            }
            
            NSString *county = projectLocDict[@"county"];
            if (county != nil) {
                companyDictFilter[@"county"] = county;
            }
            
        }
    } else {
        
        if (projectDictFilter == nil) {
            projectDictFilter = [NSMutableDictionary new];
            _projectFilter.searchFilter = projectDictFilter;
        }

        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        NSString *city = companyDictFilter[@"city"];
        if (city != nil) {
            dict[@"city"] = city;
        }
        
        NSString *state = companyDictFilter[@"state"];
        if (state != nil) {
            dict[@"state"] = state;
        }
        
        NSString *zip = companyDictFilter[@"zip"];
        if (zip != nil) {
            dict[@"zip5"] = zip;
        }
        
        NSString *county = companyDictFilter[@"county"];
        if (county != nil) {
            dict[@"county"] = county;
        }

        if (dict.count>0) {
            projectDictFilter[@"projectLocation"] = dict;
        }
    }
    
    [self.searchFilterViewControllerDelegate tappedSearchFilterViewControllerApply:_projectFilter.searchFilter companyFilter:_companyFilter.searchFilter];
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    objectEntry = object;
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
                
                FilterEntryView *entryView = object;
                
                if (entryView.entryType == FilterEntryViewTypeOpenEntry) {
                    
                    if (entryView.openEntryFields == nil) {
                        entryView.openEntryFields = [NSMutableArray new];
                       
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"city",@"VALUE":@"",@"placeHolder":@"PROJECT_FILTER_HINT_LOCATION_CITY"} mutableCopy ]];
         
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"state",@"VALUE":@"",@"placeHolder":@"PROJECT_FILTER_HINT_LOCATION_STATE"} mutableCopy ]];
             
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"county",@"VALUE":@"",@"placeHolder":@"PROJECT_FILTER_HINT_LOCATION_COUNTY"} mutableCopy ]];
                 
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"zip5",@"VALUE":@"",@"placeHolder":@"PROJECT_FILTER_HINT_LOCATION_ZIP"} mutableCopy ]];
                        
                    }
                    [entryView promptOpenEntryUsingViewController:self block:^(id object) {
                        [_projectFilter setFilterModelInfo:model value:object];
                    } title:NSLocalizedLanguage(@"PROJECT_FILTER_HINT_LOCATION")];
                } else {
                    [self filterLocation:view];
                }
                break;
            }
                
            case FilterModelProjectType: {
                //[self filterTypes:view];
                [self filterProjectTypes:view];
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
    objectEntry = object;
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
                
                FilterEntryView *entryView = object;
                
                if (entryView.entryType == FilterEntryViewTypeOpenEntry) {
                    
                    if (entryView.openEntryFields == nil) {
                        entryView.openEntryFields = [NSMutableArray new];
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"city",@"VALUE":@"",@"placeHolder":@"COMPANY_FILTER_HINT_LOCATION_CITY"} mutableCopy ]];
                        
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"state",@"VALUE":@"",@"placeHolder":@"COMPANY_FILTER_HINT_LOCATION_STATE"} mutableCopy ]];
         
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"county",@"VALUE":@"",@"placeHolder":@"COMPANY_FILTER_HINT_LOCATION_COUNTY"} mutableCopy ]];
                        
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"zip",@"VALUE":@"",@"placeHolder":@"COMPANY_FILTER_HINT_LOCATION_ZIP"} mutableCopy ]];
                        
                    }
                    [entryView promptOpenEntryUsingViewController:self block:^(id object) {
                        [_companyFilter setFilterModelInfo:model value:object];
                    } title:NSLocalizedLanguage(@"COMPANY_FILTER_HINT_LOCATION")];
                } else {
                    [self filterLocation:view];
                }

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
    
    if (listItemsJurisdictions == nil) {

        ListViewItemArray *listItems = [ListViewItemArray new];
        
        [[DataManager sharedManager] jurisdiction:^(id object) {
            
            NSArray *items = object;
            
            for (NSDictionary *item in items) {
                
                NSMutableDictionary *jurisdiction = [ListItemCollectionViewCell createItem:item[@"name"] value:item[@"id"] model:@"jurisdiction"];
                
                [listItems addObject:jurisdiction];
                
                NSArray *locals = [DerivedNSManagedObject objectOrNil:item[@"localsWithNoDistrict"]];
                
                if (locals != nil) {
                    
                    if (locals.count>0) {
                        
                        ListViewItemArray *localItems = [ListViewItemArray new];
                        
                        for (NSDictionary *local in locals) {
                            
                            NSMutableDictionary *localItem = [ListItemCollectionViewCell createItem:local[@"name"] value:local[@"id"] model:@"local"];
                            
                            [localItems addObject:localItem];
                        }
                        
                        jurisdiction[LIST_VIEW_SUBITEMS] = localItems;
                        
                    }
                    
                }
                
                NSArray *districtCouncils = [DerivedNSManagedObject objectOrNil:item[@"districtCouncils"]];
                
                if (districtCouncils != nil) {
                    
                    ListViewItemArray *localItems = jurisdiction[LIST_VIEW_SUBITEMS];
                    
                    if (localItems == nil) {
                        localItems = [ListViewItemArray new];
                        jurisdiction[LIST_VIEW_SUBITEMS] = localItems;
                        
                    }
                    for (NSDictionary *districtItem in districtCouncils) {
                        
                        NSMutableDictionary *localItem = [ListItemCollectionViewCell createItem:districtItem[@"name"] value:districtItem[@"id"] model:@"district"];
                        
                        [localItems addObject:localItem];
                        
                        
                        NSArray *locals = [DerivedNSManagedObject objectOrNil:districtItem[@"locals"]];
                        
                        ListViewItemArray *localDistrict = [ListViewItemArray new];
                        
                        for (NSDictionary *local in locals) {
                            
                            NSMutableDictionary *item = [ListItemCollectionViewCell createItem:local[@"name"] value:local[@"id"] model:@"localDisctrict"];
                            
                            [localDistrict addObject:item];
                            
                        }
                        
                        localItem[LIST_VIEW_SUBITEMS] = localDistrict;
                        
                        
                    }
                    
                }
                
                
            }
            
            listItemsJurisdictions = listItems;
            [self displayJurisdiction];
        } failure:^(id object) {
            
        }];

    } else {
        [self displayJurisdiction];
    }

}

- (void)displayJurisdiction {
    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_JURISRICTION");
    controller.listViewItems = listItemsJurisdictions;
    controller.singleSelect = YES;
    controller.fieldValue = @"jurisdictions";
    controller.filterViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)filterStage:(UIView*)view {
    
    if (listItemsProjectStageId == nil) {
        
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
            
            listItemsProjectStageId = listItems;
            [self displayProjectStateId];
            
        } failure:^(id object) {
            
        }];
    } else {
        
        [self displayProjectStateId];
    
    }

}

- (void) displayProjectStateId {

    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_STAGES");
    controller.listViewItems = listItemsProjectStageId;
    controller.filterViewControllerDelegate = self;
    controller.fieldValue = @"projectStageId";
    controller.singleSelect = YES;
    [self.navigationController pushViewController:controller animated:YES];

}
- (void)filterProjectTypes:(UIView*)view {
    
    if (listItemsProjectTypeId == nil) {
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
            
            listItemsProjectTypeId = listItems;
            
            [self displayProjectTypeId];
            
        } failure:^(id object) {
            
        }];
    } else {
        [self displayProjectTypeId];
    }

}

- (void)displayProjectTypeId {

    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_PROJECTTYPE");
    controller.listViewItems = listItemsProjectTypeId;
    controller.filterViewControllerDelegate = self;
    controller.fieldValue = @"projectTypeId";
    controller.singleSelect = _companyFilter.hidden?NO:YES;
    [self.navigationController pushViewController:controller animated:YES];

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
    controller.dataSelected = [(FilterEntryView *)objectEntry getCollectionItemsData];
    controller.projectFilterLocationViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)filterValue:(UIView*)view {
    
    ValuationViewController *controller =  [ValuationViewController new];
    
    NSString *ownerName = _companyFilter.hidden?@"Project":@"Company";
    NSDictionary *dict  = [DerivedNSManagedObject objectOrNil:dataSelected[ownerName][@"valuation"]];
    
    controller.valuationValue = dict;
    controller.valuationViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)filterUpdatedWithin:(UIView*)view {
    
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:@"Any",PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:@"Last 24 Hours",PROJECT_SELECTION_VALUE:@(1),PROJECT_SELECTION_TYPE:@(ProjectFilterItemHours)},
                       @{PROJECT_SELECTION_TITLE:@"Last 7 Days",PROJECT_SELECTION_VALUE:@(7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 30 Days",PROJECT_SELECTION_VALUE:@(30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 90 Days",PROJECT_SELECTION_VALUE:@(90),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 6 Months",PROJECT_SELECTION_VALUE:@(6*30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       @{PROJECT_SELECTION_TITLE:@"Last 12 Months",PROJECT_SELECTION_VALUE:@(12*30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       ];
    
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
    
    NSString *ownerName = _companyFilter.hidden?@"Project":@"Company";
    NSDictionary *dict  = [DerivedNSManagedObject objectOrNil:dataSelected[ownerName][@"updatedWithin"]];
    [controller setDataBeenSelected:dict];
    [controller setDataInfo:array];
    controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_UPDATED_TITLE");
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)filterBiddingWithin:(UIView*)view {
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:@"Any",PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 7 Days",PROJECT_SELECTION_VALUE:@(-7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
     
                       @{PROJECT_SELECTION_TITLE:@"Next 14 Days",PROJECT_SELECTION_VALUE:@(-14),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                    
                       @{PROJECT_SELECTION_TITLE:@"Next 21 Days",PROJECT_SELECTION_VALUE:@(-21),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 30 Days",PROJECT_SELECTION_VALUE:@(-30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       //@{PROJECT_SELECTION_TITLE:@"Last 24 Hours",PROJECT_SELECTION_VALUE:@(1),PROJECT_SELECTION_TYPE:@(ProjectFilterItemHours)},
                       
                       
                       @{PROJECT_SELECTION_TITLE:@"Last 7 Days",PROJECT_SELECTION_VALUE:@(7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 14 Days",PROJECT_SELECTION_VALUE:@(14),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 21 Days",PROJECT_SELECTION_VALUE:@(21),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 30 Days",PROJECT_SELECTION_VALUE:@(30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)}//,
                       //@{PROJECT_SELECTION_TITLE:@"Last 12 Months",PROJECT_SELECTION_VALUE:@(12*30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       ];
    
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
    
    NSString *ownerName = _companyFilter.hidden?@"Project":@"Company";
    NSDictionary *dict  = [DerivedNSManagedObject objectOrNil:dataSelected[ownerName][@"biddingWithin"]];
    [controller setDataBeenSelected:dict];
    
    [controller setDataInfo:array];
    controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_BIDDING_TITLE");
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)filterBH:(UIView*)view {
    
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BOTH"),PROJECT_SELECTION_VALUE:@[@"B", @"H"],PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_BLDG"),PROJECT_SELECTION_VALUE:@[@"B"],PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:NSLocalizedLanguage(@"BH_TITLE_HIGHWAY"),PROJECT_SELECTION_VALUE:@[@"H"],PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
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
   selectedLocationItems = [NSMutableArray new];
    [self getLocationData:items];

    if (_companyFilter.hidden) {
        [_projectFilter setFilterModelInfo:selectedModel value:selectedLocationItems];
    } else {
        [_companyFilter setFilterModelInfo:selectedModel value:selectedLocationItems];
    }

    
}

- (void)getLocationData:(id)items {

    for (NSDictionary *item in items) {
        
        if ([item[SELECTIONFLAGNAME] isEqualToString:SelectedFlag]) {
            [selectedLocationItems addObject:@{ENTRYTITLE:item[@"title"],ENTRYID:item[ENTRYID]}];
        }
        
        NSArray *subArray = [DerivedNSManagedObject objectOrNil:item[@"SubData"]];
        if (subArray.count > 0) {
            [self getLocationData:subArray];
        }
    }

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
    
    if (dict) {
        
        NSString *fieldName = [self dataSelectFieldName:selectedModel];
        
        if (_companyFilter.hidden) {
            
            dataSelected = @{@"Project":@{fieldName:items}};
            [_projectFilter setFilterModelInfo:selectedModel value:dict];
        } else {
            dataSelected = @{@"Company":@{fieldName:items}};
            [_companyFilter setFilterModelInfo:selectedModel value:dict];
        }
        
    }
    
}

#pragma mark - Valuation Delegate

- (void)tappedValuationApplyButton:(id)items {
    
    if (_companyFilter.hidden) {
        dataSelected = @{@"Project":@{@"valuation":items}};
        [_projectFilter setFilterModelInfo:selectedModel value:items];
        
    } else {
        dataSelected = @{@"Company":@{@"valuation":items}};
        _companyFilter.searchFilter[@"valuation"] = items;
        [_companyFilter setFilterModelInfo:selectedModel value:items];
        
    }
    
}

- (void)tappedFilterViewControllerApply:(NSMutableArray *)selectedItems key:(NSString *)key titles:(NSMutableArray *)titles{
    
    if (_companyFilter.hidden) {
        
        _projectFilter.searchFilter[key] = @{@"inq":selectedItems};
        [_projectFilter setFilterModelInfo:selectedModel value:titles];
        
    } else {
        _companyFilter.searchFilter[key] = @{@"inq":selectedItems};
        [_companyFilter setFilterModelInfo:selectedModel value:titles];
        
    }
}

- (NSString *)dataSelectFieldName:(FilterModel)filterModel{
    NSString *title;
    
    switch (filterModel) {
        
        case FilterModelUpdated:{
            
            title = @"updatedWithin";
            break;
        }
        
        case FilterModelBidding:{
            
            title = @"biddingWithin";
            break;
        }
        case FilterModelBH:{
            
            title = @"B/H";
            break;
        }
        case FilterModelOwner:{
            
           title = @"ownerType";
            break;
        }
        case FilterModelWork:{
            
            title = @"workType";
            break;
        }
        default:{
            break;
        }
            
            
    }
    
    return title;
}

@end

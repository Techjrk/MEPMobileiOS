//
//  ProjectNearMeFilterViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 1/18/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearMeFilterViewController.h"
#import "ProjectFilterView.h"
#import "FilterLabelView.h"
#import "FilterEntryView.h"
#import "ListItemCollectionViewCell.h"
#import "ProjectFilterLocationViewController.h"
#import "ValuationViewController.h"
#import "FilterViewController.h"
#import "FilterSelectionViewController.h"
#import "ProjectFilterSelectionViewList.h"
#import "WorkOwnerTypesViewController.h"

// Flags
#define SELECTIONFLAGNAME               @"selectionFlag"
#define SelectedFlag                    @"1"

// Fonts
#define BUTTON_FONT                     fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define TITLE_FONT                      fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)

// Colors
#define BUTTON_COLOR                    RGB(168, 195, 230)
#define TITLE_COLOR                     RGB(255, 255, 255)

@interface ProjectNearMeFilterViewController ()<ProjectFilterViewDelegate, ProjectFilterLocationViewControllerDelegate, FilterViewControllerDelegate, ValuationViewControllerDelegate, FilterSelectionViewControllerDelegate, WorkOwnerTypesViewControllerDelegate>{
    // Variables
    id  objectEntry;
    FilterModel selectedModel;
    ListViewItemArray *listItemsProjectTypeId;
    ListViewItemArray *listItemsJurisdictions;
    ListViewItemArray *listItemsProjectStageId;
    NSDictionary *dataSelected;
    NSMutableArray *selectedLocationItems;
    
}

// IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonApply;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet ProjectFilterView *projectFilter;

// IBActions
- (IBAction)tappedButtonCancel:(id)sender;
- (IBAction)tappedButtonApply:(id)sender;

@end

@implementation ProjectNearMeFilterViewController

#pragma mark - UIViewControllers Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.buttonCancel  setTitle:NSLocalizedLanguage(@"PNV_CANCEL") forState:UIControlStateNormal];
    self.buttonCancel.titleLabel.font = BUTTON_FONT;
    [self.buttonCancel setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    
    [self.buttonApply setTitle:NSLocalizedLanguage(@"PNV_APPLY") forState:UIControlStateNormal];
    self.buttonApply.titleLabel.font = BUTTON_FONT;
    [self.buttonApply setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    
    self.labelTitle.text = NSLocalizedLanguage(@"PNV_TITLE");
    self.labelTitle.textColor = TITLE_COLOR;
    
    [self.projectFilter hideLocation:true];
    self.projectFilter.projectFilterViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

#pragma mark - IBActions

- (IBAction)tappedButtonCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)tappedButtonApply:(id)sender {
    NSMutableDictionary *projectDictFilter = self.projectFilter.searchFilter;
    if (self.projectNearMeFilterViewControllerDelegate != nil) {
        [self.projectNearMeFilterViewControllerDelegate applySearchFilter:projectDictFilter];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -ProjectFilterViewDelegate

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

#pragma mark - Filters
- (void)filterLocation:(UIView*)view {
    ProjectFilterLocationViewController *controller = [ProjectFilterLocationViewController new];
    controller.dataSelected = [(FilterEntryView *)objectEntry getCollectionItemsData];
    controller.projectFilterLocationViewControllerDelegate = self;
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
    controller.singleSelect = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)filterValue:(UIView*)view {
    ValuationViewController *controller =  [ValuationViewController new];
    
    NSString *ownerName = @"Project";
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
    
    NSString *ownerName = @"Project";
    NSDictionary *dict  = [DerivedNSManagedObject objectOrNil:dataSelected[ownerName][@"updatedInLast"]];
    [controller setDataBeenSelected:dict];
    [controller setDataInfo:array];
    controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_UPDATED_TITLE");
    [self.navigationController pushViewController:controller animated:YES];
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

- (void)filterBiddingWithin:(UIView*)view {
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:@"Any",PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 7 Days",PROJECT_SELECTION_VALUE:@(7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 14 Days",PROJECT_SELECTION_VALUE:@(14),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 21 Days",PROJECT_SELECTION_VALUE:@(21),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 30 Days",PROJECT_SELECTION_VALUE:@(30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 7 Days",PROJECT_SELECTION_VALUE:@(-7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 14 Days",PROJECT_SELECTION_VALUE:@(-14),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 21 Days",PROJECT_SELECTION_VALUE:@(-21),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 30 Days",PROJECT_SELECTION_VALUE:@(-30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)}//,
                       ];
    
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
    
    NSString *ownerName = @"Project";
    NSDictionary *dict  = [DerivedNSManagedObject objectOrNil:dataSelected[ownerName][@"biddingInNext"]];
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

#pragma mark - Delegates
- (void)tappedLocationApplyButton:(id)items {
    selectedLocationItems = [NSMutableArray new];
    [self getLocationData:items];
    [self.projectFilter setFilterModelInfo:selectedModel value:selectedLocationItems];
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

- (void)tappedFilterViewControllerApply:(NSMutableArray *)selectedItems key:(NSString *)key titles:(NSMutableArray *)titles {
    self.projectFilter.searchFilter[key] = @{@"inq":selectedItems};
    [self.projectFilter setFilterModelInfo:selectedModel value:titles];
}

- (void)tappedValuationApplyButton:(id)items {
    dataSelected = @{@"Project":@{@"valuation":items}};
    [self.projectFilter setFilterModelInfo:selectedModel value:items];
}

- (void)tappedApplyButton:(id)items {
    NSDictionary *dict = items;
    if (dict) {
        NSString *fieldName = [self dataSelectFieldName:selectedModel];
        
        dataSelected = @{@"Project":@{fieldName:items}};
        [self.projectFilter setFilterModelInfo:selectedModel value:dict];
    }
}

- (NSString *)dataSelectFieldName:(FilterModel)filterModel{
    NSString *title;
    
    switch (filterModel) {
            
        case FilterModelUpdated:{
            
            title = @"updatedInLast";
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

- (void)tappedApplyWorkOwnerButton:(id)item {
    NSDictionary *emptyDic= @{@"title":NSLocalizedLanguage(@"PROJECT_FILTER_ANY")};
    NSDictionary *value = item != nil?item:emptyDic;
    [_projectFilter setFilterModelInfo:selectedModel value:value];
}

@end

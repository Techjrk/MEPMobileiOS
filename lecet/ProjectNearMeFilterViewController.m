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

@interface ProjectNearMeFilterViewController ()<ProjectFilterViewDelegate,  FilterViewControllerDelegate, ValuationViewControllerDelegate, FilterSelectionViewControllerDelegate, WorkOwnerTypesViewControllerDelegate>{
    // Variables
    id  objectEntry;
    FilterModel selectedModel;
    NSDictionary *dataSelected;
    NSMutableArray *selectedLocationItems;
    NSNumber *jurisdictionId;
    NSNumber *stageId;
    
    NSString *jurisdictionNode;
    NSString *stageNode;
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
    
    jurisdictionNode = @"node";
    stageNode = @"node";
    
    if (self.projectFilterDictionary == nil) {
        self.projectFilterDictionary = [NSMutableDictionary new];
    }
    
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
    [self processDefaultValues];
}

- (void)processDefaultValues {
    
    NSDictionary *searchFilter = self.projectFilterDictionary[@"filter"][@"searchFilter"];
    
    NSNumber *updatedInLast = [DerivedNSManagedObject objectOrNil:searchFilter[@"updatedInLast"]];
    if (updatedInLast) {
        
        self.projectFilter.dictUpdatedWithin = @{@"updatedInLast":updatedInLast};
        
        NSDictionary *dict = [self filterUpdatedWithinDictionary:[self filterUpdatedWithinArray] value:updatedInLast];
        [self.projectFilter.fieldUpdated setValue:dict[PROJECT_SELECTION_TITLE]];
    }
    
    NSNumber *biddingInNext = [DerivedNSManagedObject objectOrNil:searchFilter[@"biddingInNext"]];
    
    if (biddingInNext) {
        
        self.projectFilter.dictBiddingWithin = @{@"biddingInNext":biddingInNext};
        
        NSDictionary *dict = [self filterBiddingWithinDictionary:[self filterBiddingWithinArray] value:biddingInNext];
        
        [self.projectFilter.fieldBidding setValue:dict[PROJECT_SELECTION_TITLE]];
        
    }
    
    NSDictionary *jurisdictions = [DerivedNSManagedObject objectOrNil:searchFilter[@"jurisdictions"]];
    if (jurisdictions) {
        
        self.projectFilter.dictJurisdiction = @{@"jurisdictions":jurisdictions};
        
        NSArray *inq = jurisdictions[@"inq"];
        if (inq) {
            
            if (self.listItemsJurisdictions.count>0) {
                NSArray *title = [FilterViewController getCheckedTitles:self.listItemsJurisdictions list:nil];
                NSString *str = [title componentsJoinedByString:@", "];
                
                [self.projectFilter.fieldJurisdiction setValue:str];
            }
            
        }
    }
    
    NSDictionary *projectStage = [DerivedNSManagedObject objectOrNil:searchFilter[@"projectStageId"]];
    if (projectStage) {
        
        self.projectFilter.dictProjectStage = @{@"projectStageId":projectStage};
        
        NSArray *inq = projectStage[@"inq"];
        if (inq) {
            
            if (self.listItemsProjectStageId.count>0) {
                NSArray *title = [FilterViewController getCheckedTitles:self.listItemsProjectStageId list:nil];
                NSString *str = [title componentsJoinedByString:@", "];
                
                [self.projectFilter.fieldStage setValue:str];
                
            }
            
        }
    }
    
    NSDictionary *buildingOrHighway = searchFilter[@"buildingOrHighway"];
    
    if (buildingOrHighway) {
        
        self.projectFilter.dictBH = @{@"buildingOrHighway":buildingOrHighway};
        
        NSArray *buildingOrHighwayArray = buildingOrHighway[@"inq"];
        
        NSString *bh = @"";
        
        if (buildingOrHighwayArray.count == 1) {
            
            if ([buildingOrHighwayArray containsObject:@"B"]) {
                bh = NSLocalizedLanguage(@"BH_TITLE_BLDG");
            } else {
                bh = NSLocalizedLanguage(@"BH_TITLE_HIGHWAY");
            }
            
        } else {
            bh = NSLocalizedLanguage(@"BH_TITLE_BOTH");
        }
        
        [self.projectFilter.fieldBH setValue:bh];
        
    }
    
    NSDictionary *ownerType = searchFilter[@"ownerType"];
    if (ownerType) {
        self.projectFilter.dictOwnerType = @{@"ownerType":ownerType};
        NSArray *workOwner = ownerType[@"inq"];
        [self.projectFilter.fieldOwner setValue:workOwner[0]];
    }
    
    NSDictionary *workType = searchFilter[@"workTypeId"];
    if (workType) {
        
        self.projectFilter.dictWorkType = @{@"workTypeId":workType};
        NSArray *items = workType[@"inq"];
        NSNumber *record = items[0];
        
        [[DataManager sharedManager] workTypes:^(id obj){
            
            NSArray *array = obj;
            
            for (NSDictionary *item in array) {
                NSNumber *recordId = item[@"id"];
                
                if (record.integerValue == recordId.integerValue) {
                    [self.projectFilter.fieldWork setValue:item[@"title"]];
                }
            }
            
        }failure:^(id failObject){
            
        }];
        
    }
    
    NSDictionary *projectValue = searchFilter[@"projectValue"];
    if (projectValue) {
        
        self.projectFilter.dictProjectValue = @{@"projectValue":projectValue};
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *value = @"";
        NSNumber *min = projectValue[@"min"];
        NSNumber *max = projectValue[@"max"];
        
        if (max) {
            value = [NSString stringWithFormat:@"$ %@ - $ %@", [formatter stringFromNumber:min], [formatter stringFromNumber:max]];
        } else {
            value = [NSString stringWithFormat:@"$ %@ - MAX", [formatter stringFromNumber:min]];
        }
        
        [self.projectFilter.fieldValue setInfo:@[@{@"entryID": @(0), @"entryTitle": value}]];
    }
    
    NSDictionary *items = searchFilter[@"projectTypeId"];
    if (items) {
        
        self.projectFilter.dictProjectType = @{@"projectTypeId":items};
        
        [self displayProjectTypeTitles];
        
    }
    
    NSDictionary *projectLocation = searchFilter[@"projectLocation"];
    if (projectLocation) {
        
        self.projectFilter.dictLocation = @{@"projectLocation":projectLocation};
        
        NSMutableArray *array = [NSMutableArray new];
        
        NSString *city = projectLocation[@"city"];
        NSString *state = projectLocation[@"state"];
        NSString *county = projectLocation[@"county"];
        NSString *zip5 = projectLocation[@"zip5"];
        
        if (city) {
            [array addObject:city];
        }
        
        if (state) {
            [array addObject:state];
        }
        
        if (county) {
            [array addObject:county];
        }
        
        if (zip5) {
            [array addObject:zip5];
        }
        
        NSMutableArray *items = [NSMutableArray new];
        NSString *value = @"";
        NSString *current = @"";
        for (int i=0; i<array.count; i++) {
            current = array[i];
            
            if (current.length>0) {
                
                if (value.length>0) {
                    value = [value stringByAppendingString:@", "];
                }
                value = [value stringByAppendingString:current];
            }
        }
        
        if (value.length>0) {
            [items addObject:@{ENTRYID:@(0), ENTRYTITLE:value}];
        }
        
        [self prepareLocation:self.projectFilter.fieldLocation address:projectLocation];
        [self.projectFilter.fieldLocation setInfo:items];
    }
}

- (void)prepareLocation:(FilterEntryView*)entryView  address:(NSDictionary*)address{
    entryView.openEntryFields = [NSMutableArray new];
    
    NSString *city = address[@"city"];
    NSString *state = address[@"state"];
    NSString *county = address[@"county"];
    NSString *zip5 = address[@"zip5"];
    
    if (city == nil) {
        city = @"";
    }
    
    if (state == nil) {
        state = @"";
    }
    
    if (zip5 == nil) {
        zip5 = @"";
    }
    
    if (county == nil) {
        county = @"";
    }
    [entryView.openEntryFields addObject:[@{@"FIELD":@"city",@"VALUE":city,@"placeHolder":@"PROJECT_FILTER_HINT_LOCATION_CITY"} mutableCopy ]];
    
    [entryView.openEntryFields addObject:[@{@"FIELD":@"state",@"VALUE":state,@"placeHolder":@"PROJECT_FILTER_HINT_LOCATION_STATE"} mutableCopy ]];
    
    [entryView.openEntryFields addObject:[@{@"FIELD":@"county",@"VALUE":county,@"placeHolder":@"PROJECT_FILTER_HINT_LOCATION_COUNTY"} mutableCopy ]];
    
    [entryView.openEntryFields addObject:[@{@"FIELD":@"zip5",@"VALUE":zip5,@"placeHolder":@"PROJECT_FILTER_HINT_LOCATION_ZIP"} mutableCopy ]];
    
}

- (void)displayProjectTypeTitles {
    if (self.listItemsProjectTypeId.count>0) {
        NSArray *array = [FilterViewController getCheckedTitles:self.listItemsProjectTypeId list:nil];
        
        NSMutableArray *itemArray = [NSMutableArray new];
        
        for (NSString *item in array) {
            NSDictionary *dict = @{ENTRYTITLE:item};
            [itemArray addObject:dict];
        }
        
        [self.projectFilter.fieldType setInfo:itemArray];
    }
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
 
    if (self.projectNearMeFilterViewControllerDelegate != nil) {
        [self.projectNearMeFilterViewControllerDelegate applySearchFilter:[self.projectFilter filter]];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -ProjectFilterViewDelegate
- (void)tappedProjectTypeChanged:(NSMutableArray *)items {
 
    NSMutableArray *titles = items;
    
    [FilterViewController uncheckedTitles:self.listItemsProjectTypeId list:titles];
    
    NSMutableArray *list = [NSMutableArray new];
    [FilterViewController getCheckItems:self.listItemsProjectTypeId includeChild:YES list:list];
    
    if (list.count>0) {
        self.projectFilter.dictProjectType = @{@"projectTypeId":@{@"inq":list}};
    } else {
        self.projectFilter.dictProjectType = nil;
    }
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
                        [_projectFilter setLocationValue:object];
                    } title:NSLocalizedLanguage(@"PROJECT_FILTER_HINT_LOCATION")];
                } else {
                    //[self filterLocation:view];
                }
                break;
            }
                
            case FilterModelProjectType: {
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

/*
- (void)filterLocation:(UIView*)view {
    ProjectFilterLocationViewController *controller = [ProjectFilterLocationViewController new];
    controller.dataSelected = [(FilterEntryView *)objectEntry getCollectionItemsData];
    controller.projectFilterLocationViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
*/
- (void)filterProjectTypes:(UIView*)view {
    
    if ((self.listItemsProjectTypeId == nil) || (self.listItemsProjectTypeId.count == 0)) {
        [[DataManager sharedManager] projectTypes:^(id groups) {
            
            ListViewItemArray *listItems = nil;
            if (self.listItemsProjectStageId) {
                listItems = self.listItemsProjectTypeId;
            } else {
                listItems = [ListViewItemArray new];
            }
            
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
            
            self.listItemsProjectTypeId = listItems;
            
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
    controller.listViewItems = self.listItemsProjectTypeId;
    controller.filterViewControllerDelegate = self;
    controller.fieldValue = @"projectTypeId";
    controller.singleSelect = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)filterValue:(UIView*)view {
    
    ValuationViewController *controller =  [ValuationViewController new];
    
    NSDictionary *dict = _projectFilter.dictProjectValue[@"projectValue"];
    
    controller.valuationValue = dict;
    controller.valuationViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (NSArray*)filterUpdatedWithinArray {
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:@"Any",PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       @{PROJECT_SELECTION_TITLE:@"Last 24 Hours",PROJECT_SELECTION_VALUE:@(1),PROJECT_SELECTION_TYPE:@(ProjectFilterItemHours)},
                       @{PROJECT_SELECTION_TITLE:@"Last 7 Days",PROJECT_SELECTION_VALUE:@(7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 30 Days",PROJECT_SELECTION_VALUE:@(30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 90 Days",PROJECT_SELECTION_VALUE:@(90),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       @{PROJECT_SELECTION_TITLE:@"Last 6 Months",PROJECT_SELECTION_VALUE:@(6*30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       @{PROJECT_SELECTION_TITLE:@"Last 12 Months",PROJECT_SELECTION_VALUE:@(12*30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)},
                       ];
    return array;
}

- (NSDictionary*)filterUpdatedWithinDictionary:(NSArray*)array value:(NSNumber*)value{
    
    NSDictionary *dict = nil;
    NSNumber *selected = value;
    if (selected) {
        for (NSDictionary *item in array) {
            NSNumber *value = item[PROJECT_SELECTION_VALUE];
            
            if (value.integerValue == selected.integerValue) {
                dict = [item mutableCopy];
            }
        }
    }
    
    return dict;
}

- (void)filterUpdatedWithin:(UIView*)view {
    
    NSNumber *updatedInLast = self.projectFilter.dictUpdatedWithin[@"updatedInLast"];
    
    NSDictionary *dict = [self filterUpdatedWithinDictionary:[self filterUpdatedWithinArray] value:updatedInLast];
    
    NSArray *array = [self filterUpdatedWithinArray];
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
    [controller setDataBeenSelected:dict];
    [controller setDataInfo:array];
    controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_UPDATED_TITLE");
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (NSDictionary*)checkStatus:(NSMutableDictionary*)dictionary itemId:(NSNumber*)itemId currentId:(NSNumber*)currentId nodeItem:(NSString*)nodeItem{

    if (currentId) {
        if ([nodeItem isEqualToString:dictionary[@"LIST_VIEW_MODEL"]]) {
            if (currentId.integerValue == itemId.integerValue) {
                dictionary[STATUS_CHECK] = @(1);
                return dictionary;
            }
        }
    }
    return nil;
}

- (void)filterJurisdiction:(UIView*)view {
    if ((self.listItemsJurisdictions == nil) || (self.listItemsJurisdictions.count == 0)) {
        
        ListViewItemArray *listItems = nil;
        if (self.listItemsJurisdictions) {
            listItems = self.listItemsJurisdictions;
        } else {
            listItems = [ListViewItemArray new];
        }
        
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
            
            self.listItemsJurisdictions = listItems;
            
            if (view) {
                [self displayJurisdiction];
            }
            
        } failure:^(id object) {
            
        }];
        
    } else {
        if (view) {
            [self displayJurisdiction];
        }
    }
}

- (void)displayJurisdiction {
    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_JURISRICTION");
    controller.listViewItems = self.listItemsJurisdictions;
    controller.singleSelect = YES;
    controller.fieldValue = @"jurisdictions";
    controller.filterViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)filterStage:(UIView*)view {
    if ( (self.listItemsProjectStageId == nil) || (self.listItemsProjectStageId.count == 0)) {
        
        ListViewItemArray *listItems = nil;
        if (self.listItemsProjectStageId) {
            listItems = self.listItemsProjectStageId;
        }else {
            listItems = [ListViewItemArray new];
        }
        
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
            
            self.listItemsProjectStageId = listItems;
            
            if (view) {
                [self displayProjectStateId];
            }
            
        } failure:^(id object) {
            
        }];
    } else {
        
        if (view) {
            [self displayProjectStateId];
        }
        
    }
}

- (NSArray*)getCheckItems:(ListViewItemArray*)items {
    NSMutableArray *checkedTitles = [NSMutableArray new];
    
    for (ListViewItemDictionary *item in items) {
        NSNumber *checkedItem = item[STATUS_CHECK];
        
        if (checkedItem.boolValue) {
            [checkedTitles addObject:item[LIST_VIEW_NAME]];
        }
        ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
        
        if (subItems) {
            [checkedTitles addObjectsFromArray:[self getCheckItems:subItems]];
        }
    }
    
    return checkedTitles;
}

- (void) displayProjectStateId {
    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_STAGES");
    controller.listViewItems = self.listItemsProjectStageId;
    controller.filterViewControllerDelegate = self;
    controller.fieldValue = @"projectStageId";
    controller.singleSelect = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray*)filterBiddingWithinArray {
    NSArray *array = @[
                       @{PROJECT_SELECTION_TITLE:@"Any",PROJECT_SELECTION_VALUE:@(0),PROJECT_SELECTION_TYPE:@(ProjectFilterItemAny)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 7 Days",PROJECT_SELECTION_VALUE:@(7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 14 Days",PROJECT_SELECTION_VALUE:@(14),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 21 Days",PROJECT_SELECTION_VALUE:@(21),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Next 30 Days",PROJECT_SELECTION_VALUE:@(30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Last 7 Days",PROJECT_SELECTION_VALUE:@(-7),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Last 14 Days",PROJECT_SELECTION_VALUE:@(-14),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Last 21 Days",PROJECT_SELECTION_VALUE:@(-21),PROJECT_SELECTION_TYPE:@(ProjectFilterItemDays)},
                       
                       @{PROJECT_SELECTION_TITLE:@"Last 30 Days",PROJECT_SELECTION_VALUE:@(-30),PROJECT_SELECTION_TYPE:@(ProjectFilterItemMonths)}
                       ];
    
    return array;
}

- (void)filterBiddingWithin:(UIView*)view {
    
    NSNumber *biddingWithin = self.projectFilter.dictBiddingWithin[@"biddingInNext"];
    
    NSArray *array = [self filterBiddingWithinArray];
    NSDictionary *dict = [self filterBiddingWithinDictionary:array value:biddingWithin] ;
    
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
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
    
    NSDictionary *dict = nil;
    NSDictionary *buildingOrHighway = self.projectFilter.dictBH[@"buildingOrHighway"];
    
    if (buildingOrHighway) {
        NSArray *buildingOrHighwayArray = buildingOrHighway[@"inq"];
        
        if (buildingOrHighwayArray.count == 1) {
            
            if ([buildingOrHighwayArray containsObject:@"B"]) {
                dict = array[1];
            } else {
                dict = array[2];
            }
            
        } else {
            dict = array[0];
        }
    }
    
    FilterSelectionViewController *controller = [FilterSelectionViewController new];
    controller.filterSelectionViewControllerDelegate = self;
    [controller setDataBeenSelected:dict];
    [controller setDataInfo:array];
    controller.navTitle = NSLocalizedLanguage(@"PROJECT_FILTER_BH_TITLE");
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)filterOwner:(UIView*)view {
    
    NSDictionary *workOwner = self.projectFilter.dictOwnerType[@"ownerType"];
    
    NSArray *obj = @[@{@"title":@"Federal",@"id":@(1)},
                             @{@"title":@"Local Government",@"id":@(2)},
                             @{@"title":@"Military",@"id":@(3)},
                             @{@"title":@"Private",@"id":@(4)},
                             @{@"title":@"State",@"id":@(5)}
                             ] ;
    
    if (workOwner) {
        NSArray *items = workOwner[@"inq"];
        [self.projectFilter.fieldOwner setValue:items[0]];
    }
    
    WorkOwnerTypesViewController *controller = [WorkOwnerTypesViewController new];
    [controller setInfo:obj selectedItem:[self.projectFilter.fieldOwner getValue]];
    [controller setNavTitle:NSLocalizedLanguage(@"OWNER_TYPES_TITLE")];
    controller.workOwnerTypesViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)pushWorkTypes:(UIView*)view {
    [[DataManager sharedManager] workTypes:^(id obj){
        
        WorkOwnerTypesViewController *controller = [WorkOwnerTypesViewController new];
        [controller setInfo:obj selectedItem:[self.projectFilter.fieldWork getValue]];
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
    
    [_projectFilter setLocationValue:selectedLocationItems];
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

- (void)tappedFilterViewControllerApply:(NSMutableArray *)selectedItems key:(NSString *)key titles:(NSMutableArray *)titles nodes:(NSMutableArray *)nodes{

    if (selectedModel == FilterModelStage) {
        [_projectFilter setProjectStageValue:selectedItems titles:titles];
    } else if (selectedModel == FilterModelJurisdiction) {
        [_projectFilter setJurisdictionValue:selectedItems titles:titles];
    } else if (selectedModel == FilterModelProjectType) {
        [_projectFilter setProjectTypeValue:selectedItems titles:titles];
    }
}

- (void)tappedValuationApplyButton:(id)items {
    [_projectFilter setValuationValue:items];
}

- (void)tappedApplyButton:(id)items {
    NSDictionary *dict = items;
    if (dict) {
        if (selectedModel == FilterModelUpdated) {
            [_projectFilter setUpdatedWithinValue:items];
        } else if(selectedModel == FilterModelBH) {
            [_projectFilter setBHValue:items];
        } else if (selectedModel == FilterModelOwner) {
            [_projectFilter setOwnerTypeValue:items];
        } else if (selectedModel == FilterModelBidding) {
            [_projectFilter setBiddingWithinValue:items];
        }
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

    if (selectedModel == FilterModelOwner) {
        [_projectFilter setOwnerTypeValue:value];
    } else if(selectedModel == FilterModelWork) {
        [_projectFilter setWorkTypeValue:value];
    }

}

- (NSDictionary*)filterBiddingWithinDictionary:(NSArray*)array value:(NSNumber*)value{
    
    NSDictionary *dict = nil;
    NSNumber *selected = value;
    if (selected) {
        for (NSDictionary *item in array) {
            NSNumber *value = item[PROJECT_SELECTION_VALUE];
            
            if (value.integerValue == selected.integerValue) {
                dict = [item mutableCopy];
            }
        }
    }
    
    return dict;
}

@end

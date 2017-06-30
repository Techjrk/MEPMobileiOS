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

@interface SearchFilterViewController ()<ProjectFilterViewDelegate, CompanyFilterViewDelegate,WorkOwnerTypesViewControllerDelegate,FilterSelectionViewControllerDelegate,ValuationViewControllerDelegate, FilterViewControllerDelegate>{
    
    FilterModel selectedModel;
    NSMutableArray *selectedLocationItems;
    
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
        [self.companyFilter.filterBidding setValue:dict[PROJECT_SELECTION_TITLE]];
        
    }
    
    NSDictionary *jurisdictions = [DerivedNSManagedObject objectOrNil:searchFilter[@"jurisdictions"]];
    if (jurisdictions) {
        
        self.projectFilter.dictJurisdiction = @{@"jurisdictions":jurisdictions};
        self.companyFilter.dictJurisdiction = @{@"jurisdictions":jurisdictions};
        
        NSArray *inq = jurisdictions[@"inq"];
        if (inq) {
            
            if (self.listItemsJurisdictions.count>0) {
                NSArray *title = [FilterViewController getCheckedTitles:self.listItemsJurisdictions list:nil];
                NSString *str = [title componentsJoinedByString:@", "];
                
                [self.projectFilter.fieldJurisdiction setValue:str];
                [self.companyFilter.fieldJurisdiction setValue:str];
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
        [self.companyFilter.filterValue setInfo:@[@{@"entryID": @(0), @"entryTitle": value}]];
        
    }
    
    NSDictionary *items = searchFilter[@"projectTypeId"];
    if (items) {
        
        self.projectFilter.dictProjectType = @{@"projectTypeId":items};
        self.companyFilter.dictProjectType = @{@"projectTypes":items};
        
        if (self.listItemsProjectTypeId.count>0) {
            NSArray *array = [FilterViewController getCheckedTitles:self.listItemsProjectTypeId list:nil];
            [self.companyFilter.filterProjectType setValue:[array componentsJoinedByString:@", "]];
            
            NSMutableArray *itemArray = [NSMutableArray new];
            
            for (NSString *item in array) {
                NSDictionary *dict = @{ENTRYTITLE:item};
                [itemArray addObject:dict];
            }
            
            [self.projectFilter.fieldType setInfo:itemArray];
        }
        
    }
    
    NSDictionary *projectLocation = searchFilter[@"projectLocation"];
    if (projectLocation) {
        
        self.projectFilter.dictLocation = @{@"projectLocation":projectLocation};
        self.companyFilter.dictLocation = @{@"companyLocation":projectLocation};
        
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
        [self prepareLocation:self.companyFilter.fieldLocation address:projectLocation];
        
        [self.projectFilter.fieldLocation setInfo:items];
        [self.companyFilter.fieldLocation setInfo:items];
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
    
    [self.searchFilterViewControllerDelegate tappedSearchFilterViewControllerApply:[_projectFilter filter] companyFilter:[_companyFilter filter] ];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - ProjectFilterViewDelegate

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
                        [_companyFilter setLocationValue:object];
                        
                        if (_projectFilter.dictLocation) {
                            _companyFilter.dictLocation = @{@"companyLocation":_projectFilter.dictLocation[@"projectLocation"]};
                        } else {
                            _companyFilter.dictLocation = nil;
                        }
                    } title:NSLocalizedLanguage(@"PROJECT_FILTER_HINT_LOCATION")];
                } else {
                    //[self filterLocation:view object:object];
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
                
                FilterEntryView *entryView = object;
                
                if (entryView.entryType == FilterEntryViewTypeOpenEntry) {
                    
                    if (entryView.openEntryFields == nil) {
                        entryView.openEntryFields = [NSMutableArray new];
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"city",@"VALUE":@"",@"placeHolder":@"COMPANY_FILTER_HINT_LOCATION_CITY"} mutableCopy ]];
                        
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"state",@"VALUE":@"",@"placeHolder":@"COMPANY_FILTER_HINT_LOCATION_STATE"} mutableCopy ]];
         
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"county",@"VALUE":@"",@"placeHolder":@"COMPANY_FILTER_HINT_LOCATION_COUNTY"} mutableCopy ]];
                        
                        [entryView.openEntryFields addObject:[@{@"FIELD":@"zip5",@"VALUE":@"",@"placeHolder":@"COMPANY_FILTER_HINT_LOCATION_ZIP"} mutableCopy ]];
                        
                    }
                    [entryView promptOpenEntryUsingViewController:self block:^(id object) {
                        [_companyFilter setLocationValue:object];
                        [_projectFilter setLocationValue:object];
                        
                        if (_companyFilter.dictLocation) {
                            _projectFilter.dictLocation = @{@"projectLocation":_companyFilter.dictLocation[@"companyLocation"]};
                        } else {
                            _projectFilter.dictLocation = nil;
                        }
                    } title:NSLocalizedLanguage(@"COMPANY_FILTER_HINT_LOCATION")];
                } else {
                    //[self filterLocation:view object:object];
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
        if (self.listItemsProjectStageId) {
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
    
    if ((self.listItemsProjectStageId == nil) || (self.listItemsProjectStageId.count == 0)) {
        
        ListViewItemArray *listItems = nil;
        if (self.listItemsProjectStageId) {
            listItems = self.listItemsProjectStageId;
        } else {
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
            [self displayProjectStateId];
            
        } failure:^(id object) {
            
        }];
    } else {
        if (view) {
            [self displayProjectStateId];
        }else {
            NSString *stage = [[self getCheckItems:self.listItemsProjectStageId] componentsJoinedByString:@", "];
            [self.projectFilter.fieldStage setValue:stage];
        }
    
    }

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

#pragma mark - Work Types

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

/*
- (void)filterLocation:(UIView*)view object:(id)object{

    ProjectFilterLocationViewController *controller = [ProjectFilterLocationViewController new];
    controller.dataSelected = [(FilterEntryView *)object getCollectionItemsData];
    controller.projectFilterLocationViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
*/
- (void)filterValue:(UIView*)view {
    
    ValuationViewController *controller =  [ValuationViewController new];
    
    NSDictionary *dict  = nil;
    
    if(_companyFilter.hidden ) {
        dict = _projectFilter.dictProjectValue[@"projectValue"];
    } else {
        dict = _companyFilter.dictValue[@"valuation"];
    }
    
    controller.valuationValue = dict;
    controller.valuationViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (NSArray*)filterUpdatedWithinArray{
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

    NSMutableArray *obj = [@[@{@"title":@"Federal",@"id":@(1)},
                             @{@"title":@"Local Government",@"id":@(2)},
                             @{@"title":@"Military",@"id":@(3)},
                             @{@"title":@"Private",@"id":@(4)},
                             @{@"title":@"State",@"id":@(5)}
                             ] mutableCopy];
    
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

#pragma mark - FilterTypes Delegate

- (void)tappedTypesApplyButton:(id)items {
    
}

#pragma mark - Location Delegate

- (void)tappedLocationApplyButton:(id)items {
   selectedLocationItems = [NSMutableArray new];
    [self getLocationData:items];

    [_projectFilter setLocationValue:selectedLocationItems];
    [_companyFilter setLocationValue:selectedLocationItems];

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
    if (selectedModel == FilterModelOwner) {
        [_projectFilter setOwnerTypeValue:value];
    } else if(selectedModel == FilterModelWork) {
        [_projectFilter setWorkTypeValue:value];
    }
   
}

#pragma mark - FilterSelectionViewControllerDelegate

- (void)tappedApplyButton:(id)items {
    
    NSDictionary *dict = items;
    
    if (dict) {
        
        if (_companyFilter.hidden) {
            
            if (selectedModel == FilterModelUpdated) {
                [_projectFilter setUpdatedWithinValue:items];
            } else if(selectedModel == FilterModelBH) {
                [_projectFilter setBHValue:items];
            } else if (selectedModel == FilterModelOwner) {
                [_projectFilter setOwnerTypeValue:items];
            }
        }
        if (selectedModel == FilterModelBidding) {
            [_companyFilter setBiddingValue:items];
            [_projectFilter setBiddingWithinValue:items];
        }

    }
    
}

#pragma mark - Valuation Delegate

- (void)tappedValuationApplyButton:(id)items {
    
    [_projectFilter setValuationValue:items];
    [_companyFilter setValuationValue:items];
    
}

- (void)tappedFilterViewControllerApply:(NSMutableArray *)selectedItems key:(NSString *)key titles:(NSMutableArray *)titles nodes:(NSMutableArray *)nodes{
    
    if (selectedModel == FilterModelStage) {
        [_projectFilter setProjectStageValue:selectedItems titles:titles];
    } else if (selectedModel == FilterModelJurisdiction) {
        [_companyFilter setJurisdictionValue:selectedItems titles:titles];
        [_projectFilter setJurisdictionValue:selectedItems titles:titles];
        
        
        if (self.companyFilter.hidden) {
            
            if (_projectFilter.dictJurisdiction) {
                _companyFilter.dictJurisdiction = @{@"jurisdictions":_projectFilter.dictJurisdiction[@"jurisdictions"]};
            } else {
                _companyFilter.dictJurisdiction = nil;
            }
            
        } else {
            
            if (_companyFilter.dictJurisdiction) {
                _projectFilter.dictJurisdiction = @{@"jurisdictions":_companyFilter.dictJurisdiction[@"jurisdictions"]};
            } else {
                _projectFilter.dictJurisdiction = nil;
            }
            
        }

        
        
    } else if (selectedModel == FilterModelProjectType) {
        [_companyFilter setProjectTypeValue:selectedItems titles:titles];
        [_projectFilter setProjectTypeValue:selectedItems titles:titles];
        
        if (self.companyFilter.hidden) {
            
            if (_projectFilter.dictProjectType) {
                _companyFilter.dictProjectType = @{@"projectTypes":_projectFilter.dictProjectType[@"projectTypeId"]};
            } else {
                _companyFilter.dictProjectType = nil;
            }
            
        } else {

            if (_companyFilter.dictProjectType) {
                _projectFilter.dictProjectType = @{@"projectTypeId":_companyFilter.dictProjectType[@"projectTypes"]};
            } else {
                _projectFilter.dictProjectType = nil;
            }

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
            
            title = @"biddingInNext";
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

@end

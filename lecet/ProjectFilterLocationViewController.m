//
//  ProjectFilterLocationViewController.m
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterLocationViewController.h"
#import "ProjectFilterSearchNavView.h"
#import "ProjectFilterCollapsibleListView.h"

@interface ProjectFilterLocationViewController ()<ProjectFilterSearchNavViewDelegate,ProjectFilterCollapsibleListViewDelegate>{
    NSMutableArray *dataInfo;
    
    NSArray *dataSelected;
}
@property (weak, nonatomic) IBOutlet ProjectFilterSearchNavView *navView;
@property (weak, nonatomic) IBOutlet ProjectFilterCollapsibleListView *listView;


@end

@implementation ProjectFilterLocationViewController
@synthesize dataSelected;

#define PROJECTGROUPID              @"id"

#define INDEXFORSEARCHRESULT        @"index"
#define DATARESULTINSECONDLAYER     @"dataresultInSecondLayer"
#define ENTRY_ID                    @"entryID"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _navView.projectFilterSearchNavViewDelegate = self;
    _listView.projectFilterCollapsibleListViewDelegate = self;
    [self enableTapGesture:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    
    NSArray *array = @[@{TITLENAME:@"California",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,ENTRY_ID:@0,
                         SUBCATEGORYDATA:
                             @[@{TITLENAME:@"San Francisco",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,ENTRY_ID:@1},
                               @{TITLENAME:@"San Jose",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,ENTRY_ID:@2},
                               @{TITLENAME:@"Santa Ana",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,ENTRY_ID:@3}
                               ],                         },
                       @{TITLENAME:@"Utah",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,ENTRY_ID:@4,
                         SUBCATEGORYDATA:@[@{TITLENAME:@"Salt Lake City",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,ENTRY_ID:@5}]
                         },
                       @{TITLENAME:@"Texas",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,ENTRY_ID:@6,
                         SUBCATEGORYDATA:@[@{TITLENAME:@"San Antonio",SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,ENTRY_ID:@7}]}
                       ];
    
    dataInfo = [array mutableCopy];
    
    [_listView setInfo:[dataInfo copy]];
    [_navView setSearchTextFieldPlaceHolder:NSLocalizedLanguage(@"PROJECT_LOCATION_SEARCH_PLACEHOLDER")];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setInfo:(id)info {
    
    dataInfo = info;
}

#pragma mark Nav Delegate

- (void)tappedFilterSearchNavButton:(ProjectFilterSearchNavItem)item {
    
    switch (item) {
            
        case ProjectFilterSearchNavItemBack:{
            
            break;
        }
        case ProjectFilterSearchNavItemApply:{
            
            [_projectFilterLocationViewControllerDelegate tappedLocationApplyButton:dataSelected];
            break;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldChanged:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        NSString *searchText = [NSString stringWithFormat:@"%@*",textField.text];
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.title like[cd] %@", searchText];
        NSArray *filteredFirstLayer = [[dataInfo copy] filteredArrayUsingPredicate:resultPredicate];
        
        
        if (filteredFirstLayer.count > 0) {
            
            NSArray *configureFilter = [[self changeDropDownSelectionValueOnceSearch:filteredFirstLayer] copy];
            [_listView setInfoToReload:configureFilter];
            
        } else {
            int countIndex = 0;
            
            NSMutableArray *searchReultFromSubCat = [NSMutableArray new];
            for (id obj in dataInfo) {
                countIndex++;
                NSArray *filteredSecondLayer = [obj[SUBCATEGORYDATA] filteredArrayUsingPredicate:resultPredicate];
                NSUInteger index = [obj[SUBCATEGORYDATA]  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                    return [resultPredicate evaluateWithObject:obj];
                }];
                
                if (filteredSecondLayer.count > 0) {
                    NSNumber *num = [NSNumber numberWithInt:countIndex-1];
                    NSNumber *secNum = [NSNumber numberWithInt:(int)index];
                    NSDictionary *dict = @{INDEXFORSEARCHRESULT:num,@"dataresultInSecondLayer":filteredSecondLayer,@"indexInSecondLayer":secNum};
                    [searchReultFromSubCat addObject:dict];
                }
            }
            
            NSMutableArray *secondSubCatSearchResult = [self configuredSearchResult:searchReultFromSubCat];
            [_listView setInfoToReload:[secondSubCatSearchResult copy]];
            
        }
        
    } else {
        
        [_listView setInfoToReload:[dataInfo copy]];
    }
}

#pragma mark - Misc Method

- (NSMutableArray *)changeDropDownSelectionValueOnceSearch:(NSArray *)array {
    NSMutableArray *resArray = [NSMutableArray new];
    
    for (id obj in [array mutableCopy]) {
        NSMutableDictionary *resDict = [obj mutableCopy];
        [resDict setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
        [resDict setValue:SelectedFlag forKey:DROPDOWNFLAGNAME];
        [resArray addObject:resDict];
    }
    return resArray;
}

- (NSMutableArray *)configuredSearchResult:(NSMutableArray *)mutableArray {
    NSMutableArray *resArray = [NSMutableArray new];
    
    for (id searchResult in mutableArray) {
        
        int indexID = [searchResult[INDEXFORSEARCHRESULT] intValue];
        NSMutableDictionary *dic = [[dataInfo objectAtIndex:indexID] mutableCopy];
        [dic setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
        [dic setValue:SelectedFlag forKey:DROPDOWNFLAGNAME];
        [dic setValue:searchResult[DATARESULTINSECONDLAYER] forKey:SUBCATEGORYDATA];
        
        [resArray addObject:dic];
        
    }
    
    return resArray;
}

- (NSMutableArray *)configuredSearchResultWithAutoSelect:(NSMutableArray *)mutableArray {
    NSMutableArray *resArray = [NSMutableArray new];
    
    for (id searchResult in mutableArray) {
        
        int indexID = [searchResult[INDEXFORSEARCHRESULT] intValue];
        NSMutableDictionary *dic = [[dataInfo objectAtIndex:indexID] mutableCopy];
        [dic setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
        [dic setValue:SelectedFlag forKey:DROPDOWNFLAGNAME];
        
        for (id resultSecond in searchResult[DATARESULTINSECONDLAYER]) {
            
            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"id == %@", resultSecond[@"id"]];
            NSUInteger indexSec = [dic[SUBCATEGORYDATA]  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                return [resultPredicate evaluateWithObject:obj];
            }];
            NSMutableDictionary *secondDict = [dic[SUBCATEGORYDATA] objectAtIndex:indexSec];
            [secondDict setValue:SelectedFlag forKey:SELECTIONFLAGNAME];
            [secondDict setValue:UnSelectedFlag forKey:DROPDOWNFLAGNAME];
            
            [[dic[SUBCATEGORYDATA] mutableCopy] replaceObjectAtIndex:indexSec withObject:secondDict];
            
        }
        
        [resArray addObject:dic];
        
    }
    
    return resArray;
}

- (void)tappedSelectionButton:(id)items {
    NSMutableArray *resArray = [NSMutableArray new];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.selectionFlag == %@", @"1"];

        int countIndex = 0;
        for (id obj in items) {
            NSMutableDictionary *dict = [obj mutableCopy];
            countIndex++;
            
            if ([obj[SELECTIONFLAGNAME] isEqualToString:SelectedFlag]) {
                [resArray addObject:dict];
            }else {
                
                NSArray *filteredSecondLayer = [obj[SUBCATEGORYDATA] filteredArrayUsingPredicate:resultPredicate];
                if (filteredSecondLayer.count > 0) {
             
                    [dict setValue:filteredSecondLayer forKey:SUBCATEGORYDATA];
                    [resArray addObject:dict];
                }

            }
            
        }
    dataSelected = resArray;
    
}

- (void)selectTheDataThatBeenSelected:(id)dInfo {
    
    NSMutableDictionary *dict;
    NSMutableDictionary *dictMSec;
    NSMutableArray *arrayFL = [NSMutableArray new];
    NSMutableArray *arraySub = [NSMutableArray new];
    
    for (id data in dInfo) {
        dict = [data mutableCopy];
        if([dataSelected containsObject:data[ENTRY_ID]]) {
            [dict setValue:SelectedFlag forKey:SELECTIONFLAGNAME];
            [dict setValue:SelectedFlag forKey:DROPDOWNFLAGNAME];
        }
        
        /*
        for (id dataSec in data[SUBCATEGORYDATA]) {
            dictMSec = [dataSec mutableCopy];
            if([dataSelected containsObject:data[ENTRY_ID]]) {
                [dictMSec setValue:SelectedFlag forKey:SELECTIONFLAGNAME];
                [dictMSec setValue:SelectedFlag forKey:DROPDOWNFLAGNAME];
            }
            
            [arraySub addObject:dictMSec];
        }
        
        [dict setValue:dictMSec forKey:SUBCATEGORYDATA];
        */
        
        [arrayFL addObject:dict];
    }
    
    dataInfo = arrayFL;
}

@end

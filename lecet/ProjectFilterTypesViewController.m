//
//  ProjectFilterTypesViewController.m
//  lecet
//
//  Created by Michael San Minay on 28/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterTypesViewController.h"
#import "ProjectFilterSearchNavView.h"
#import "ProjectFilterCollapsibleListView.h"


@interface ProjectFilterTypesViewController ()<ProjectFilterSearchNavViewDelegate,ProjectFilterCollapsibleListViewDelegate>{
    NSMutableArray *dataInfo;
    NSArray *dataSelected;
}
@property (weak, nonatomic) IBOutlet ProjectFilterSearchNavView *navView;
@property (weak, nonatomic) IBOutlet ProjectFilterCollapsibleListView *listView;
@property (strong,nonatomic) NSOperationQueue *operationQueue;

@end

@implementation ProjectFilterTypesViewController
#define UnSelectedFlag              @"0"
#define SelectedFlag                @"1"
#define SELECTIONFLAGNAME           @"selectionFlag"
#define DROPDOWNFLAGNAME            @"dropDownFlagName"
#define TITLENAME                   @"title"
#define PROJECTGROUPID              @"id"
#define SUBCATEGORYDATA             @"SubData"
#define SECONDSUBCATDATA            @"SECONDSUBCATDATA"

#define INDEXFORSEARCHRESULT        @"index"
#define DATARESULTINSECONDLAYER     @"dataresultInSecondLayer"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView.projectFilterSearchNavViewDelegate = self;
    _listView.projectFilterCollapsibleListViewDelegate = self;
    [self enableTapGesture:YES];
    
}


- (void)setInfoGroupList:(id)obj categoryList:(id)catList {
    
   dataInfo =  [self manipulatedDataInfoGroupListInfo:obj categoryListInfo:catList];
}

- (void)setInfo:(id)info {
    dataInfo = info;
}

- (void)viewWillAppear:(BOOL)animated {
    [_listView setInfo:[dataInfo copy]];
    [_navView setSearchTextFieldPlaceHolder:NSLocalizedLanguage(@"PROJECT_TYPES_SEARCH_PLACEHOLDER")];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark Nav Delegate
- (void)tappedFilterSearchNavButton:(ProjectFilterSearchNavItem)item {
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

- (void)requestSubData:(int)index {
    [_operationQueue addOperationWithBlock:^{
        
        NSNumber *num = [dataInfo objectAtIndex:index][PROJECTGROUPID];
        
        [[DataManager sharedManager] projectCategoryLisByGroupID:num success:^(id obj){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSMutableArray *enumObj = [NSMutableArray new];
                
                for (id result in [obj mutableCopy]) {
                    NSMutableDictionary *res = [result mutableCopy];
                    
                    [res setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
                    [res setValue:UnSelectedFlag forKey:DROPDOWNFLAGNAME];
                    [enumObj addObject:res];
                }
               
                NSMutableDictionary *dictFinal = [[dataInfo objectAtIndex:index] mutableCopy];
                [dictFinal setValue:enumObj forKey:SUBCATEGORYDATA];
                [_listView replaceInfo:dictFinal atSection:index];

            }];
            
        }failure:^(id obj){
            
        }];

    }];

}

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

#pragma mark - Data Manipulation


- (NSMutableArray *)manipulatedDataInfoGroupListInfo:(id)obj categoryListInfo:(id)catObj {
    NSMutableArray *mutArray = [NSMutableArray new];
    
    for (id headerObj in obj) {
        
        NSMutableArray *configuredSubArray = [self addDropDownButtonAndSelectionFlagInArray:catObj];
        NSMutableArray *subArray = [self filteredArray:configuredSubArray projectGroupId:headerObj[PROJECTGROUPID]];
        NSDictionary *dict = @{TITLENAME:headerObj[TITLENAME],PROJECTGROUPID:headerObj[PROJECTGROUPID],SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,SUBCATEGORYDATA:subArray};
        [mutArray addObject:dict];
    }
    
    return mutArray;

}

- (NSMutableArray *)filteredArray:(NSMutableArray *)array projectGroupId:(NSNumber *)numID {
    
    NSArray *filtered = [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary* evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject valueForKey:@"projectGroupId"] isEqual:numID];
    }]];
    
    return [filtered mutableCopy];
}


- (NSMutableArray *)addDropDownButtonAndSelectionFlagInArray:(NSArray *)subCatArray {
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (id  result in [subCatArray mutableCopy]) {
        NSMutableDictionary *res = [result mutableCopy];
        [res setValue:UnSelectedFlag forKey:SELECTIONFLAGNAME];
        [res setValue:UnSelectedFlag forKey:DROPDOWNFLAGNAME];
        [array addObject:res];
    }
    
    return array;
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
    dataSelected = [resArray copy];
}

@end

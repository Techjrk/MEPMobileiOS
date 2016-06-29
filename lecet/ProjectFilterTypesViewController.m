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


@interface ProjectFilterTypesViewController ()<ProjectFilterSearchNavViewDelegate>{
    NSMutableArray *dataInfo;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView.projectFilterSearchNavViewDelegate = self;
    [self enableTapGesture:YES];
    
}

- (void)setInfo:(id)info {
    
    /*
    dataInfo = [NSMutableArray new];
    _operationQueue = [[NSOperationQueue alloc] init];
    int count = 0;
    for (id obj in info) {
        NSDictionary *dict = @{TITLENAME:obj[TITLENAME],PROJECTGROUPID:obj[PROJECTGROUPID],SELECTIONFLAGNAME:UnSelectedFlag,DROPDOWNFLAGNAME:UnSelectedFlag,SUBCATEGORYDATA:@[]};
        [dataInfo addObject:dict];
        count++;
        
        [self requestSubData:count - 1];
    }
    */
    dataInfo = info;
}

- (void)viewWillAppear:(BOOL)animated {

    [_listView setInfo:[dataInfo copy]];
    
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
    
    NSArray *filtered = [[dataInfo copy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"ANY %K LIKE[cd] %@",@"tags",@"*"]];
   

    NSLog(@"TitleName = %@",filtered);
    //NSLog(@"DataInfo = %@",dataInfo);
}


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
            NSLog(@"Failed Object = %@",obj);
        }];

    }];
    

}

@end

//
//  SearchViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchSectionCollectionViewCell.h"
#import "SearchSuggestedCollectionViewCell.h"
#import "SearchProjectCollectionViewCell.h"
#import "SearchCompanyCollectionViewCell.h"
#import "SearchContactCollectionViewCell.h"
#import "SearchSavedCollectionViewCell.h"
#import "SearchResultCollectionViewCell.h"
#import "SearchResultView.h"
#import "SearchFilterViewController.h"
#import "RefineSearchViewController.h"
#import "ProjectDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "ContactDetailViewController.h"
#import "RecentSearchCollectionViewCell.h"
#import "SeeAllCollectionViewCell.h"
#import "SaveSearchChangeItemView.h"

#define SEACRCH_TEXTFIELD_TEXT_FONT                     fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)

#define SEACRCH_PLACEHOLDER_FONT                        fontNameWithSize(FONT_NAME_AWESOME, 14)
#define SEACRCH_PLACEHOLDER_COLOR                       RGB(255, 255, 255)
#define SEACRCH_PLACEHOLDER_TEXT                        [NSString stringWithFormat:@"%C", 0xf002]

typedef enum : NSUInteger {
    SearchSectionRecent = 0,
    SearchSectionSavedProject = 1,
    SearchSectionSavedCompany = 2,
    SearchSectionSuggested = 3,
    SearchSectionProjects = 4,
    SearchSectionCompanies = 5,
    SearchSectionContacts = 6,
    SearchSectionResult = 7,
} SearchSection;


@interface SearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, SeeAllCollectionViewCellDelegate, SearchResultViewDelegate, SaveSearchChangeItemViewDelegate>{
    BOOL searchMode;
    BOOL showResult;
    NSMutableDictionary *collectionItems;
    BOOL isPushingController;
    UIButton *button;
}
@property (weak, nonatomic) IBOutlet SaveSearchChangeItemView *saveSearchesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSaveSearchesHeight;
@property (strong, nonatomic) NSNumber *resultIndex;
@property (weak, nonatomic) IBOutlet UITextField *labeSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak,nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintCollectionBottomLeading;
- (IBAction)tappedButtonBack:(id)sender;
@end

@implementation SearchViewController

#define kSections               @[NSLocalizedLanguage(@"SEARCH_SECTION_RECENT"),NSLocalizedLanguage(@"SEARCH_SECTION_SAVED_PROJECT"),NSLocalizedLanguage(@"SEARCH_SECTION_SAVED_COMPANY"),NSLocalizedLanguage(@"SEARCH_SECTION_SUGGESTED"),NSLocalizedLanguage(@"SEARCH_SECTION_PROJECTS"),NSLocalizedLanguage(@"SEARCH_SECTION_COMPANIES"),NSLocalizedLanguage(@"SEARCH_SECTION_CONTACTS"), NSLocalizedLanguage(@"SEARCH_SECTION_RESULT")]

#define kCellIdentifier(section)         [NSString stringWithFormat:@"kCellIdentifier_%li",(long)section]

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    collectionItems = [[NSMutableDictionary alloc] init];
    
    collectionItems[SEARCH_RESULT_PROJECT] = [[NSMutableDictionary alloc] init];
    collectionItems[SEARCH_RESULT_COMPANY] = [[NSMutableDictionary alloc] init];
    collectionItems[SEARCH_RESULT_CONTACT] = [[NSMutableDictionary alloc] init];
    collectionItems[SEARCH_RESULT_SAVED_PROJECT] = [[NSMutableArray alloc] init];
    collectionItems[SEARCH_RESULT_SAVED_COMPANY] = [[NSMutableArray alloc] init];
    
    [self enableTapGesture:YES];
    _labeSearch.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _labeSearch.layer.cornerRadius = kDeviceWidth * 0.0106;
    _labeSearch.layer.masksToBounds = YES;
    
    _constraintSaveSearchesHeight.constant = 0;
    _saveSearchesView.saveSearchChangeItemViewDelegate = self;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kDeviceWidth * 0.1, kDeviceHeight * 0.025);
    [button setImage:[UIImage imageNamed:@"icon_filter"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_filter_apply"] forState:UIControlStateSelected];
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(tappedButtonFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_clearButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    [_clearButton setHidden:YES];
    
    _labeSearch.rightView = button;
    _labeSearch.rightViewMode = UITextFieldViewModeAlways;
    _labeSearch.delegate = self;
    
    _labeSearch.textColor = [UIColor whiteColor];
    _labeSearch.font = SEACRCH_TEXTFIELD_TEXT_FONT;
    [_labeSearch setTintColor:[UIColor whiteColor]];
    [_labeSearch addTarget:self action:@selector(onEditing:) forControlEvents: UIControlEventEditingChanged];
    
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:SEACRCH_PLACEHOLDER_TEXT attributes:@{NSFontAttributeName:SEACRCH_PLACEHOLDER_FONT, NSForegroundColorAttributeName:SEACRCH_PLACEHOLDER_COLOR}];
    
    [placeHolder appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",NSLocalizedLanguage(@"SEARCH_PLACEHOLDER")] attributes:@{NSFontAttributeName:SEACRCH_TEXTFIELD_TEXT_FONT, NSForegroundColorAttributeName:SEACRCH_PLACEHOLDER_COLOR}]];
    _labeSearch.attributedPlaceholder = placeHolder;
  
    [_collectionView registerNib: [UINib nibWithNibName:[[SearchSectionCollectionViewCell class] description] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[[SearchSectionCollectionViewCell class] description]];
  
    [_collectionView registerNib: [UINib nibWithNibName:[[SeeAllCollectionViewCell class] description] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[[SeeAllCollectionViewCell class] description]];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[RecentSearchCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionRecent)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchSavedCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionSavedProject)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchSavedCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionSavedCompany)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchSuggestedCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionSuggested)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchProjectCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionProjects)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchCompanyCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionCompanies)];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[SearchContactCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionContacts)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchResultCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionResult)];

    searchMode = NO;
    showResult = NO;
    
    _resultIndex = [NSNumber numberWithInteger:0];
    
    [[DataManager sharedManager] savedSearches:collectionItems success:^(id object) {
        [_collectionView reloadData];
    } failure:^(id object) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

#pragma mark - Navigation Methods

- (void)tappedButtonFilter:(id)sender {
    
    SearchFilterViewController *controller = [SearchFilterViewController new];
    [self.navigationController pushViewController:controller animated:YES];
    
    /*
    RefineSearchViewController *controller = [RefineSearchViewController new];
    [self.navigationController pushViewController:controller animated:YES];
     */
}

- (IBAction)tappedButtonBack:(id)sender {

    if (showResult) {
        showResult = NO;
        [_collectionView reloadData];
    } else if (searchMode) {
        searchMode = NO;
        [_collectionView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UICollectionView Delegate and DataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier(indexPath.section) forIndexPath:indexPath];
    
    SearchSection sectionType = (SearchSection)indexPath.section;
    
    switch (sectionType) {
        case SearchSectionRecent: {
            
            RecentSearchCollectionViewCell *cellItem = (RecentSearchCollectionViewCell*)cell;
            [cellItem setInfo:nil];
            break;
        }
            
        case SearchSectionSavedProject: {
            
            NSArray *items = collectionItems[SEARCH_RESULT_SAVED_PROJECT];
            NSDictionary *item = items[indexPath.row];
            SearchSavedCollectionViewCell *cellItem = (SearchSavedCollectionViewCell*)cell;
            [cellItem setInfo:item];
            
            break;
        }
            
        case SearchSectionSavedCompany: {
            
            NSArray *items = collectionItems[SEARCH_RESULT_SAVED_COMPANY];
            NSDictionary *item = items[indexPath.row];
            SearchSavedCollectionViewCell *cellItem = (SearchSavedCollectionViewCell*)cell;
            [cellItem setInfo:item];
            
            break;
        }
            
        case SearchSectionSuggested: {
            
            SearchSuggestedCollectionViewCell *cellItem = (SearchSuggestedCollectionViewCell*)cell;
            
            NSMutableDictionary *result = nil;
            
            switch (indexPath.row) {
                case 0: {
                    result = collectionItems[SEARCH_RESULT_PROJECT];
                    break;
                }
                    
                case 1: {
                    result = collectionItems[SEARCH_RESULT_COMPANY];
                    break;
                }
                    
                case 2: {
                    result = collectionItems[SEARCH_RESULT_CONTACT];
                    break;
                }
                    
            }
            
            NSNumber *total = [DerivedNSManagedObject objectOrNil:result[@"total"]];
            NSInteger count = 0;
            if( total != nil) {
                count = total.integerValue;
            }
            
            [cellItem setInfo:_labeSearch.text count:count headerType:(SearchSuggestedHeader)indexPath.row];
            
            break;
        }
            
        case SearchSectionResult: {
            SearchResultCollectionViewCell *cellItem = (SearchResultCollectionViewCell*)cell;
            cellItem.navigationController = self.navigationController;
            cellItem.searchResultViewDelegate = self;
            [cellItem setCollectionItems:collectionItems tab:_resultIndex];
            [cellItem reloadData];
            break;
        }
            
        case SearchSectionProjects: {
            
            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
            NSArray *items = result[@"results"];
            
            SearchProjectCollectionViewCell *cellItem = (SearchProjectCollectionViewCell*)cell;
            [cellItem setInfo:items[indexPath.row ]];
            
            break;
        }
            
        case SearchSectionCompanies: {

            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_COMPANY];
            NSArray *items = result[@"results"];
            
            SearchCompanyCollectionViewCell *cellItem = (SearchCompanyCollectionViewCell*)cell;
            [cellItem setInfo:items[indexPath.row ]];

            break;
        }
            
        case SearchSectionContacts: {
 
            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_CONTACT];
            NSArray *items = result[@"results"];
            
            SearchContactCollectionViewCell *cellItem = (SearchContactCollectionViewCell*)cell;
            [cellItem setInfo:items[indexPath.row ]];

            break;
        }
    }

    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    collectionView.backgroundColor = showResult?[UIColor clearColor]:[UIColor whiteColor];

    return kSections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    SearchSection sectionType = (SearchSection)section;
    
    if ([self shouldShowSection:section] | ((sectionType == SearchSectionSuggested) & searchMode) | ((sectionType == SearchSectionResult) & showResult) ) {

        switch (sectionType) {
                
            case SearchSectionRecent: {
                count = showResult?0:1;
                break;
            }
                
            case SearchSectionSavedProject: {
                NSArray *items = collectionItems[SEARCH_RESULT_SAVED_PROJECT];
                count = showResult?0:items.count;
                break;
            }
                
            case SearchSectionSavedCompany: {
                NSArray *items = collectionItems[SEARCH_RESULT_SAVED_COMPANY];
                count = showResult?0:items.count;
                break;
            }
                
            case SearchSectionSuggested: {
                count = showResult?0:3;
                break;
            }
                
            case SearchSectionProjects: {
                NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
                NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
                count = showResult?0:(items.count>4?4:items.count);
                break;
            }
                
            case SearchSectionCompanies: {
                NSMutableDictionary *result = collectionItems[SEARCH_RESULT_COMPANY];
                NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
                count = showResult?0:(items.count>4?4:items.count);
                break;
            }
                
            case SearchSectionContacts: {
                NSMutableDictionary *result = collectionItems[SEARCH_RESULT_CONTACT];
                NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
                count = showResult?0:( items.count>4?4:items.count);
                break;
            }
                
            case SearchSectionResult: {
                count = showResult?1:0;
            }
                
        }

    }
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
  
    SearchSection sectionType = (SearchSection)indexPath.section;
    
    if ([self shouldShowSection:indexPath.section] | (sectionType == SearchSectionSuggested ) | (sectionType == SearchSectionResult )) {

        switch (sectionType) {
                
            case SearchSectionRecent: {
                size = CGSizeMake(collectionView.frame.size.width, kDeviceHeight * 0.18);
                break;
            }
                
            case SearchSectionSavedProject: {
                size = CGSizeMake(collectionView.frame.size.width, kDeviceHeight * 0.071);
                break;
            }
                
            case SearchSectionSavedCompany: {
                size = CGSizeMake(collectionView.frame.size.width, kDeviceHeight * 0.071);
                break;
            }
    
            case SearchSectionSuggested: {
                size = CGSizeMake(collectionView.frame.size.width, kDeviceHeight * 0.073);
                break;
            }
                
            case SearchSectionProjects: {
                size = CGSizeMake(collectionView.frame.size.width, kDeviceHeight * 0.12);
                break;
            }
                
            case SearchSectionCompanies: {
                size = CGSizeMake(collectionView.frame.size.width, kDeviceHeight * 0.12);
                break;
            }
                
            case SearchSectionContacts: {
                size = CGSizeMake(collectionView.frame.size.width, kDeviceHeight * 0.1);
                break;
            }
                
            case SearchSectionResult: {
                size = CGSizeMake(collectionView.frame.size.width, _collectionView.frame.size.height);
                break;
                
            }
                
        }

    }
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    SearchSection sectionType = (SearchSection)section;
    
    BOOL shouldHaveInset = [self shouldShowSection:section] | (sectionType == SearchSectionSuggested );
    
    if (showResult) {
        shouldHaveInset = NO;
    } else {
     
        if (searchMode) {
            shouldHaveInset = [self sectionHasRecord:sectionType];
        }
        
    }

    return UIEdgeInsetsMake( 0, 0, kDeviceHeight * (shouldHaveInset?0.024:0), 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchSection sectionType = (SearchSection)indexPath.section;
    
    if (sectionType == SearchSectionSuggested) {
       // [self showSaveSearches:YES];
        _resultIndex = [NSNumber numberWithInteger:indexPath.row];
        showResult = YES;
        [_collectionView reloadData];

    } else if (sectionType == SearchSectionProjects) {
      
        if (!isPushingController) {
            isPushingController = YES;
            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
            NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
            NSDictionary *item = items[indexPath.row];
            
            [[DataManager sharedManager] projectDetail:item[@"id"] success:^(id object) {
                
                ProjectDetailViewController *detail = [ProjectDetailViewController new];
                detail.view.hidden = NO;
                [detail detailsFromProject:object];
                
                isPushingController = NO;
                [self.navigationController pushViewController:detail animated:YES];
                
            } failure:^(id object) {
                
                isPushingController = NO;
                
            }];
            
        }

    } else if (sectionType == SearchSectionCompanies) {
        
        if (!isPushingController) {

            isPushingController = YES;
            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_COMPANY];
            NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
            NSDictionary *item = items[indexPath.row];
            
            [[DataManager sharedManager] companyDetail:item[@"id"] success:^(id object) {
                id returnObject = object;
                CompanyDetailViewController *controller = [CompanyDetailViewController new];
                controller.view.hidden = NO;
                [controller setInfo:returnObject];
                isPushingController = NO;
                [self.navigationController pushViewController:controller animated:YES];
                
            } failure:^(id object) {
                
                isPushingController = YES;
                
            }];

        }

    } else if (sectionType == SearchSectionContacts) {
        
        if (!isPushingController) {

            isPushingController = YES;
            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_CONTACT];
            NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
            NSDictionary *item = items[indexPath.row];
            
            ContactDetailViewController *controller = [ContactDetailViewController new];
            [controller setCompanyContactDetailsFromDictionary:item];
            isPushingController = NO;
            [self.navigationController pushViewController:controller animated:YES];

        }

    } else if (sectionType == SearchSectionSavedProject) {
        NSArray *items = collectionItems[SEARCH_RESULT_SAVED_PROJECT];
        searchMode = YES;
        showResult = YES;
        NSDictionary *filter = items[indexPath.row];
        [self search:filter[@"query"] filter:filter];
        
    } else if (sectionType == SearchSectionSavedCompany) {
       
        NSArray *items = collectionItems[SEARCH_RESULT_SAVED_COMPANY];
        searchMode = YES;
        showResult = YES;
        NSDictionary *filter = items[indexPath.row];
        [self search:filter[@"query"] filter:filter];
        
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    id returnObject = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SearchSectionCollectionViewCell *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[[SearchSectionCollectionViewCell class] description] forIndexPath:indexPath];
        
        [sectionHeader setTitle:kSections[indexPath.section]];
        
        returnObject = sectionHeader;
    } else {
        
        NSString *section = @"";
        
        SearchSection sectionType = (SearchSection)indexPath.section;
        
        NSMutableDictionary *result = nil;
        
        switch (sectionType) {
            case SearchSectionProjects: {
                section = NSLocalizedLanguage(@"SEARCH_RESULT_SEE_PROJECT");
                result = collectionItems[SEARCH_RESULT_PROJECT];
                break;
            }
                
            case SearchSectionCompanies: {
                section = NSLocalizedLanguage(@"SEARCH_RESULT_SEE_COMPANY");
                result = collectionItems[SEARCH_RESULT_COMPANY];
                break;
            }
                
            case SearchSectionContacts: {
                section = NSLocalizedLanguage(@"SEARCH_RESULT_SEE_CONTACT");
                result = collectionItems[SEARCH_RESULT_CONTACT];
                break;
            }
                
            default: {
                break;
            }
                
        }
 
        SeeAllCollectionViewCell *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[[SeeAllCollectionViewCell class] description] forIndexPath:indexPath];
        
        if (result != nil) {
 
            NSNumber *total = [DerivedNSManagedObject objectOrNil:result[@"total"]];
            NSInteger count = 0;
            if( total != nil) {
                count = total.integerValue;
            }

            [sectionFooter setTitle:[NSString stringWithFormat:section, (long)count]];
            
            sectionFooter.indexPath = indexPath;
            sectionFooter.seeAllCollectionViewCellDelegate = self;
        }
 
        returnObject = sectionFooter;
    }
    
    
    return returnObject;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
   
    SearchSection sectionType = (SearchSection)section;
    
    BOOL shouldHaveHeader = [self shouldShowSection:section];
    
    if (showResult) {
        shouldHaveHeader = NO;
    } else {
        
        if (searchMode) {
            shouldHaveHeader = [self sectionHasRecord:sectionType];
        }
    }
    
    return  CGSizeMake(collectionView.frame.size.width, kDeviceHeight * (shouldHaveHeader ?0.05:0));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    SearchSection sectionType = (SearchSection)section;

    CGSize footerSize = CGSizeZero;
    BOOL hasSection = (sectionType == SearchSectionProjects) | (sectionType == SearchSectionCompanies) | (sectionType == SearchSectionContacts);
    
    if (hasSection) {
        
        NSMutableDictionary *result = nil;
        
        if (sectionType == SearchSectionProjects) {
    
            result = collectionItems[SEARCH_RESULT_PROJECT];
        
        } else if(sectionType == SearchSectionCompanies) {
        
            result = collectionItems[SEARCH_RESULT_COMPANY];
        
        } else {
        
            result = collectionItems[SEARCH_RESULT_CONTACT];
            
        }
        
        NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
        
        if ((items.count>4) && (searchMode) && (!showResult)) {
            footerSize = CGSizeMake(collectionView.frame.size.width, kDeviceHeight * 0.03);
        }
        
    }
    
    return footerSize;
}

- (BOOL)shouldShowSection:(NSInteger)section {

    SearchSection searchSection = (SearchSection)section;
    BOOL shouldExpandHeader = NO;
    
    if (!searchMode) {
        
        shouldExpandHeader = (searchSection  == SearchSectionRecent) || (searchSection == SearchSectionSavedProject) || (searchSection == SearchSectionSavedCompany);
        
    } else {
        
        shouldExpandHeader = !((searchSection  == SearchSectionRecent) || (searchSection == SearchSectionSavedProject) || (searchSection == SearchSectionSavedCompany) || (searchSection == SearchSectionSuggested) || (searchSection == SearchSectionResult));
        
    }

    return shouldExpandHeader;
}

#pragma mark - Search 
- (void)getSearchFilter:(NSMutableDictionary*)destfilter searchFilter:(NSDictionary*)filter {
    
    NSDictionary *searchFilter = filter[@"filter"][@"searchFilter"];
    
    for(NSString *propertyName in searchFilter.allKeys) {
        
        NSDictionary *propertyNameDict = searchFilter[propertyName];
        
        for (NSString *subProperty in propertyNameDict.allKeys) {
            
            NSString *filterName = [NSString stringWithFormat:@"filter[searchFilter][%@][%@]", propertyName, subProperty];
            
            id subValue = propertyNameDict[subProperty];
            
            if ([subValue isKindOfClass:[NSArray class]]) {
                
                NSArray *filterValues = subValue;
                
                if (filterValues.count<=1) {
                    filterName = [filterName stringByAppendingString:@"[]"];
                }
                for (NSString *filterItem in filterValues) {
                    
                    [destfilter addEntriesFromDictionary:@{filterName:filterItem}];
                }
            } else if ([subValue class]==[NSString class]) {
                
                [destfilter addEntriesFromDictionary:@{filterName:subValue}];
                
            }
            
        }
        
    }

}

- (void)search:(NSString*)searchString filter:(NSDictionary*)filter{

    NSMutableDictionary *projectFilter = [@{@"q": searchString} mutableCopy];
   
    NSMutableDictionary *searchFilter = [NSMutableDictionary new];
    
    if (filter) {
        if ([filter[@"modelName"] isEqualToString:@"Project"]) {
            
            searchFilter = filter[@"filter"];
        }
        
    } else {
        
        [searchFilter addEntriesFromDictionary: @{@"include":@[@"primaryProjectType",@"secondaryProjectTypes",@"bids", @"projectStage"]}];
    }

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:searchFilter options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [projectFilter addEntriesFromDictionary:@{@"filter":jsonString}];

    [[DataManager sharedManager] projectSearch:projectFilter data:collectionItems success:^(id object) {
       
        [_collectionView reloadData];
        
    } failure:^(id object) {
        
    }];
    

    NSMutableDictionary *companyFilter = [@{@"q": searchString} mutableCopy];

    if (filter) {
        if ([filter[@"modelName"] isEqualToString:@"Company"]) {
            
            NSMutableDictionary *searchFilter = filter[@"filter"];
            
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:searchFilter options:0 error:&error];
            
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            [companyFilter addEntriesFromDictionary:@{@"filter":jsonString}];
     
        }
    }

    
    [[DataManager sharedManager] companySearch:companyFilter data:collectionItems success:^(id object) {
   
        [_collectionView reloadData];
    } failure:^(id object) {
        
    }];
    
    
    NSMutableDictionary *contactFilter = [@{@"q": searchString, @"filter":@"{\"include\":[\"company\"]}"} mutableCopy];
    
    [[DataManager sharedManager] contactSearch:contactFilter data:collectionItems success:^(id object) {

        [_collectionView reloadData];

    } failure:^(id object) {
        
    }];
    

}

#pragma mark - UITextField Delegate

- (void) textFieldText:(id)notification {

    if (_labeSearch.text.length>0) {
        
        if (!searchMode) {
            searchMode = YES;
            [_collectionView reloadData];
        }
        
        [[DataManager sharedManager] cancellAllRequests];
        [self search: _labeSearch.text filter:nil];
    } else {
        searchMode = NO;
        showResult = NO;
        
        [_collectionView reloadData];
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self
                           selector:@selector (textFieldText:)
                               name:UITextFieldTextDidChangeNotification
                             object:textField];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {


    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self clearText];
    return YES;

}

- (BOOL) sectionHasRecord:(SearchSection)sectionType {

    
    if (sectionType == SearchSectionProjects | sectionType == SearchSectionCompanies | sectionType == SearchSectionContacts) {
        
        NSMutableDictionary *result = nil;
        if (sectionType == SearchSectionProjects) {
            
            result = collectionItems[SEARCH_RESULT_PROJECT];
            
        } else if (sectionType == SearchSectionCompanies) {
            
            result = collectionItems[SEARCH_RESULT_COMPANY];
            
        } else {
            
            result = collectionItems[SEARCH_RESULT_CONTACT];
        }
        
        NSNumber *total = [DerivedNSManagedObject objectOrNil:result[@"total"]];
        NSInteger count = 0;
        if( total != nil) {
            count = total.integerValue;
        }
        
        return count>0;
    }
    
    return NO;

}

- (void)tappedSectionFooter:(id)object {

    SeeAllCollectionViewCell *footer = (SeeAllCollectionViewCell*)object;
    SearchSection sectionType = (SearchSection)footer.indexPath.section;
    BOOL shouldReload = NO;
    if (sectionType == SearchSectionProjects) {
        
        _resultIndex = [NSNumber numberWithInteger:0];
        shouldReload = YES;
    
    } else if (sectionType == SearchSectionCompanies) {
    
        _resultIndex = [NSNumber numberWithInteger:1];
        shouldReload = YES;
        
    } else if (sectionType == SearchSectionContacts) {
        
        _resultIndex = [NSNumber numberWithInteger:2];
        shouldReload = YES;
        
    }
    
    if (shouldReload) {

        showResult = YES;
        [_collectionView reloadData];
    
    }
}

- (void)currentTabChanged:(id)object {
    
    _resultIndex = (NSNumber*)object;

}

-(void) onEditing:(id)sender {
    
    
    if(![_labeSearch.text isEqualToString:@""]){
        [_clearButton setHidden:NO];
    }else{
        [_clearButton setHidden:YES];
    }
    
}

- (void)clearText {
    _labeSearch.text = @"";
    searchMode = NO;
    showResult = NO;
    [_collectionView reloadData];

    [_clearButton setHidden:YES];
}

#pragma mark - Save Sarche Delegate

- (void)tappedButtonSaveSearchesItem:(SaveSearchChangeItem)item {
    switch (item) {
        case SaveSearchChangeItemSave:{
            [[DataManager sharedManager] featureNotAvailable];
            break;
        }
        case SaveSearchChangeItemCancel:{
            [self showSaveSearches:NO];
            
            break;
        }
            
    }
}

- (void)showSaveSearches:(BOOL)show {
    
    CGFloat height;
    
    if (show) {
        height = kDeviceHeight * 0.128;
    } else {
        height = 0;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _constraintSaveSearchesHeight.constant = height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];

}

@end

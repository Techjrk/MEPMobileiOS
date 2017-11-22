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
#import "CustomActivityIndicatorView.h"
#import "ListItemCollectionViewCell.h"
#import "PopupViewController.h"
#import "NewTrackingListCollectionViewCell.h"
#import "TrackingListCellCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"
#import "ActionView.h"

#define SEACRCH_TEXTFIELD_TEXT_FONT                     fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)

#define SEACRCH_PLACEHOLDER_FONT                        fontNameWithSize(FONT_NAME_AWESOME, 14)
#define SEACRCH_PLACEHOLDER_COLOR                       RGB(255, 255, 255)
#define SEACRCH_PLACEHOLDER_TEXT                        [NSString stringWithFormat:@"%C", 0xf002]
#define LABEL_COLOR                                     RGB(34, 34, 34)

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


@interface SearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, SeeAllCollectionViewCellDelegate, SearchResultViewDelegate, SaveSearchChangeItemViewDelegate, SearchFilterViewControllerDelegate,RecentSearchCollectionViewCellDelegate, ActionViewDelegate, CustomCollectionViewDelegate, PopupViewControllerDelegate, TrackingListViewDelegate, NewTrackingListCollectionViewCellDelegate>{
    BOOL searchMode;
    BOOL showResult;
    NSMutableDictionary *collectionItems;
    BOOL isPushingController;
    UIButton *button;
    
    NSMutableDictionary *projectFilterGlobal;
    NSMutableDictionary *companyFilterGlobal;
    UIAlertAction *okAlrtAction;
    
    NSDictionary *saveSearchSelectedItem;
    BOOL isSuggestedListBeenTapped;
    BOOL fromSavedSearch;
    ListViewItemArray *stageItems;
    ListViewItemArray *jurisdictionItems;
    ListViewItemArray *projectTypeItems;
    NSIndexPath *currentItemIndexPath;
    NSNumber *currentProjectId;
    NSNumber *currentCompanyId;
    ProjectDetailPopupMode popupMode;
    NSArray *trackItemRecord;
    
}
@property (weak, nonatomic) IBOutlet SaveSearchChangeItemView *saveSearchesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSaveSearchesHeight;
@property (strong, nonatomic) NSNumber *resultIndex;
@property (weak, nonatomic) IBOutlet UITextField *labeSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak,nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet CustomActivityIndicatorView *customLoadingIndicator;


- (IBAction)tappedButtonBack:(id)sender;
@end

@implementation SearchViewController

#define kSections               @[NSLocalizedLanguage(@"SEARCH_SECTION_RECENT"),NSLocalizedLanguage(@"SEARCH_SECTION_SAVED_PROJECT"),NSLocalizedLanguage(@"SEARCH_SECTION_SAVED_COMPANY"),NSLocalizedLanguage(@"SEARCH_SECTION_SUGGESTED"),NSLocalizedLanguage(@"SEARCH_SECTION_PROJECTS"),NSLocalizedLanguage(@"SEARCH_SECTION_COMPANIES"),NSLocalizedLanguage(@"SEARCH_SECTION_CONTACTS"), NSLocalizedLanguage(@"SEARCH_SECTION_RESULT")]

#define kCellIdentifier(section)         [NSString stringWithFormat:@"kCellIdentifier_%li",(long)section]

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fromSavedSearch = NO;
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

    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipe:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipe:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView addGestureRecognizer:swipeGestureLeft];
    [self.collectionView addGestureRecognizer:swipeGestureRight];

    searchMode = NO;
    showResult = NO;
    
    _resultIndex = [NSNumber numberWithInteger:0];
    [self.customLoadingIndicator startAnimating];
    [[DataManager sharedManager] savedSearches:collectionItems success:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        [_collectionView reloadData];
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];
    
}

- (void)userSwipe:(UISwipeGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (indexPath != nil) {
        UICollectionViewCell *cell = (UICollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        if( [cell respondsToSelector:@selector(actionView)]){
            ActionView * actionView = [cell performSelector:@selector(actionView)];
            [actionView swipeExpand:sender.direction];
        }

    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.customLoadingIndicator stopAnimating];
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

- (NSDictionary *)removedUpdatedBiddingValueZeroForSearchFilter:(id)info {
    NSMutableDictionary *tempDic = [info mutableCopy];

    /*
    BOOL biddingValZero  = [DerivedNSManagedObject objectOrNil:tempDic[@"biddingWithin"][@"valZero"]];
    BOOL updatedWithinValZero  = [DerivedNSManagedObject objectOrNil:tempDic[@"updatedWithin"][@"valZero"]];
    
    if (biddingValZero) {
        [tempDic removeObjectForKey:@"biddingWithin"];
    }
    
    if (updatedWithinValZero) {
        [tempDic removeObjectForKey:@"updatedWithin"];
    }
    */
    NSNumber *biddingValZero  = [DerivedNSManagedObject objectOrNil:tempDic[@"biddingInNext"]];
    NSNumber *updatedWithinValZero  = [DerivedNSManagedObject objectOrNil:tempDic[@"updatedInLast"]];
    
    if (biddingValZero.integerValue ==0) {
        [tempDic removeObjectForKey:@"biddingInNext"];
    }
    
    if (updatedWithinValZero.integerValue == 0) {
        [tempDic removeObjectForKey:@"updatedInLast"];
    }

    
    return [tempDic copy];
}

#pragma mark - Navigation Methods

- (void)tappedButtonFilter:(id)sender {
    
    SearchFilterViewController *controller = [SearchFilterViewController new];
    controller.searchFilterViewControllerDelegate = self;
    if (stageItems == nil) {
        stageItems = [ListViewItemArray new];
    }
    
    controller.listItemsProjectStageId = stageItems;
    
    if (jurisdictionItems == nil) {
        jurisdictionItems = [ListViewItemArray new];
    }
    
    controller.listItemsJurisdictions = jurisdictionItems;
    
    if (projectTypeItems == nil) {
        projectTypeItems = [ListViewItemArray new];
    }
    
    controller.listItemsProjectTypeId = projectTypeItems;

    controller.projectFilterDictionary = [projectFilterGlobal mutableCopy];
    controller.companytFilterDictionary = [companyFilterGlobal mutableCopy];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tappedSearchFilterViewControllerApply:(NSDictionary *)projectFilter companyFilter:(NSDictionary *)companyFilter {
    
    searchMode = YES;
    if (projectFilterGlobal == nil) {
        projectFilterGlobal = [NSMutableDictionary new];
    }
    
    for (NSString *key in projectFilter.allKeys) {
        projectFilterGlobal[key] = projectFilter[key];
    }
    
    if (companyFilterGlobal == nil) {
        companyFilterGlobal = [NSMutableDictionary new];
    }
    
    for (NSString *key in companyFilter.allKeys) {
        companyFilterGlobal[key] = companyFilter[key];
    }
    
    NSMutableDictionary *project = [projectFilter mutableCopy];
    project[@"modelName"] = @"Project";
    NSMutableDictionary *company = [companyFilter mutableCopy];
    company[@"modelName"] = @"Company";
    
    [self searchForProject:_labeSearch.text filter:project];
    [self searchForCompany:_labeSearch.text filter:company];
    
    if (isSuggestedListBeenTapped) {
        if (projectFilterGlobal.count > 0) {
            [self showSaveSearches:YES];
        }
        
        if (companyFilterGlobal.count > 0) {
            [self showSaveSearches:YES];
        }
    }
    
}

- (IBAction)tappedButtonBack:(id)sender {
    [self showSaveSearches:NO];
    saveSearchSelectedItem = nil;
    isSuggestedListBeenTapped = NO;
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
            cellItem.recentSearchCollectionViewCellDelegate = self;
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
            [cellItem setCollectionItems:collectionItems tab:_resultIndex fromSavedSearch:fromSavedSearch];
            [cellItem reloadData];

            break;
        }
            
        case SearchSectionProjects: {
            
            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
            NSArray *items = result[@"results"];
            
            SearchProjectCollectionViewCell *cellItem = (SearchProjectCollectionViewCell*)cell;
            NSMutableDictionary *project = items[indexPath.row];
            [cellItem setInfo:project];
            [cellItem.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
            [cellItem.actionView itemHidden:NO];
            if (project[@"IS_HIDDEN"]) {
                [cellItem.actionView itemHidden:[project[@"IS_HIDDEN"] boolValue]];
            }
            
            [cellItem.actionView setUndoLabelTextColor: LABEL_COLOR];
            cellItem.actionViewDelegate = self;
            
            break;
        }
            
        case SearchSectionCompanies: {

            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_COMPANY];
            NSArray *items = result[@"results"];
            NSMutableDictionary *company = items[indexPath.row];
            
            SearchCompanyCollectionViewCell *cellItem = (SearchCompanyCollectionViewCell*)cell;
            [cellItem setInfo:company];
            [cellItem.actionView disableHide];
            [cellItem.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
            [cellItem.actionView itemHidden:NO];
            if (company[@"IS_HIDDEN"]) {
                [cellItem.actionView itemHidden:[company[@"IS_HIDDEN"] boolValue]];
            }
            
            [cellItem.actionView setUndoLabelTextColor: LABEL_COLOR];
            cellItem.actionViewDelegate = self;

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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    SearchSection sectionType = (SearchSection)indexPath.section;
 
    return sectionType != SearchSectionResult;
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
    [self showSaveSearches:NO];
    
    if (sectionType == SearchSectionSuggested) {
        isSuggestedListBeenTapped = YES;
        _resultIndex = [NSNumber numberWithInteger:indexPath.row];
        showResult = YES;
        [_collectionView reloadData];

    } else if (sectionType == SearchSectionProjects) {
      
        if (!isPushingController) {
            
            isPushingController = YES;
            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
            NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
            NSDictionary *item = items[indexPath.row];
            
            [self.customLoadingIndicator startAnimating];
            [[DataManager sharedManager] projectDetail:item[@"id"] success:^(id object) {
                [self.customLoadingIndicator stopAnimating];
                ProjectDetailViewController *detail = [ProjectDetailViewController new];
                detail.view.hidden = NO;
                [detail detailsFromProject:object];
                
                isPushingController = NO;
                [self.navigationController pushViewController:detail animated:YES];
                
            } failure:^(id object) {
                [self.customLoadingIndicator stopAnimating];
                isPushingController = NO;
                
            }];
            
        }

    } else if (sectionType == SearchSectionCompanies) {
        
        if (!isPushingController) {

            isPushingController = YES;
            NSMutableDictionary *result = collectionItems[SEARCH_RESULT_COMPANY];
            NSArray *items = result[@"results"] != nil?result[@"results"]:[NSArray new];
            NSDictionary *item = items[indexPath.row];
            [self.customLoadingIndicator startAnimating];
            [[DataManager sharedManager] companyDetail:item[@"id"] success:^(id object) {
                [self.customLoadingIndicator stopAnimating];
                id returnObject = object;
                CompanyDetailViewController *controller = [CompanyDetailViewController new];
                controller.view.hidden = NO;
                [controller setInfo:returnObject];
                isPushingController = NO;
                [self.navigationController pushViewController:controller animated:YES];
                
            } failure:^(id object) {
                [self.customLoadingIndicator stopAnimating];
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
        isSuggestedListBeenTapped = NO;
        NSArray *items = collectionItems[SEARCH_RESULT_SAVED_PROJECT];
        searchMode = YES;
        showResult = YES;
        NSMutableDictionary *filter = [items[indexPath.row] mutableCopy];
        saveSearchSelectedItem = @{@"ProjectItem":filter};
        
        NSString *queryString = [DerivedNSManagedObject objectOrNil:filter[@"query"]];
        if (queryString == nil) {
            queryString = @"";
        }
        
        _labeSearch.text = queryString;
        [[GAManager sharedManager] trackSaveSearchBar];
        [self searchForProject:queryString filter:filter];
        [self searchForCompany:queryString filter:filter];
        [self searchForContact:queryString filter:filter];
        fromSavedSearch = YES;
        _resultIndex = [NSNumber numberWithInt:0];
        
    } else if (sectionType == SearchSectionSavedCompany) {
        isSuggestedListBeenTapped = NO;
        NSArray *items = [collectionItems[SEARCH_RESULT_SAVED_COMPANY] mutableCopy];
        searchMode = YES;
        showResult = YES;
        NSMutableDictionary *filter = items[indexPath.row];
        saveSearchSelectedItem = @{@"CompanyItem":filter};
        
        NSString *queryString = [DerivedNSManagedObject objectOrNil:filter[@"query"]];
        if (queryString == nil) {
            queryString = @"";
        }

        _labeSearch.text = queryString;
        [[GAManager sharedManager] trackSaveSearchBar];
        [self searchForProject:queryString filter:filter];
        [self searchForCompany:queryString filter:filter];
        [self searchForContact:queryString filter:filter];
        fromSavedSearch = YES;
        _resultIndex = [NSNumber numberWithInt:1];

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

- (void)searchForProject:(NSString*)searchString filter:(NSDictionary*)filter{

    NSMutableDictionary *projectFilter = [@{@"q": searchString} mutableCopy];
   
    NSMutableDictionary *_filter = [NSMutableDictionary new];
    [_filter addEntriesFromDictionary: @{@"include":@[@"userNotes",@"images",@"primaryProjectType",@"secondaryProjectTypes",@"bids", @"projectStage"]}];
 
    if ([filter[@"modelName"] isEqualToString:@"Project"]){
        if (filter) {
            NSMutableDictionary *searchFilter = filter[@"filter"][@"searchFilter"];
            _filter[@"searchFilter"] = searchFilter;
            
        }
    } else {
        _filter[@"searchFilter"] = @"{}";
        
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:_filter options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    projectFilter[@"filter"] = jsonString;

    [self.customLoadingIndicator startAnimating];
    [[DataManager sharedManager] projectSearch:projectFilter data:collectionItems success:^(id object) {
       [self.customLoadingIndicator stopAnimating];
        [_collectionView reloadData];
        
    } failure:^(id object) {
       [self.customLoadingIndicator stopAnimating];
    }];
    
}

- (void)searchForCompany:(NSString*)searchString filter:(NSDictionary*)filter{

    NSMutableDictionary *companyFilter = [@{@"q": searchString} mutableCopy];
    
    if ([filter[@"modelName"] isEqualToString:@"Company"]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:filter[@"filter"] options:0 error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        companyFilter[@"filter"] =jsonString;
    } else {
        companyFilter[@"filter"] = @"{\"searchFilter\":{}}";
    }

    [self.customLoadingIndicator startAnimating];
    [[DataManager sharedManager] companySearch:companyFilter data:collectionItems success:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        [_collectionView reloadData];
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];
    
}

- (void)searchForContact:(NSString*)searchString filter:(NSDictionary*)filter{

    NSString *defaultFilter = @"{\"include\":[\"company\"]}";
    
    if (searchString.length==0) {
        defaultFilter = @"{\"include\":[\"company\"],\"searchFilter\":{}}";
    }

    NSMutableDictionary *contactFilter = [@{@"q": searchString, @"filter":defaultFilter} mutableCopy];
    [self.customLoadingIndicator startAnimating];
    [[DataManager sharedManager] contactSearch:contactFilter data:collectionItems success:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        [_collectionView reloadData];

    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];

}

#pragma mark - SaveSearches Request

- (void)saveSearchForProject:(NSString*)searchString filter:(NSDictionary*)filter title:(NSString *)titleString{
    
    NSDictionary *dict;
    NSString *title;
    if (isSuggestedListBeenTapped) {
        title = titleString;
    } else {
        
        dict = [DerivedNSManagedObject objectOrNil:saveSearchSelectedItem[@"ProjectItem"]];
        title = showResult?[DerivedNSManagedObject objectOrNil:dict[@"title"]]:titleString;
        
    }
    
    NSMutableDictionary *projectFilter = [@{@"query": searchString,@"title":title,@"modelName":@"Project"} mutableCopy];
    
    NSMutableDictionary *_filter = [NSMutableDictionary new];
    if (filter) {
        if ([filter[@"modelName"] isEqualToString:@"Project"]) {
            
            NSMutableDictionary *searchFilter = filter[@"filter"][@"searchFilter"];
            _filter[@"searchFilter"] = searchFilter;
            
        } else {
            // _filter[@"searchFilter"] = @"{}";
        }
        
    } else {
        //_filter[@"searchFilter"] = @"{}";
    }
    
    isSuggestedListBeenTapped?nil:showResult?[projectFilter setValue:dict[@"id"] forKey:@"id"]:nil;

    projectFilter[@"filter"] = _filter;
    [self.customLoadingIndicator startAnimating];
    [[DataManager sharedManager] projectSaveSearch:projectFilter data:collectionItems updateOldData:isSuggestedListBeenTapped?NO:showResult success:^(id object) {
        [[DataManager sharedManager] savedSearches:collectionItems success:^(id object) {
            [self.customLoadingIndicator stopAnimating];
            [_collectionView reloadData];
        } failure:^(id object) {
            [self.customLoadingIndicator stopAnimating];
        }];
        
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];
    
}

- (void)saveSearchForCompany:(NSString*)searchString filter:(NSDictionary*)filter title:(NSString *)titleString{
    
    
    NSDictionary *dict;
    NSString *title;
    if (isSuggestedListBeenTapped) {
        title = titleString;
    } else {
        
        dict = [DerivedNSManagedObject objectOrNil:saveSearchSelectedItem[@"CompanyItem"]];
        title = showResult?[DerivedNSManagedObject objectOrNil:dict[@"title"]]:titleString;
        
    }

    NSMutableDictionary *companyFilter = [@{@"query": searchString,@"title":title,@"modelName":@"Company"} mutableCopy];
    NSMutableDictionary *_filter = [NSMutableDictionary new];
    
    if (filter) {
        if ([filter[@"modelName"] isEqualToString:@"Company"]) {
            
            NSMutableDictionary *searchFilter = filter[@"filter"][@"searchFilter"];
            _filter[@"searchFilter"] = searchFilter;
            
        } else {
            //_filter[@"searchFilter"] = @"{}";
        }
    } else {
        //_filter[@"searchFilter"] = @"{}";
    }
    
    isSuggestedListBeenTapped?nil:showResult?[companyFilter setValue:dict[@"id"] forKey:@"id"]:nil;
    [companyFilter addEntriesFromDictionary:@{@"filter":_filter}];
    [self.customLoadingIndicator startAnimating];
    [[DataManager sharedManager] companySaveSearch:companyFilter data:collectionItems updateOldData:isSuggestedListBeenTapped?NO:showResult success:^(id object) {
        
        [[DataManager sharedManager] savedSearches:collectionItems success:^(id object) {
            [self.customLoadingIndicator stopAnimating];
            [_collectionView reloadData];
        } failure:^(id object) {
            [self.customLoadingIndicator stopAnimating];
            
        }];

    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];
    
}

#pragma mark - UITextField Delegate

- (void) textFieldText:(id)notification {

    if (_labeSearch.text.length>0) {
        if (!searchMode) {
            searchMode = YES;
            [[GAManager sharedManager] trackSearchBar];
            [_collectionView reloadData];
        }
        
        [[DataManager sharedManager] cancellAllRequests];
        
        //fromSavedSearch = NO;
        [self searchForProject:_labeSearch.text filter:nil];
        [self searchForCompany:_labeSearch.text filter:nil];
        [self searchForContact:_labeSearch.text filter:nil];

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
        fromSavedSearch = NO;
    }
    
}

- (void)clearText {
    
    _labeSearch.text = @"";
    searchMode = NO;
    showResult = NO;
    fromSavedSearch = NO;
    [_collectionView reloadData];
    [_clearButton setHidden:YES];
   
}

#pragma mark - Save Searches Delegate

- (void)tappedButtonSaveSearchesItem:(SaveSearchChangeItem)item {
    switch (item) {
        case SaveSearchChangeItemSave:{
        
            isSuggestedListBeenTapped?[self promptAlertWithTextField:NSLocalizedLanguage(@"SEARCH_PROMPT_TITLE")]:showResult?[self doSaveSearches:nil]:[self promptAlertWithTextField:NSLocalizedLanguage(@"SEARCH_PROMPT_TITLE")];
          /*
            if (showResult) {
                [self doSaveSearches:nil];
            } else {
                [self promptAlertWithTextField:NSLocalizedLanguage(@"SEARCH_PROMPT_TITLE")];
                
            }
           */
        
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

- (void)doSaveSearches:(NSString *)title {
    
        if (projectFilterGlobal.count > 0) {

            NSMutableDictionary *project = [projectFilterGlobal mutableCopy];
            project[@"modelName"] = @"Project";

            [self saveSearchForProject:_labeSearch.text filter:projectFilterGlobal.count>0? project:nil title:title];
            [self showSaveSearches:YES];
        }
        
        if (companyFilterGlobal.count > 0) {
            
            NSMutableDictionary *company = [companyFilterGlobal mutableCopy];
            company[@"modelName"] = @"Company";

            [self saveSearchForCompany:_labeSearch.text filter:companyFilterGlobal.count>0? company:nil title:title];
            [self showSaveSearches:YES];
        }
    
    [self showSaveSearches:NO];

}

#pragma mark - MISC Method

- (NSString *)stripSpaces:(NSString *)textFielsString {
    
    return [textFielsString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)promptAlertWithTextField:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedLanguage(@"ALERT_TEXTFIELD_PLACEHOLDER");
        [textField addTarget:self action:@selector(alertTextFielOnEdit:) forControlEvents:UIControlEventAllEvents];
    
    }];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_CLOSE")
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action) {
                                                            
                                                        }];
    [alert addAction:closeAction];
    
    
    okAlrtAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
     
        [self doSaveSearches:[[alert textFields][0] text]];

    }];
    
    [okAlrtAction setEnabled:NO];
    [alert addAction:okAlrtAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertTextFielOnEdit:(UITextField *)textField {
    
    NSString *stringStripSpace = [self stripSpaces:textField.text];

    if (stringStripSpace.length > 0) {
        
        [okAlrtAction setEnabled:YES];
        
    } else {
        
        [okAlrtAction setEnabled:NO];
        
    }
    
}

#pragma mark - RecentSearchCollectionViewCellDelegate

- (void)tappedRecentSearchView {
    [self.customLoadingIndicator startAnimating];
}

- (void)endRequestRecentSearchView {
    [self.customLoadingIndicator stopAnimating];
}

#pragma mark - Project Tracking List

- (void)displayProjectTrackingList:(id)sender {
    
    NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
    NSArray *items = result[@"results"];
    
    NSMutableDictionary *project = items[currentItemIndexPath.row];
    currentProjectId = project[@"id"];
    
    popupMode = ProjectDetailPopupModeTrack;
    
    [[DataManager sharedManager] projectAvailableTrackingList:currentProjectId success:^(id object) {
        
        trackItemRecord = object;
        
        if (trackItemRecord.count>0) {
            PopupViewController *controller = [PopupViewController new];
            
            SearchProjectCollectionViewCell *cell = (SearchProjectCollectionViewCell*)sender;
            
            CGRect rect = [controller getViewPositionFromViewController:[cell.actionView trackButton] controller:self];
            controller.popupRect = rect;
            controller.popupWidth = 0.98;
            controller.isGreyedBackground = YES;
            controller.customCollectionViewDelegate = self;
            controller.popupViewControllerDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:NO completion:nil];
        } else {
            
            [self PopupViewControllerDismissed];
            
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"NO_TRACKING_LIST")];
        }
        
    } failure:^(id object) {
        
    }];
}

- (void)displayCompanyTrackingList:(id)sender {
    NSMutableDictionary *result = collectionItems[SEARCH_RESULT_COMPANY];
    NSArray *items = result[@"results"];
    
    NSMutableDictionary *company = items[currentItemIndexPath.row];
    currentCompanyId = company[@"id"];

    popupMode = ProjectDetailPopupModeTrack;
    [[DataManager sharedManager] companyAvailableTrackingList:currentCompanyId success:^(id object) {
        
        trackItemRecord = object;
        PopupViewController *controller = [PopupViewController new];
        SearchCompanyCollectionViewCell *cell = (SearchCompanyCollectionViewCell*)sender;
        
        CGRect rect = [controller getViewPositionFromViewController:[cell.actionView trackButton] controller:self];
        controller.popupRect = rect;
        controller.popupWidth = 0.98;
        controller.isGreyedBackground = YES;
        controller.customCollectionViewDelegate = self;
        controller.popupViewControllerDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:NO completion:nil];
        
    } failure:^(id object) {
        
    }];

}

#pragma mark - ActionView

- (NSIndexPath*)indexPathForSender:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UICollectionViewCell*)sender];
    return indexPath;
}

- (void)didSelectItem:(id)sender {
    NSIndexPath *indexPath = [self indexPathForSender:sender];
    //[self.associatedProjectDelegate tappedAssociatedProject:collectionItems[indexPath.row]];
}

- (void)didTrackItem:(id)sender {
    currentItemIndexPath = [self indexPathForSender:sender];
    
    SearchSection sectionType = (SearchSection)currentItemIndexPath.section;
    
    switch (sectionType) {
        case SearchSectionProjects: {
            [self displayProjectTrackingList:sender];
            break;
        }
        case SearchSectionCompanies: {
            [self displayCompanyTrackingList:sender];
            break;
        }
        default:
            break;
    }
}

- (void)shareProject:(id)sender {

    NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
    NSArray *items = result[@"results"];
    
    SearchProjectCollectionViewCell *cell = (SearchProjectCollectionViewCell*)sender;
    currentItemIndexPath = [self indexPathForSender:sender];
    NSDictionary *project = items[currentItemIndexPath.row];
    currentProjectId = project[@"id"];
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:[cell.actionView shareButton] controller:self];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:NO completion:nil];

}

- (void)shareCompany:(id)sender {
    NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
    NSArray *items = result[@"results"];
    
    SearchCompanyCollectionViewCell *cell = (SearchCompanyCollectionViewCell*)sender;
    currentItemIndexPath = [self indexPathForSender:sender];
    NSDictionary *company = items[currentItemIndexPath.row];
    currentProjectId = company[@"id"];
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:[cell.actionView shareButton] controller:self];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:NO completion:nil];

}

- (void)didShareItem:(id)sender {
    currentItemIndexPath = [self indexPathForSender:sender];
    
    SearchSection sectionType = (SearchSection)currentItemIndexPath.section;
    
    switch (sectionType) {
        case SearchSectionProjects: {
            [self shareProject:sender];
            break;
        }
        case SearchSectionCompanies: {
            [self shareCompany:sender];
            break;
        }
        default:
            break;
    }
}

- (void)didHideProject:(id)sender {
    NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
    NSMutableArray *items = result[@"results"];
    
    currentItemIndexPath = [self indexPathForSender:sender];
    NSMutableDictionary *project = [items[currentItemIndexPath.row] mutableCopy];
    currentProjectId = project[@"id"];
    
    [[DataManager sharedManager] hideProject:currentProjectId success:^(id object) {
        project[@"IS_HIDDEN"] = @YES;
        items[currentItemIndexPath.row] = project;
        [[DataManager sharedManager] saveContext];
        [self.collectionView reloadData];
    } failure:^(id object) {
    }];
}

- (void)didHideItem:(id)sender {
    currentItemIndexPath = [self indexPathForSender:sender];
    SearchSection sectionType = (SearchSection)currentItemIndexPath.section;
    
    switch (sectionType) {
        case SearchSectionProjects: {
            [self didHideProject:sender];
            break;
        }
        case SearchSectionCompanies: {
            break;
        }
        default:
            break;
    }

}

- (void)didExpand:(id)sender {
    NSArray *cells = [self.collectionView visibleCells];
    
    for (UICollectionViewCell *cell in cells) {
        if (![cell isEqual:sender]) {
            
            if( [cell respondsToSelector:@selector(actionView)]){
                ActionView * actionView = [cell performSelector:@selector(actionView)];
                [actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
            }
        }
    }
    
}

- (void)unhideProject:(id)sender {
    NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
    NSArray *items = result[@"results"];
    currentItemIndexPath = [self indexPathForSender:sender];
    NSMutableDictionary *project = items[currentItemIndexPath.row];
    currentProjectId = project[@"id"];
    
    [[DataManager sharedManager] unhideProject:currentProjectId success:^(id object) {
        project[@"IS_HIDDEN"] = @NO;
        [[DataManager sharedManager] saveContext];
        [self.collectionView reloadData];
        
    } failure:^(id object) {
    }];
}

- (void)undoHide:(id)sender {
    currentItemIndexPath = [self indexPathForSender:sender];
    SearchSection sectionType = (SearchSection)currentItemIndexPath.section;
    
    switch (sectionType) {
        case SearchSectionProjects: {
            [self unhideProject:sender];
            break;
        }
        case SearchSectionCompanies: {
            break;
        }
        default:
            break;
    }
}

#pragma mark - CustomCollectionView Delegate
    
- (void)collectionViewItemClassRegister:(id)customCollectionView {
    
    CustomCollectionView *collectionView = (CustomCollectionView*)customCollectionView;
    switch (popupMode) {
            
        case ProjectDetailPopupModeTrack: {
            [collectionView registerCollectionItemClass:[NewTrackingListCollectionViewCell class]];
            [collectionView registerCollectionItemClass:[TrackingListCellCollectionViewCell class]];
            break;
        }
            
        case ProjectDetailPopupModeShare: {
            
            [collectionView registerCollectionItemClass:[ShareItemCollectionViewCell class]];
            break;
        }
    }
}

- (UICollectionViewCell*)collectionViewItemClassDeque:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView {
    
    switch (popupMode) {
            
        case ProjectDetailPopupModeTrack: {
            
            if (indexPath.row == 0) {
                return [collectionView dequeueReusableCellWithReuseIdentifier:[[TrackingListCellCollectionViewCell class] description]forIndexPath:indexPath];
            } else {
                return [collectionView dequeueReusableCellWithReuseIdentifier:[[NewTrackingListCollectionViewCell class] description]forIndexPath:indexPath];
            }
            break;
        }
            
        case ProjectDetailPopupModeShare :{
            return [collectionView dequeueReusableCellWithReuseIdentifier:[[ShareItemCollectionViewCell class] description]forIndexPath:indexPath];
            break;
        };
            
    }
    
    return nil;
}

- (NSInteger)collectionViewItemCount {
    
    return popupMode == ProjectDetailPopupModeTrack?2:2;
    
}

- (NSInteger)collectionViewSectionCount {
    return 1;
}

- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath*)indexPath cargo:(id)cargo {
    
    switch (popupMode) {
            
        case ProjectDetailPopupModeTrack: {
            CGFloat defaultHeight = kDeviceHeight * 0.08;
            if (indexPath.row == 0) {
                
                CGFloat cellHeight = kDeviceHeight * 0.06;
                defaultHeight = defaultHeight+ ((trackItemRecord.count<4?trackItemRecord.count:4.5)*cellHeight);
            }
            
            return CGSizeMake(kDeviceWidth * 0.98, defaultHeight);
            break;
        }
            
        case ProjectDetailPopupModeShare: {
            return CGSizeMake(kDeviceWidth * 0.98, kDeviceHeight * 0.075);
            break;
        }
            
    }
    
    return CGSizeZero;
}

- (void)PopupViewControllerDismissed {
    UICollectionViewCell *cell = (UICollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentItemIndexPath];
    if(cell){
        if( [cell respondsToSelector:@selector(actionView)]){
            ActionView * actionView = [cell performSelector:@selector(actionView)];
            [actionView resetStatus];
        }
    }
}

- (void)didSelectShareProject:(NSIndexPath*)indexPath {
    NSMutableDictionary *result = collectionItems[SEARCH_RESULT_PROJECT];
    NSArray *items = result[@"results"];
    
    NSDictionary *dict = items[currentItemIndexPath.row];
    NSNumber *recordId = dict[@"id"];
    
    if (popupMode == ProjectDetailPopupModeShare) {
        NSString *url = [kHost stringByAppendingString:[NSString stringWithFormat:kUrlProjectDetailShare, (long)recordId.integerValue]];
        
        NSString *dodgeNumber = dict[@"dodgeNumber"];
        
        if (indexPath.row == 0) {
            NSString *html = [NSString stringWithFormat:@"<HTML><BODY>DODGE NUMBER :<BR>%@ <BR>WEB LINK : <BR>%@ </BODY></HTML>", dodgeNumber, url];
            [[DataManager sharedManager] sendEmail:html];
            
        } else {
            
            NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"COPY_TO_CLIPBOARD_PROJECT"), dodgeNumber];
            [[DataManager sharedManager] copyTextToPasteBoard:url withMessage:message];
            
        }
    }
}

- (void)didSelectShareCompany:(NSIndexPath*)indexPath {
    NSMutableDictionary *result = collectionItems[SEARCH_RESULT_COMPANY];
    NSArray *items = result[@"results"];
    
    NSMutableDictionary *company = items[currentItemIndexPath.row];
    currentCompanyId = company[@"id"];
    
    NSString *url = [kHost stringByAppendingString:[NSString stringWithFormat:kUrlCompanyDetailShare, (long)currentCompanyId.integerValue]];
    
    if (indexPath.row == 0) {
        
        NSString *html = [NSString stringWithFormat:@"<HTML><BODY>COMPANY NAME :<BR>%@ <BR>WEB LINK : <BR>%@ </BODY></HTML>", company[@"name"], url];
        [[DataManager sharedManager] sendEmail:html];
        
    } else {
        NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"COPY_TO_CLIPBOARD_COMPANY"), company[@"name"]];
        [[DataManager sharedManager] copyTextToPasteBoard:url withMessage:message];
        
    }

}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    SearchSection sectionType = (SearchSection)currentItemIndexPath.section;
    
    switch (sectionType) {
        case SearchSectionProjects: {
            [self didSelectShareProject:indexPath];
            break;
        }
        case SearchSectionCompanies: {
            [self didSelectShareCompany:indexPath];
            break;
        }
        default:
            break;
    }

}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    
    switch (popupMode) {
            
        case ProjectDetailPopupModeTrack: {
            
            if (indexPath.row == 0) {
                TrackingListCellCollectionViewCell *cellItem = (TrackingListCellCollectionViewCell*)cell;
                cellItem.headerDisabled = YES;
                cellItem.trackingListViewDelegate = self;
                [cellItem setInfo:trackItemRecord withTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_TITLE_TRACKING_LABEL_TEXT")];
            } else {
                NewTrackingListCollectionViewCell *cellItem = (NewTrackingListCollectionViewCell*)cell;
                cellItem.labelTitle.text = NSLocalizedLanguage(@"NTL_TEXT");
                [cellItem.labelTitle sizeToFit];
                cellItem.newtrackingListCollectionViewCellDelegate = self;
            }
            
            break;
        }
            
        case ProjectDetailPopupModeShare: {
            
            ShareItemCollectionViewCell *cellItem = (ShareItemCollectionViewCell*)cell;
            [cellItem setShareItem:indexPath.row == 0?ShareItemEmail:ShareItemLink];
            
            break;
        }
            
    }
    
}

- (void)trackProjectItem:(NSIndexPath*)indexPath {
    NSDictionary *dict = trackItemRecord[indexPath.row];
    [self.customLoadingIndicator startAnimating];
    
    [[DataManager sharedManager] projectAddTrackingList:dict[@"id"] recordId:currentProjectId success:^(id object) {
        [[DataManager sharedManager] dismissPopup];
        [self PopupViewControllerDismissed];
        [self.customLoadingIndicator stopAnimating];
        
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
        
    }];
}

- (void)trackCompanyItem:(NSIndexPath*)indexPath {
    NSDictionary *dict = trackItemRecord[indexPath.row];
    [self.customLoadingIndicator startAnimating];

    [[DataManager sharedManager] companyAddTrackingList:dict[@"id"] recordId:currentCompanyId success:^(id object) {
        [[DataManager sharedManager] dismissPopup];
        [self PopupViewControllerDismissed];
        [self.customLoadingIndicator stopAnimating];
    } failure:^(id object) {
        [self.customLoadingIndicator stopAnimating];
    }];

}

- (void)tappedTrackingListItem:(id)object view:(UIView *)view {
    SearchSection sectionType = (SearchSection)currentItemIndexPath.section;
    
    switch (sectionType) {
        case SearchSectionProjects: {
            [self trackProjectItem:object];
            break;
        }
        case SearchSectionCompanies: {
            [self trackCompanyItem:object];
            break;
        }
        default:
            break;
    }

}

#pragma mark - Project List Delegate and Method

-(void)tappedDismissedProjectTrackList{
    [self PopupViewControllerDismissed];
}

#pragma mark - NewTrackingListCollectionViewCellDelegate

- (void)createNewProjectTrackingList:(UITextField*)alertTextField {
    [[DataManager sharedManager] createProjectTrackingList:currentProjectId trackingName:alertTextField.text success:^(id object) {
        [self PopupViewControllerDismissed];
        
        NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"NTL_ADDED"), alertTextField.text];
        
        [[DataManager sharedManager] promptMessage:message];
        
        UICollectionViewCell *cell = (UICollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentItemIndexPath];
        if(cell){
            if([cell respondsToSelector:@selector(resetStatus)]){
                [cell performSelector:@selector(resetStatus)];
            }
        }
        
        [self.customLoadingIndicator stopAnimating];
        
    } failure:^(id object) {
        [self PopupViewControllerDismissed];
        [self.customLoadingIndicator stopAnimating];
    }];
}

- (void)createNewCompanyTrackingList:(UITextField*)alertTextField {
    [[DataManager sharedManager] createCompanyTrackingList:currentCompanyId trackingName:alertTextField.text success:^(id object) {
        [self PopupViewControllerDismissed];
        
        NSString *message = [NSString stringWithFormat:NSLocalizedLanguage(@"NTL_COMPANYADDED"), alertTextField.text];
        
        [[DataManager sharedManager] promptMessage:message];
        
        UICollectionViewCell *cell = (UICollectionViewCell*)[self.collectionView cellForItemAtIndexPath:currentItemIndexPath];
        if(cell){
            if([cell respondsToSelector:@selector(resetStatus)]){
                [cell performSelector:@selector(resetStatus)];
            }
        }
        
        [self.customLoadingIndicator stopAnimating];
        
    } failure:^(id object) {
        [self PopupViewControllerDismissed];
        [self.customLoadingIndicator stopAnimating];
    }];
}

- (void)getNewTrackingList {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedLanguage(@"NTL_TRACKINGNAME") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"";
        textField.placeholder = NSLocalizedLanguage(@"NTL_NEWNAME");
    }];
    
    UIAlertAction *actionAccept = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"PROJECT_FILTER_LOCATION_ACCEPT") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        for (int i=0; i<alert.textFields.count; i++) {
            UITextField *alertTextField = alert.textFields[i];
            
            if (alertTextField) {
                if (alertTextField.text.length>0) {
                    [self.customLoadingIndicator startAnimating];
                    
                    SearchSection sectionType = (SearchSection)currentItemIndexPath.section;
                    
                    switch (sectionType) {
                        case SearchSectionProjects: {
                            [self createNewProjectTrackingList:alertTextField];
                            break;
                        }
                        case SearchSectionCompanies: {
                            [self createNewCompanyTrackingList:alertTextField];
                            break;
                        }
                        default:
                            break;
                    }

                    
                }
            }
        }
    }];
    
    [alert addAction:actionAccept];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"NTL_CANCEL") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actionCancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)didTappedNewTrackingList:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self PopupViewControllerDismissed];
        [self getNewTrackingList];
    }];
}

@end

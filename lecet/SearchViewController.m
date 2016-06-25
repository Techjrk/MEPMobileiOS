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
} SearchSection;


@interface SearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    BOOL searchMode;
}
@property (weak, nonatomic) IBOutlet UITextField *labeSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)tappedButtonBack:(id)sender;
@end

@implementation SearchViewController

#define kSections               @[NSLocalizedLanguage(@"SEARCH_SECTION_RECENT"),NSLocalizedLanguage(@"SEARCH_SECTION_SAVED_PROJECT"),NSLocalizedLanguage(@"SEARCH_SECTION_SAVED_COMPANY"),NSLocalizedLanguage(@"SEARCH_SECTION_SUGGESTED"),NSLocalizedLanguage(@"SEARCH_SECTION_PROJECTS"),NSLocalizedLanguage(@"SEARCH_SECTION_COMPANIES"),NSLocalizedLanguage(@"SEARCH_SECTION_CONTACTS")]

#define kCellIdentifier(section)         [NSString stringWithFormat:@"kCellIdentifier_%li",(long)section]

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self enableTapGesture:YES];
    _labeSearch.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _labeSearch.layer.cornerRadius = kDeviceWidth * 0.0106;
    _labeSearch.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_filter"]];
    imageView.frame = CGRectMake(0, 0, kDeviceWidth * 0.1, kDeviceHeight * 0.025);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _labeSearch.rightView = imageView;
    _labeSearch.rightViewMode = UITextFieldViewModeAlways;
    _labeSearch.textColor = [UIColor whiteColor];
    _labeSearch.font = SEACRCH_TEXTFIELD_TEXT_FONT;
    [_labeSearch setTintColor:[UIColor whiteColor]];
    
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:SEACRCH_PLACEHOLDER_TEXT attributes:@{NSFontAttributeName:SEACRCH_PLACEHOLDER_FONT, NSForegroundColorAttributeName:SEACRCH_PLACEHOLDER_COLOR}];
    
    [placeHolder appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",NSLocalizedLanguage(@"SEARCH_PLACEHOLDER")] attributes:@{NSFontAttributeName:SEACRCH_TEXTFIELD_TEXT_FONT, NSForegroundColorAttributeName:SEACRCH_PLACEHOLDER_COLOR}]];
    _labeSearch.attributedPlaceholder = placeHolder;
  
    [_collectionView registerNib: [UINib nibWithNibName:[[SearchSectionCollectionViewCell class] description] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[[SearchSectionCollectionViewCell class] description]];
   
    [_collectionView registerNib:[UINib nibWithNibName:[[SearchSuggestedCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionRecent)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchSavedCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionSavedProject)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchSavedCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionSavedCompany)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchSuggestedCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionSuggested)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchProjectCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionProjects)];

    [_collectionView registerNib:[UINib nibWithNibName:[[SearchCompanyCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionCompanies)];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[SearchContactCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier(SearchSectionContacts)];


    
    searchMode = YES;
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

- (IBAction)tappedButtonBack:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UICollectionView Delegate and DataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier(indexPath.section) forIndexPath:indexPath];
    
    SearchSection sectionType = (SearchSection)indexPath.section;
    
    switch (sectionType) {
        case SearchSectionSuggested: {
            
            SearchSuggestedCollectionViewCell *cellItem = (SearchSuggestedCollectionViewCell*)cell;
            [cellItem setInfo:@"Jay Dee" count:3 headerType:(SearchSuggestedHeader)indexPath.row];
            
            break;
        }
        default:
            break;
    }

    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 7;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    SearchSection sectionType = (SearchSection)section;
    
    if ([self shouldShowSection:section] | ((sectionType == SearchSectionSuggested) & searchMode)) {

        switch (sectionType) {
                
            case SearchSectionRecent: {
                count = 1;
                break;
            }
                
            case SearchSectionSavedProject: {
                count = 3;
                break;
            }
                
            case SearchSectionSavedCompany: {
                count = 2;
                break;
            }
                
            case SearchSectionSuggested: {
                count = 3;
                break;
            }
                
            case SearchSectionProjects: {
                count = 4;
                break;
            }
                
            case SearchSectionCompanies: {
                count = 4;
                break;
            }
                
            case SearchSectionContacts: {
                count = 3;
                break;
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
    
    if ([self shouldShowSection:indexPath.section] | (sectionType == SearchSectionSuggested )) {

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
                
        }

    }
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    SearchSection sectionType = (SearchSection)section;
    return UIEdgeInsetsMake( 0, 0, kDeviceHeight * ([self shouldShowSection:section] | (sectionType == SearchSectionSuggested )?0.024:0), 0);
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
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    SearchSectionCollectionViewCell *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[[SearchSectionCollectionViewCell class] description] forIndexPath:indexPath];
    
    [sectionHeader setTitle:kSections[indexPath.section]];
    return sectionHeader;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    
    return  CGSizeMake(collectionView.frame.size.width, kDeviceHeight * ( [self shouldShowSection:section]?0.05:0));
}

- (BOOL)shouldShowSection:(NSInteger)section {

    SearchSection searchSection = (SearchSection)section;
    BOOL shouldExpandHeader = NO;
    
    if (!searchMode) {
        
        shouldExpandHeader = (searchSection  == SearchSectionRecent) || (searchSection == SearchSectionSavedProject) || (searchSection == SearchSectionSavedCompany);
        
    } else {
        
        shouldExpandHeader = !((searchSection  == SearchSectionRecent) || (searchSection == SearchSectionSavedProject) || (searchSection == SearchSectionSavedCompany) || (searchSection == SearchSectionSuggested));
        
    }

    return shouldExpandHeader;
}

@end

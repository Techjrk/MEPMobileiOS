//
//  SearchResultView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchResultView.h"

#import "ProjectTrackItemCollectionViewCell.h"
#import "CompanyTrackingCollectionViewCell.h"
#import "ContactItemCollectionViewCell.h"
#import "ContactsView.h"
#import "ProjectDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "ContactDetailViewController.h"

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)

@interface SearchResultView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableDictionary *items;
    NSNumber *currentTab;
    BOOL isFromSavedSearch;
    
    NSMutableArray *collectionItemsProjects;
    BOOL isFetchingCollectionItemsProjects;

    NSMutableArray *collectionItemsCompanies;
    BOOL isFetchingCollectionItemsCompanies;

    NSMutableArray *collectionItemsContacts;
    BOOL isFetchingCollectionItemsContacts;

}
@property (weak, nonatomic) IBOutlet UIButton *buttonProjects;
@property (weak, nonatomic) IBOutlet UIButton *buttonCompany;
@property (weak, nonatomic) IBOutlet UIButton *buttonContacts;
@property (weak, nonatomic) IBOutlet UIView *viewMarker;
@property (weak, nonatomic) IBOutlet UIView *viewTopHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMakerLeading;
- (IBAction)tappedButton:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;
@property (weak, nonatomic) IBOutlet UIView *viewLabelHeader;
@end

@implementation SearchResultView
@synthesize navigationController;

#define kCellIdentifierProject              @"kCellIdentifierProject"
#define kCellIdentifierCompany              @"kCellIdentifierCompany"
#define kCellIdentifierContact              @"kCellIdentifierContact"

- (void)awakeFromNib {
    [super awakeFromNib];
    _viewTopHeader.backgroundColor = TOP_HEADER_BG_COLOR;
    
    _labelHeader.font = BUTTON_FONT;
    _labelHeader.textColor = BUTTON_COLOR;
    _viewLabelHeader.backgroundColor = TOP_HEADER_BG_COLOR;
    
    [_buttonProjects setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    _buttonProjects.titleLabel.font = BUTTON_FONT;
    
    [_buttonCompany setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    _buttonCompany.titleLabel.font = BUTTON_FONT;
    
    [_buttonContacts setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    _buttonContacts.titleLabel.font = BUTTON_FONT;
    
    _viewMarker.backgroundColor = BUTTON_MARKER_COLOR;
    
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectTrackItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierProject];
 
    [_collectionView registerNib:[UINib nibWithNibName:[[CompanyTrackingCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierCompany];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[ContactItemCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifierContact];
    
    collectionItemsProjects = [NSMutableArray new];
    collectionItemsCompanies = [NSMutableArray new];
    collectionItemsContacts = [NSMutableArray new];
}

- (IBAction)tappedButton:(id)sender {
    
    UIButton *button = sender;
    _constraintMakerLeading.constant = button.frame.origin.x;

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            currentTab = [NSNumber numberWithInteger:(long)((button.frame.origin.x + button.frame.size.width) / button.frame.size.width) -1];
            [self.searchResultViewDelegate currentTabChanged:currentTab];
            [_collectionView reloadData];
        }
    }];
    
}

- (void)setCollectionItems:(NSMutableDictionary *)collectionItems tab:(NSNumber*)tab fromSavedSearch:(BOOL)fromSavedSearch {
    items = [collectionItems mutableCopy];
    
    NSDictionary *itemsProject = items[SEARCH_RESULT_PROJECT];
    if (itemsProject != nil) {
        NSArray *results = itemsProject[@"results"];
        [collectionItemsProjects removeAllObjects];
        [collectionItemsProjects addObjectsFromArray:results];
    }
    
    NSDictionary *itemsCompany = items[SEARCH_RESULT_COMPANY];
    if (itemsCompany != nil) {
        NSArray *results = itemsCompany[@"results"];
        [collectionItemsCompanies removeAllObjects];
        [collectionItemsCompanies addObjectsFromArray:results];
    }

    NSDictionary *itemsContacts = items[SEARCH_RESULT_CONTACT];
    if (itemsContacts != nil) {
        NSArray *results = itemsContacts[@"results"];
        [collectionItemsContacts removeAllObjects];
        [collectionItemsContacts addObjectsFromArray:results];
    }

    currentTab = tab;
    _constraintMakerLeading.constant = (kDeviceWidth * 0.333) * currentTab.integerValue;

    isFromSavedSearch = fromSavedSearch;

    [self setInfo];
    
}

- (void)displayHeaderForProject:(NSString*)projectTitle companyTitle:(NSString*)companyTitle contactTitle:(NSString*)contactTitle {
    _viewTopHeader.hidden = NO;
    if (isFromSavedSearch) {
        
        _viewTopHeader.hidden = YES;
        
        switch (currentTab.integerValue) {
            case 0: {
                _labelHeader.text = projectTitle;
                break;
            }
            case 1: {
                _labelHeader.text = companyTitle;
                break;
            }
            case 2: {
                _labelHeader.text = contactTitle;
                break;
            }
            default:
                break;
        }
        
    }

}

- (void)setCollectionItems:(NSMutableDictionary *)collectionItems {
}

- (NSInteger)getCollectionCount:(NSString*)string {

    NSMutableDictionary *collectionItems = items[string];
    NSArray *itemList = collectionItems[@"results"];
    return itemList.count;
}

- (NSInteger)getCollectionCountForTitle:(NSString*)string {
    
    NSMutableDictionary *collectionItems = items[string];
    return [collectionItems[@"total"] integerValue];
}

- (void)setInfo {
    
    NSString *projectTitle = [NSString stringWithFormat:NSLocalizedLanguage([self getCollectionCountForTitle:SEARCH_RESULT_PROJECT]<=1?@"SEARCH_RESULT_COUNT_PROJECT":@"SEARCH_RESULT_COUNT_PROJECTS"), [self getCollectionCountForTitle:SEARCH_RESULT_PROJECT]];
    [_buttonProjects setTitle:projectTitle forState:UIControlStateNormal];

    NSString *companyTitle = [NSString stringWithFormat:NSLocalizedLanguage([self getCollectionCountForTitle:SEARCH_RESULT_COMPANY]<=1?@"SEARCH_RESULT_COUNT_COMPANY":@"SEARCH_RESULT_COUNT_COMPANIES"), [self getCollectionCountForTitle:SEARCH_RESULT_COMPANY]];
    [_buttonCompany setTitle:companyTitle forState:UIControlStateNormal];

    NSString *contactTitle = [NSString stringWithFormat:NSLocalizedLanguage([self getCollectionCountForTitle:SEARCH_RESULT_CONTACT]<=1?@"SEARCH_RESULT_COUNT_CONTACT":@"SEARCH_RESULT_COUNT_CONTACTS"), [self getCollectionCountForTitle:SEARCH_RESULT_CONTACT]];
    [_buttonContacts setTitle:contactTitle forState:UIControlStateNormal];
    
    [self displayHeaderForProject:projectTitle companyTitle:companyTitle contactTitle:contactTitle];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
}

#pragma mark - Fetch Records

- (void)fetchProjects{
    
}

#pragma mark - UICollectionView source and delegate

- (void)modifyFilterForSkip:(NSMutableArray*)collectionItems filter:(NSMutableDictionary*)filter {
    
    NSString *filterString = filter[@"filter"];
    
    NSData *data = [filterString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    dict[@"skip"] = [NSNumber numberWithInteger:collectionItems.count];
    
    NSError *error = nil;
    data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];

    filterString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    filter[@"filter"] = filterString;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    //NSMutableDictionary *collectionItems = nil;
    
    switch (currentTab.integerValue) {
            
        case 0: {
            
            //collectionItems = items[SEARCH_RESULT_PROJECT];
            //NSArray *itemList = collectionItems[@"results"];
            ProjectTrackItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierProject forIndexPath:indexPath];
            cell = cellItem;
            [cellItem setInfo:collectionItemsProjects[indexPath.row]];

            NSInteger totalCount =  [self getCollectionCountForTitle:SEARCH_RESULT_PROJECT];

            if ( (indexPath.row == collectionItemsProjects.count-1) & (collectionItemsProjects.count<totalCount)) {
                if (!isFetchingCollectionItemsProjects) {
                    isFetchingCollectionItemsProjects = YES;
                    
                    NSMutableDictionary *filter = items[SEARCH_RESULT_PROJECT_FILTER];
                    
                    [self modifyFilterForSkip:collectionItemsProjects filter:filter];
                    
                    [[DataManager sharedManager] genericSearchUsingUrl:items[SEARCH_RESULT_PROJECT_URL] filter:filter success:^(id object) {
                        
                        NSArray *results = object[@"results"];
                        [collectionItemsProjects addObjectsFromArray:results];
                        [_collectionView reloadData];
                        
                        isFetchingCollectionItemsProjects = NO;
                    } failure:^(id object) {
                        isFetchingCollectionItemsProjects = NO;
                    }];
                }
            }
            break;
        }
        
        case 1: {
            //collectionItems = items[SEARCH_RESULT_COMPANY];
            //NSArray *itemList = collectionItems[@"results"];
            
            CompanyTrackingCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierCompany forIndexPath:indexPath];
            cell = cellItem;
            
            NSDictionary *item = collectionItemsCompanies[indexPath.row];
            NSString *address1 = [DerivedNSManagedObject objectOrNil:item[@"address1"]];
            
            NSString *addr = @"";
            NSString *county = [DerivedNSManagedObject objectOrNil:item[@"county"]];
            NSString *state = [DerivedNSManagedObject objectOrNil:item[@"state"]];
            NSString *zip = [DerivedNSManagedObject objectOrNil:item[@"zip5"]];
            
            if (county != nil) {
                addr = [addr stringByAppendingString:county];
                
                if (state != nil) {
                    addr = [addr stringByAppendingString:@", "];
                }
            }
            
            if (state != nil) {
                addr = [addr stringByAppendingString:state];
                if (zip != nil) {
                    [addr stringByAppendingString:@" "];
                }
            }
            
            if (zip != nil) {
                addr = [addr stringByAppendingString:zip];
                
            }

            [cellItem setTitleName:item[@"name"]];
            [cellItem setAddressTop:address1];
            [cellItem setAddressBelow:addr];
            [cellItem searchLocationGeoCode];

            NSInteger totalCount =  [self getCollectionCountForTitle:SEARCH_RESULT_COMPANY];
            
            if ( (indexPath.row == collectionItemsCompanies.count-1) & (collectionItemsCompanies.count<totalCount)) {
                if (!isFetchingCollectionItemsCompanies) {
                    isFetchingCollectionItemsCompanies = YES;
                    
                    NSMutableDictionary *filter = items[SEARCH_RESULT_COMPANY_FILTER];
                    
                    [self modifyFilterForSkip:collectionItemsCompanies filter:filter];
                    
                    [[DataManager sharedManager] genericSearchUsingUrl:items[SEARCH_RESULT_COMPANY_URL] filter:filter success:^(id object) {
                        
                        NSArray *results = object[@"results"];
                        [collectionItemsCompanies addObjectsFromArray:results];
                        [_collectionView reloadData];
                        
                        isFetchingCollectionItemsCompanies = NO;
                    } failure:^(id object) {
                        isFetchingCollectionItemsCompanies = NO;
                    }];
                }
            }
            break;
        }
            
        case 2: {
            //collectionItems = items[SEARCH_RESULT_CONTACT];
            //NSArray *itemList = collectionItems[@"results"];
            
            ContactItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierContact forIndexPath:indexPath];
            cell = cellItem;
          
            NSDictionary *item = collectionItemsContacts[indexPath.row];
            
            NSDictionary *company = [DerivedNSManagedObject objectOrNil:item[@"company"]];
            NSString *companyName = @"";
            
            if (company != nil) {
                companyName = [DerivedNSManagedObject objectOrNil:company[@"name"]];
            }
            
            if (companyName == nil) {
                companyName = @"";
            }
            [cellItem setItemInfo:@{CONTACT_NAME:item[@"name"], CONTACT_COMPANY:companyName}];

            NSInteger totalCount =  [self getCollectionCountForTitle:SEARCH_RESULT_CONTACT];
            
            if ( (indexPath.row == collectionItemsContacts.count-1) & (collectionItemsContacts.count<totalCount)) {
                if (!isFetchingCollectionItemsContacts) {
                    isFetchingCollectionItemsContacts = YES;
                    
                    NSMutableDictionary *filter = items[SEARCH_RESULT_CONTACT_FILTER];
                    
                    [self modifyFilterForSkip:collectionItemsContacts filter:filter];
                    
                    [[DataManager sharedManager] genericSearchUsingUrl:items[SEARCH_RESULT_CONTACT_URL] filter:filter success:^(id object) {
                        
                        NSArray *results = object[@"results"];
                        [collectionItemsContacts addObjectsFromArray:results];
                        [_collectionView reloadData];
                        
                        isFetchingCollectionItemsContacts = NO;
                    } failure:^(id object) {
                        isFetchingCollectionItemsContacts = NO;
                    }];
                }
            }

            break;
        }
            
    }
    
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] layoutIfNeeded];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (currentTab.integerValue) {
        case 0: {
            //return [self getCollectionCount:SEARCH_RESULT_PROJECT];
            return collectionItemsProjects.count;
            break;
        }
        case 1: {
            //return [self getCollectionCount:SEARCH_RESULT_COMPANY];
            return collectionItemsCompanies.count;
            break;
        }
            
        case 2 : {
            //return [self getCollectionCount:SEARCH_RESULT_CONTACT];
            return collectionItemsContacts.count;
            break;
        }
    }
    return 0;

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    size = CGSizeMake( collectionView.frame.size.width * 0.96, kDeviceHeight * (currentTab.integerValue == 2?0.145:0.13));
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(kDeviceHeight * 0.013, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceHeight * (currentTab.integerValue == 2?0:0.015);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (currentTab.integerValue == 0) {
        
        //NSMutableDictionary *collectionItems = items[SEARCH_RESULT_PROJECT];
        //NSArray *itemList = collectionItems[@"results"];
        NSDictionary *item = collectionItemsProjects[indexPath.row];
        
        [[DataManager sharedManager] projectDetail:item[@"id"] success:^(id object) {
            
            ProjectDetailViewController *detail = [ProjectDetailViewController new];
            detail.view.hidden = NO;
            [detail detailsFromProject:object];
            
            [self.navigationController pushViewController:detail animated:YES];
        } failure:^(id object) {
        }];
        
    } else if (currentTab.integerValue == 1) {
        
        //NSMutableDictionary *collectionItems = items[SEARCH_RESULT_COMPANY];
        //NSArray *itemList = collectionItems[@"results"];
        NSDictionary *item = collectionItemsCompanies[indexPath.row];
        
        [[DataManager sharedManager] companyDetail:item[@"id"] success:^(id object) {
            id returnObject = object;
            
            CompanyDetailViewController *controller = [CompanyDetailViewController new];
            controller.view.hidden = NO;
            [controller setInfo:returnObject];
            [self.navigationController pushViewController:controller animated:YES];
            
        } failure:^(id object) {
        }];

    } else if (currentTab.integerValue == 2) {
     
        //NSMutableDictionary *collectionItems = items[SEARCH_RESULT_CONTACT];
        //NSArray *itemList = collectionItems[@"results"];
        NSDictionary *item = collectionItemsContacts[indexPath.row];
        
        ContactDetailViewController *controller = [ContactDetailViewController new];
        [controller setCompanyContactDetailsFromDictionary:item];
        [self.navigationController pushViewController:controller animated:YES];

    }
}

- (void)reloadData {
    [_collectionView reloadData];
}
@end

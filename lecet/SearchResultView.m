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
}
@property (weak, nonatomic) IBOutlet UIButton *buttonProjects;
@property (weak, nonatomic) IBOutlet UIButton *buttonCompany;
@property (weak, nonatomic) IBOutlet UIButton *buttonContacts;
@property (weak, nonatomic) IBOutlet UIView *viewMarker;
@property (weak, nonatomic) IBOutlet UIView *viewTopHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMakerLeading;
- (IBAction)tappedButton:(id)sender;
@end

@implementation SearchResultView
@synthesize navigationController;

#define kCellIdentifierProject              @"kCellIdentifierProject"
#define kCellIdentifierCompany              @"kCellIdentifierCompany"
#define kCellIdentifierContact              @"kCellIdentifierContact"

- (void)awakeFromNib {
    [super awakeFromNib];
    _viewTopHeader.backgroundColor = TOP_HEADER_BG_COLOR;
    
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

- (void)setCollectionItems:(NSMutableDictionary *)collectionItems tab:(NSNumber*)tab {
    items = [collectionItems mutableCopy];
    currentTab = tab;
    _constraintMakerLeading.constant = (kDeviceWidth * 0.333) * currentTab.integerValue;
    [self setInfo];
    
}

- (void)setCollectionItems:(NSMutableDictionary *)collectionItems {
}

- (NSInteger)getCollectionCount:(NSString*)string {

    NSMutableDictionary *collectionItems = items[string];
    NSArray *itemList = collectionItems[@"results"];
    return itemList.count;
}

- (void)setInfo {
    
    [_buttonProjects setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"SEARCH_RESULT_COUNT_PROJECT"), [self getCollectionCount:SEARCH_RESULT_PROJECT]] forState:UIControlStateNormal];

    [_buttonCompany setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"SEARCH_RESULT_COUNT_COMPANY"), [self getCollectionCount:SEARCH_RESULT_COMPANY]] forState:UIControlStateNormal];

    [_buttonContacts setTitle:[NSString stringWithFormat:NSLocalizedLanguage(@"SEARCH_RESULT_COUNT_CONTACT"), [self getCollectionCount:SEARCH_RESULT_CONTACT]] forState:UIControlStateNormal];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    NSMutableDictionary *collectionItems = nil;
    
    switch (currentTab.integerValue) {
            
        case 0: {
            
            collectionItems = items[SEARCH_RESULT_PROJECT];
            NSArray *itemList = collectionItems[@"results"];
            ProjectTrackItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierProject forIndexPath:indexPath];
            cell = cellItem;
            [cellItem setInfo:itemList[indexPath.row]];
            break;
        }
        
        case 1: {
            collectionItems = items[SEARCH_RESULT_COMPANY];
            NSArray *itemList = collectionItems[@"results"];
            
            CompanyTrackingCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierCompany forIndexPath:indexPath];
            cell = cellItem;
            
            NSDictionary *item = itemList[indexPath.row];
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

            break;
        }
            
        case 2: {
            collectionItems = items[SEARCH_RESULT_CONTACT];
            NSArray *itemList = collectionItems[@"results"];
            
            ContactItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierContact forIndexPath:indexPath];
            cell = cellItem;
          
            NSDictionary *item = itemList[indexPath.row];
            
            NSDictionary *company = [DerivedNSManagedObject objectOrNil:item[@"company"]];
            NSString *companyName = @"";
            
            if (company != nil) {
                companyName = [DerivedNSManagedObject objectOrNil:company[@"name"]];
            }
            
            if (companyName == nil) {
                companyName = @"";
            }
            [cellItem setItemInfo:@{CONTACT_NAME:item[@"name"], CONTACT_COMPANY:companyName}];
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
            return [self getCollectionCount:SEARCH_RESULT_PROJECT];
            break;
        }
        case 1: {
            return [self getCollectionCount:SEARCH_RESULT_COMPANY];
            break;
        }
            
        case 2 : {
            return [self getCollectionCount:SEARCH_RESULT_CONTACT];
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
        
        NSMutableDictionary *collectionItems = items[SEARCH_RESULT_PROJECT];
        NSArray *itemList = collectionItems[@"results"];
        NSDictionary *item = itemList[indexPath.row];
        
        [[DataManager sharedManager] projectDetail:item[@"id"] success:^(id object) {
            
            ProjectDetailViewController *detail = [ProjectDetailViewController new];
            detail.view.hidden = NO;
            [detail detailsFromProject:object];
            
            [self.navigationController pushViewController:detail animated:YES];
        } failure:^(id object) {
        }];
        
    } else if (currentTab.integerValue == 1) {
        
        NSMutableDictionary *collectionItems = items[SEARCH_RESULT_COMPANY];
        NSArray *itemList = collectionItems[@"results"];
        NSDictionary *item = itemList[indexPath.row];
        
        [[DataManager sharedManager] companyDetail:item[@"id"] success:^(id object) {
            id returnObject = object;
            
            [[DataManager sharedManager] companyProjectBids:item[@"id"] success:^(id object) {
                CompanyDetailViewController *controller = [CompanyDetailViewController new];
                controller.view.hidden = NO;
                [controller setInfo:returnObject];
                [self.navigationController pushViewController:controller animated:YES];
            } failure:^(id object) {
            }];
            
        } failure:^(id object) {
        }];

    } else if (currentTab.integerValue == 2) {
     
        NSMutableDictionary *collectionItems = items[SEARCH_RESULT_CONTACT];
        NSArray *itemList = collectionItems[@"results"];
        NSDictionary *item = itemList[indexPath.row];
        
        ContactDetailViewController *controller = [[ContactDetailViewController alloc] initWithNibName:@"ContactDetailViewController" bundle:nil];
        [controller setCompanyContactDetailsFromDictionary:item];
        [self.navigationController pushViewController:controller animated:YES];

    }
}

- (void)reloadData {
    [_collectionView reloadData];
}
@end

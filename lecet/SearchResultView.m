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
#import "CustomActivityIndicatorView.h"
#import "ActionView.h"
#import "PopupViewController.h"
#import "NewTrackingListCollectionViewCell.h"
#import "TrackingListCellCollectionViewCell.h"
#import "ShareItemCollectionViewCell.h"

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)
#define LABEL_COLOR                                     RGB(34, 34, 34)

@interface SearchResultView()<UICollectionViewDelegate, UICollectionViewDataSource, CustomCollectionViewDelegate, PopupViewControllerDelegate, TrackingListViewDelegate, NewTrackingListCollectionViewCellDelegate, ActionViewDelegate>{
    NSMutableDictionary *items;
    NSNumber *currentTab;
    BOOL isFromSavedSearch;
    
    NSMutableArray *collectionItemsProjects;
    BOOL isFetchingCollectionItemsProjects;

    NSMutableArray *collectionItemsCompanies;
    BOOL isFetchingCollectionItemsCompanies;

    NSMutableArray *collectionItemsContacts;
    BOOL isFetchingCollectionItemsContacts;
    NSIndexPath *currentItemIndexPath;
    NSNumber *currentProjectId;
    NSNumber *currentCompanyId;
    ProjectDetailPopupMode popupMode;
    NSArray *trackItemRecord;
    
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
@property (weak, nonatomic) IBOutlet CustomActivityIndicatorView *customLoadingIndicator;

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
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipe:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipe:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView addGestureRecognizer:swipeGestureLeft];
    [self.collectionView addGestureRecognizer:swipeGestureRight];

}

- (void)userSwipe:(UISwipeGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (indexPath != nil) {
        UICollectionViewCell* cell = (UICollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        if( [cell respondsToSelector:@selector(actionView)]){
            ActionView * actionView = [cell performSelector:@selector(actionView)];
            [actionView swipeExpand:sender.direction];
        }

    }
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
    
    if ([filter respondsToSelector:@selector(dataUsingEncoding:)]) {

        NSData *data = [filterString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        dict[@"skip"] = [NSNumber numberWithInteger:collectionItems.count];
        
        NSError *error = nil;
        data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        
        filterString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        filter[@"filter"] = filterString;
       
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    switch (currentTab.integerValue) {
            
        case 0: {
            
            ProjectTrackItemCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierProject forIndexPath:indexPath];
            cell = cellItem;
            NSMutableDictionary *project = collectionItemsProjects[indexPath.row];
            [cellItem setInfo:project];
            [cellItem.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
            [cellItem.actionView itemHidden:NO];
            if (project[@"IS_HIDDEN"]) {
                [cellItem.actionView itemHidden:[project[@"IS_HIDDEN"] boolValue]];
            }
            
            [cellItem.actionView setUndoLabelTextColor: LABEL_COLOR];
            cellItem.actionViewDelegate = self;

            NSInteger totalCount =  [self getCollectionCountForTitle:SEARCH_RESULT_PROJECT];

            if ( (indexPath.row == collectionItemsProjects.count-1) & (collectionItemsProjects.count<totalCount)) {
                if (!isFetchingCollectionItemsProjects) {
                    isFetchingCollectionItemsProjects = YES;
                    
                    NSMutableDictionary *filter = items[SEARCH_RESULT_PROJECT_FILTER];
                    
                    [self modifyFilterForSkip:collectionItemsProjects filter:filter];
                    
                    [self.customLoadingIndicator startAnimating];
                    [[DataManager sharedManager] genericSearchUsingUrl:items[SEARCH_RESULT_PROJECT_URL] filter:filter success:^(id object) {
                        
                        NSArray *results = object[@"results"];
                        [collectionItemsProjects addObjectsFromArray:results];
                        [self.customLoadingIndicator stopAnimating];
                        [_collectionView reloadData];
                        
                        isFetchingCollectionItemsProjects = NO;
                    } failure:^(id object) {
                        [self.customLoadingIndicator stopAnimating];
                        isFetchingCollectionItemsProjects = NO;
                    }];
                }
            }
            break;
        }
        
        case 1: {
            
            CompanyTrackingCollectionViewCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierCompany forIndexPath:indexPath];
            cell = cellItem;
            
            NSMutableDictionary *item = collectionItemsCompanies[indexPath.row];
            
            [cellItem.actionView disableHide];
            [cellItem.actionView swipeExpand:UISwipeGestureRecognizerDirectionRight];
            [cellItem.actionView itemHidden:NO];
            if (item[@"IS_HIDDEN"]) {
                [cellItem.actionView itemHidden:[item[@"IS_HIDDEN"] boolValue]];
            }
            
            [cellItem.actionView setUndoLabelTextColor: LABEL_COLOR];
            cellItem.actionViewDelegate = self;
            
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
                    [self.customLoadingIndicator startAnimating];
                    [[DataManager sharedManager] genericSearchUsingUrl:items[SEARCH_RESULT_COMPANY_URL] filter:filter success:^(id object) {
                        
                        NSArray *results = object[@"results"];
                        [collectionItemsCompanies addObjectsFromArray:results];
                        [_collectionView reloadData];
                        [self.customLoadingIndicator stopAnimating];
                        
                        isFetchingCollectionItemsCompanies = NO;
                    } failure:^(id object) {
                        [self.customLoadingIndicator stopAnimating];
                        isFetchingCollectionItemsCompanies = NO;
                    }];
                }
            }
            break;
        }
            
        case 2: {
            
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
                    
                    [self.customLoadingIndicator startAnimating];
                    [[DataManager sharedManager] genericSearchUsingUrl:items[SEARCH_RESULT_CONTACT_URL] filter:filter success:^(id object) {
                        
                        NSArray *results = object[@"results"];
                        [collectionItemsContacts addObjectsFromArray:results];
                        [_collectionView reloadData];
                        [self.customLoadingIndicator stopAnimating];
                        isFetchingCollectionItemsContacts = NO;
                    } failure:^(id object) {
                        [self.customLoadingIndicator stopAnimating];
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
        
        [self.customLoadingIndicator startAnimating];
        [[DataManager sharedManager] projectDetail:item[@"id"] success:^(id object) {
            [self.customLoadingIndicator stopAnimating];
            ProjectDetailViewController *detail = [ProjectDetailViewController new];
            detail.view.hidden = NO;
            [detail detailsFromProject:object];
            
            [self.navigationController pushViewController:detail animated:YES];
        } failure:^(id object) {
            [self.customLoadingIndicator stopAnimating];
        }];
        
    } else if (currentTab.integerValue == 1) {
        
        //NSMutableDictionary *collectionItems = items[SEARCH_RESULT_COMPANY];
        //NSArray *itemList = collectionItems[@"results"];
        NSDictionary *item = collectionItemsCompanies[indexPath.row];
        [self.customLoadingIndicator startAnimating];
        [[DataManager sharedManager] companyDetail:item[@"id"] success:^(id object) {
            id returnObject = object;
            [self.customLoadingIndicator stopAnimating];
            CompanyDetailViewController *controller = [CompanyDetailViewController new];
            controller.view.hidden = NO;
            [controller setInfo:returnObject];
            [self.navigationController pushViewController:controller animated:YES];
            
        } failure:^(id object) {
            [self.customLoadingIndicator stopAnimating];
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

#pragma mark - Project Tracking List

- (void)displayProjectTrackingList:(id)sender {
    
    NSMutableDictionary *project = collectionItemsProjects[currentItemIndexPath.row];
    currentProjectId = project[@"id"];
    
    popupMode = ProjectDetailPopupModeTrack;
    
    [[DataManager sharedManager] projectAvailableTrackingList:currentProjectId success:^(id object) {
        
        trackItemRecord = object;
        
        if (trackItemRecord.count>0) {
            PopupViewController *controller = [PopupViewController new];
            
            ProjectTrackItemCollectionViewCell *cell = (ProjectTrackItemCollectionViewCell*)sender;
            
            CGRect rect = [controller getViewPositionFromViewController:[cell.actionView trackButton] controller:self.navigationController];
            controller.popupRect = rect;
            controller.popupWidth = 0.98;
            controller.isGreyedBackground = YES;
            controller.customCollectionViewDelegate = self;
            controller.popupViewControllerDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self.navigationController presentViewController:controller animated:NO completion:nil];
        } else {
            
            [self PopupViewControllerDismissed];
            
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"NO_TRACKING_LIST")];
        }
        
    } failure:^(id object) {
        
    }];
}

- (void)displayCompanyTrackingList:(id)sender {
    
    NSMutableDictionary *company = collectionItemsCompanies[currentItemIndexPath.row];
    currentCompanyId = company[@"id"];
    
    popupMode = ProjectDetailPopupModeTrack;
    [[DataManager sharedManager] companyAvailableTrackingList:currentCompanyId success:^(id object) {
        
        trackItemRecord = object;
        PopupViewController *controller = [PopupViewController new];
        CompanyTrackingCollectionViewCell *cell = (CompanyTrackingCollectionViewCell*)sender;
        
        CGRect rect = [controller getViewPositionFromViewController:[cell.actionView trackButton] controller:self.navigationController];
        controller.popupRect = rect;
        controller.popupWidth = 0.98;
        controller.isGreyedBackground = YES;
        controller.customCollectionViewDelegate = self;
        controller.popupViewControllerDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
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
    
    switch (currentTab.integerValue) {
        case 0: {
            [self displayProjectTrackingList:sender];
            break;
        }
        case 1: {
            [self displayCompanyTrackingList:sender];
            break;
        }
        default:
            break;
    }
}

- (void)shareProject:(id)sender {
    
    ProjectTrackItemCollectionViewCell *cell = (ProjectTrackItemCollectionViewCell*)sender;
    currentItemIndexPath = [self indexPathForSender:sender];
    NSDictionary *project = collectionItemsProjects[currentItemIndexPath.row];
    currentProjectId = project[@"id"];
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:[cell.actionView shareButton] controller:self.navigationController];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    
}

- (void)shareCompany:(id)sender {
    
    CompanyTrackingCollectionViewCell *cell = (CompanyTrackingCollectionViewCell*)sender;
    currentItemIndexPath = [self indexPathForSender:sender];
    NSDictionary *company = collectionItemsCompanies[currentItemIndexPath.row];
    currentProjectId = company[@"id"];
    
    popupMode = ProjectDetailPopupModeShare;
    PopupViewController *controller = [PopupViewController new];
    CGRect rect = [controller getViewPositionFromViewController:[cell.actionView shareButton] controller:self.navigationController];
    controller.popupRect = rect;
    controller.popupWidth = 0.98;
    controller.isGreyedBackground = YES;
    controller.customCollectionViewDelegate = self;
    controller.popupViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    
}

- (void)didShareItem:(id)sender {
    currentItemIndexPath = [self indexPathForSender:sender];
    
    switch (currentTab.integerValue) {
        case 0: {
            [self shareProject:sender];
            break;
        }
        case 1: {
            [self shareCompany:sender];
            break;
        }
        default:
            break;
    }
}

- (void)didHideProject:(id)sender {
    
    currentItemIndexPath = [self indexPathForSender:sender];
    NSMutableDictionary *project = [collectionItemsProjects[currentItemIndexPath.row] mutableCopy];
    currentProjectId = project[@"id"];
    
    [[DataManager sharedManager] hideProject:currentProjectId success:^(id object) {
        project[@"IS_HIDDEN"] = @YES;
        collectionItemsProjects[currentItemIndexPath.row] = project;
        [[DataManager sharedManager] saveContext];
        [self.collectionView reloadData];
    } failure:^(id object) {
    }];
}

- (void)didHideItem:(id)sender {
    currentItemIndexPath = [self indexPathForSender:sender];
    
    switch (currentTab.integerValue) {
        case 0: {
            [self didHideProject:sender];
            break;
        }
        case 1: {
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
    currentItemIndexPath = [self indexPathForSender:sender];
    NSMutableDictionary *project = collectionItemsProjects[currentItemIndexPath.row];
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
    
    switch (currentTab.integerValue) {
        case 0: {
            [self unhideProject:sender];
            break;
        }
        case 1: {
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
    
    NSDictionary *dict = collectionItemsProjects[currentItemIndexPath.row];
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
    
    NSMutableDictionary *company = collectionItemsCompanies[currentItemIndexPath.row];
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
    switch (currentTab.integerValue) {
        case 0: {
            [self didSelectShareProject:indexPath];
            break;
        }
        case 1: {
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
    
    switch (currentTab.integerValue) {
        case 0: {
            [self trackProjectItem:object];
            break;
        }
        case 1: {
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
                    
                    switch (currentTab.integerValue) {
                        case 0: {
                            [self createNewProjectTrackingList:alertTextField];
                            break;
                        }
                        case 1: {
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
    
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)didTappedNewTrackingList:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        [self PopupViewControllerDismissed];
        [self getNewTrackingList];
    }];
}
@end

//
//  CompanyFilterView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyFilterView.h"

#import "FilterEntryView.h"
#import "FilterLabelView.h"

#define LABEL_FONT                          fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define LABEL_COLOR                         RGB(34, 34, 34)
#define FILTER_VIEW_HEIGHT                  kDeviceHeight * 0.095

@interface CompanyFilterView()<FilterLabelViewDelegate, FilterEntryViewDelegate> {
    NSLayoutConstraint *constraintObject;
    NSArray *dataSelected;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFilterHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFilterValueHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFilterTitleHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelProject;
@end

@implementation CompanyFilterView
@synthesize companyFilterViewDelegate;
@synthesize searchFilter;

@synthesize dictLocation;
@synthesize dictValue;
@synthesize dictJurisdiction;
@synthesize dictBidding;
@synthesize dictProjectType;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.searchFilter = [NSMutableDictionary new];
    CGFloat fieldFilterHeight = FILTER_VIEW_HEIGHT;
    _constraintFilterHeight.constant = fieldFilterHeight;
    _constraintFilterValueHeight.constant = fieldFilterHeight;
    _constraintLabelHeight.constant = kDeviceHeight * 0.079;
    _constraintFilterTitleHeight.constant = fieldFilterHeight * 0.5;
    
    _labelProject.font = LABEL_FONT;
    _labelProject.textColor = LABEL_COLOR;
    _labelProject.text = NSLocalizedLanguage(@"COMPANY_FILTER_LABEL");
    
    [_fieldLocation setTitle:NSLocalizedLanguage(@"COMPANY_FILTER_LOCATION")];
    _fieldLocation.filterModel = FilterModelLocation;
    _fieldLocation.entryType = FilterEntryViewTypeOpenEntry;
    
    [_filterValue setTitle:NSLocalizedLanguage(@"COMPANY_FILTER_VALUE")];
    _filterValue.filterModel = FilterModelValue;
    
    [_fieldJurisdiction setTitle:NSLocalizedLanguage(@"COMPANY_FILTER_JURISDICTION")];
    _fieldJurisdiction.filterModel = FilterModelJurisdiction;
    
    [_filterBidding setTitle:NSLocalizedLanguage(@"COMPANY_FILTER_BIDDING")];
    _filterBidding.filterModel = FilterModelBidding;
    
    [_filterProjectType setTitle:NSLocalizedLanguage(@"COMPANY_FILTER_TYPE")];
    _filterProjectType.filterModel = FilterModelProjectType;
    
    [_fieldJurisdiction setValue:NSLocalizedLanguage(@"COMPANY_FILTER_ANY")];
    [_filterBidding setValue:NSLocalizedLanguage(@"COMPANY_FILTER_ANY")];
    [_filterProjectType setValue:NSLocalizedLanguage(@"COMPANY_FILTER_ANY")];
    
    [_fieldLocation setHint:NSLocalizedLanguage(@"PROJECT_FILTER_HINT_LOCATION")];
    [_filterValue setHint:NSLocalizedLanguage(@"PROJECT_FILTER_HINT_VALUE")];
    
    _fieldLocation.filterEntryViewDelegate = self;
    _filterValue.filterEntryViewDelegate = self;
    _fieldJurisdiction.filterLabelViewDelegate = self;
    _filterProjectType.filterLabelViewDelegate = self;
    _filterBidding.filterLabelViewDelegate = self;
    
}

- (void)tappedFilterLabelView:(id)object {
    [self.companyFilterViewDelegate tappedCompanyFilterItem:object view:self];
}

- (void)tappedFilterEntryViewDelegate:(id)object {
    [self.companyFilterViewDelegate tappedCompanyFilterItem:object view:self];
}

- (id)getItem:(id)info keyName:(id)key {
    return info[key];
}

- (void)reloadDataBeenComplete:(FilterModel)filterModel {

    int collectionViewContentSizeHeight = FILTER_VIEW_HEIGHT;
    NSLayoutConstraint *constraintHeight;
    int rowNumber = 0;
    
    if (filterModel == FilterModelLocation) {
        collectionViewContentSizeHeight = _fieldLocation.collectionView.contentSize.height;
        constraintHeight = _constraintFilterHeight;
        
        if ([_fieldLocation isEmpty]) {
            self.dictLocation = nil;
        }
    }
    
    if (filterModel == FilterModelValue) {
        collectionViewContentSizeHeight = _filterValue.collectionView.contentSize.height;
        constraintHeight = _constraintFilterValueHeight;
        
        if ([_filterValue isEmpty]) {
            self.dictValue = nil;
        }
    }
  
    CGFloat additionalHeight;
    CGFloat extraHeight;
    int heightToMultiplyWithRow;
    
    rowNumber = collectionViewContentSizeHeight / (kDeviceHeight * 0.035);
    int filterHeigthOrig = CELL_FILTER_ORIGINAL_HEIGHT;
    if (collectionViewContentSizeHeight > filterHeigthOrig) {
        if (rowNumber == 2) {
            heightToMultiplyWithRow  = (FILTER_VIEW_HEIGHT * 0.25);
        } else if (rowNumber == 4 ) {
            heightToMultiplyWithRow  = (FILTER_VIEW_HEIGHT * 0.34);
        } else if (rowNumber > 4 ) {
            heightToMultiplyWithRow  = (FILTER_VIEW_HEIGHT * 0.34);
        }
        else {
            heightToMultiplyWithRow  = (FILTER_VIEW_HEIGHT * 0.3);
        }
        
        extraHeight = heightToMultiplyWithRow * rowNumber;
    } else {
        extraHeight = 0;
    }
    
    additionalHeight = FILTER_VIEW_HEIGHT + (extraHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        constraintHeight.constant = additionalHeight;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
}

- (void)setLocationValue:(id)value {
    [_fieldLocation setInfo:value];
    
    NSMutableDictionary *itemdict = [NSMutableDictionary new];
    
    for (NSDictionary *item in _fieldLocation.openEntryFields) {
        NSString *field = item[@"FIELD"];
        NSString *value = [item[@"VALUE"] uppercaseString];
        
        if (value.length>0) {
            itemdict[field] = value;
        }
        
        if (itemdict.count>0) {
            self.dictLocation = @{@"companyLocation": itemdict};
        } else {
            self.dictLocation = nil;

        }
        
    }
}

- (void)setValuationValue:(id)value {
    NSDictionary *dict = value;
    NSString *stringValue;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *min = dict[@"min"];
    NSNumber *max = dict[@"max"];
    
    if (max) {
        stringValue = [NSString stringWithFormat:@"$ %@ - $ %@", [formatter stringFromNumber:min], [formatter stringFromNumber:max]];
    } else {
        stringValue = [NSString stringWithFormat:@"$ %@ - MAX", [formatter stringFromNumber:min]];
    }
    
    [_filterValue setInfo:@[@{@"entryID": @(0), @"entryTitle": stringValue}]];
    
    self.dictValue = @{@"valuation":dict};

}

- (void)setJurisdictionValue:(id)value titles:(NSArray*)titles{
    self.dictJurisdiction = @{@"jurisdictions":@{@"inq":value}};
    [_fieldJurisdiction setValue:titles[0]];
}

- (void)setBiddingValue:(id)value {
    NSString *title = [self getItem:value keyName:@"TITLE"];
    [_filterBidding setValue:title];
    self.dictBidding = @{@"biddingInNext":[self getItem:value keyName:@"VALUE"]};
}

- (void)setProjectTypeValue:(id)value titles:(NSArray*)titles{
    NSArray *items = titles;
    [_filterProjectType setValue:[items componentsJoinedByString:@","]];
    
    self.dictProjectType = @{@"projectTypes":@{@"inq":value}};
}

- (NSMutableDictionary *)filter {
    NSMutableDictionary *srchFilter = [NSMutableDictionary new];
    NSMutableDictionary *esFilter = [NSMutableDictionary new];
   
    /*
    @property (strong, nonatomic) NSDictionary *dictLocation;
    @property (strong, nonatomic) NSDictionary *dictValue;
    @property (strong, nonatomic) NSDictionary *dictJurisdiction;
    @property (strong, nonatomic) NSDictionary *dictBidding;
    @property (strong, nonatomic) NSDictionary *dictProjectType;
     */
    
    if (self.dictLocation) {
        [srchFilter addEntriesFromDictionary:self.dictLocation];
        esFilter[@"projectLocation"] = self.dictLocation[@"companyLocation"];
    }
    
    if (self.dictValue) {
        [srchFilter addEntriesFromDictionary:self.dictValue];
        esFilter[@"projectValue"] = self.dictValue[@"valuation"];
    }

    if (self.dictJurisdiction) {
        [esFilter addEntriesFromDictionary:self.dictJurisdiction];
    }
    
    if (self.dictBidding) {
        [esFilter addEntriesFromDictionary:self.dictBidding];
    }
    
    if (self.dictProjectType) {
        [esFilter addEntriesFromDictionary:self.dictProjectType];
    }
    
    return [@{@"filter":@{@"searchFilter":srchFilter, @"esFilter":esFilter}} mutableCopy] ;
}

@end

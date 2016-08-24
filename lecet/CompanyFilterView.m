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
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldLocation;
@property (weak, nonatomic) IBOutlet FilterEntryView *filterValue;
@property (weak, nonatomic) IBOutlet UILabel *labelProject;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldJurisdiction;
@property (weak, nonatomic) IBOutlet FilterLabelView *filterBidding;
@property (weak, nonatomic) IBOutlet FilterLabelView *filterProjectType;
@end

@implementation CompanyFilterView
@synthesize companyFilterViewDelegate;
@synthesize searchFilter;

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

- (void)setFilterModelInfo:(FilterModel)filterModel value:(id)val{
    NSString *title;
    switch (filterModel) {
        case FilterModelLocation:{
            [_fieldLocation setInfo:val];
            
            break;
        }
        case FilterModelType:{
            
            break;
        }
        case FilterModelValue:{
            NSDictionary *dict = val;
            NSString *value;
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSNumber *min = dict[@"min"];
            NSNumber *max = dict[@"max"];
            
            if (max) {
                value = [NSString stringWithFormat:@"$ %@ - $ %@", [formatter stringFromNumber:min], [formatter stringFromNumber:max]];
            } else {
                value = [NSString stringWithFormat:@"$ %@ - MAX", [formatter stringFromNumber:min]];
            }
            
            [_filterValue setInfo:@[@{@"entryID": @(0), @"entryTitle": value}]];
       
            break;
        }
        case FilterModelUpdated:{
            
            break;
        }
        case FilterModelJurisdiction:{
            NSArray *items = val;
            [_fieldJurisdiction setValue:[items componentsJoinedByString:@","]];
            break;
        }
        case FilterModelStage:{
            
            break;
        }
        case FilterModelBidding:{
            
            title = [self getItem:val keyName:@"TITLE"];
            [_filterBidding setValue:title];
            
            break;
        }
        case FilterModelBH:{

            break;
        }
        case FilterModelOwner:{

            break;
        }
        case FilterModelWork:{

            break;
        }
        case FilterModelProjectType:{
            NSArray *items = val;
            [_filterProjectType setValue:[items componentsJoinedByString:@","]];
            break;
        }
            
    }
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
    }
    
    if (filterModel == FilterModelValue) {
        collectionViewContentSizeHeight = _filterValue.collectionView.contentSize.height;
        constraintHeight = _constraintFilterValueHeight;
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

- (void)setLocationInfo:(id)info {
    dataSelected = [info copy];
    [_fieldLocation setInfo:info];
}

@end

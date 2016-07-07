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

#define LABEL_FONT                  fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define LABEL_COLOR                 RGB(34, 34, 34)

@interface CompanyFilterView()<FilterLabelViewDelegate, FilterEntryViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFilterHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelHeight;
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldLocation;
@property (weak, nonatomic) IBOutlet FilterEntryView *filterValue;
@property (weak, nonatomic) IBOutlet UILabel *labelProject;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldJurisdiction;
@property (weak, nonatomic) IBOutlet FilterLabelView *filterBidding;
@property (weak, nonatomic) IBOutlet FilterLabelView *filterProjectType;
@end

@implementation CompanyFilterView
@synthesize companyFilterViewDelegate;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _constraintFilterHeight.constant = kDeviceHeight * 0.115;
    _constraintLabelHeight.constant = kDeviceHeight * 0.079;
    
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

@end

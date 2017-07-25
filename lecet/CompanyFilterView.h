//
//  CompanyFilterView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"
#import "ProjectFilterView.h"

@protocol CompanyFilterViewDelegate <NSObject>
- (void)tappedCompanyFilterItem:(id)object view:(UIView*)view;
@end

@interface CompanyFilterView : BaseViewClass
@property (weak, nonatomic) id<CompanyFilterViewDelegate>companyFilterViewDelegate;
@property (strong, nonatomic) NSMutableDictionary *searchFilter;

@property (weak, nonatomic) IBOutlet FilterEntryView *fieldLocation;
@property (weak, nonatomic) IBOutlet FilterEntryView *filterValue;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldJurisdiction;
@property (weak, nonatomic) IBOutlet FilterLabelView *filterBidding;
@property (weak, nonatomic) IBOutlet FilterLabelView *filterProjectType;

@property (strong, nonatomic) NSDictionary *dictLocation;
@property (strong, nonatomic) NSDictionary *dictValue;
@property (strong, nonatomic) NSDictionary *dictJurisdiction;
@property (strong, nonatomic) NSDictionary *dictBidding;
@property (strong, nonatomic) NSDictionary *dictProjectType;

- (void)setLocationValue:(id)value;
- (void)setValuationValue:(id)value;
- (void)setJurisdictionValue:(id)value titles:(NSArray*)titles;
- (void)setBiddingValue:(id)value;
- (void)setProjectTypeValue:(id)value titles:(NSArray*)titles;
- (NSMutableDictionary *)filter;

@end

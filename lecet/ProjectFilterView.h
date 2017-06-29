//
//  ProjectFilterView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"
#import "FilterEntryView.h"
#import "FilterLabelView.h"

@protocol ProjectFilterViewDelegate <NSObject>
- (void)tappedProjectFilterItem:(id)object view:(UIView*)view;
- (void)tappedProjectTypeChanged:(NSMutableArray*)items;
@end

@interface ProjectFilterView : BaseViewClass
@property (weak, nonatomic) id<ProjectFilterViewDelegate>projectFilterViewDelegate;
@property (weak, nonatomic) UIScrollView *scrollView;
//@property (strong, nonatomic) NSMutableDictionary *searchFilter;

@property (weak, nonatomic) IBOutlet FilterEntryView *fieldLocation;
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldType;
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldValue;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldUpdated;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldJurisdiction;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldStage;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldBidding;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldBH;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldOwner;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldWork;

@property (strong, nonatomic) NSDictionary *dictLocation;
@property (strong, nonatomic) NSDictionary *dictProjectType;
@property (strong, nonatomic) NSDictionary *dictProjectValue;
@property (strong, nonatomic) NSDictionary *dictUpdatedWithin;
@property (strong, nonatomic) NSDictionary *dictJurisdiction;
@property (strong, nonatomic) NSDictionary *dictProjectStage;
@property (strong, nonatomic) NSDictionary *dictBiddingWithin;
@property (strong, nonatomic) NSDictionary *dictBH;
@property (strong, nonatomic) NSDictionary *dictOwnerType;
@property (strong, nonatomic) NSDictionary *dictWorkType;

- (void) setConstraint:(NSLayoutConstraint*)constraint;
//- (void)setFilterModelInfo:(FilterModel)filterModel value:(id)val;
- (void)setLocationInfo:(id)info;
- (void)hideLocation:(BOOL)hidden;

- (void)setLocationValue:(id)value;
- (void)setProjectTypeValue:(id)value titles:(NSArray*)titles;
- (void)setValuationValue:(id)value;
- (void)setUpdatedWithinValue:(id)value;
- (void)setJurisdictionValue:(id)value titles:(NSArray*)titles;
- (void)setProjectStageValue:(id)value titles:(NSArray*)titles;
- (void)setBiddingWithinValue:(id)value;
- (void)setBHValue:(id)value;
- (void)setOwnerTypeValue:(id)value;
- (void)setWorkTypeValue:(id)value;

- (NSMutableDictionary*)filter;

@end

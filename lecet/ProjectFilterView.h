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
@end

@interface ProjectFilterView : BaseViewClass
@property (weak, nonatomic) id<ProjectFilterViewDelegate>projectFilterViewDelegate;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *searchFilter;

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

- (void) setConstraint:(NSLayoutConstraint*)constraint;
- (void)setFilterModelInfo:(FilterModel)filterModel value:(id)val;
- (void)setLocationInfo:(id)info;
- (void)hideLocation:(BOOL)hidden;


@end

//
//  ProjectFilterView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

typedef enum : NSUInteger {
    FilterModelLocation,
    FilterModelType,
    FilterModelValue,
    FilterModelUpdated,
    FilterModelJurisdiction,
    FilterModelStage,
    FilterModelBidding,
    FilterModelBH,
    FilterModelOwner,
    FilterModelWork,
    FilterModelProjectType
} FilterModel;

@protocol ProjectFilterViewDelegate <NSObject>
- (void)tappedProjectFilterItem:(id)object view:(UIView*)view;
@end

@interface ProjectFilterView : BaseViewClass
@property (weak, nonatomic) id<ProjectFilterViewDelegate>projectFilterViewDelegate;
@property (weak, nonatomic) UIScrollView *scrollView;
- (void) setConstraint:(NSLayoutConstraint*)constraint;
- (void)setFilterModelInfo:(FilterModel)filterModel value:(id)val;
- (void)setLocationInfo:(id)info;
@end

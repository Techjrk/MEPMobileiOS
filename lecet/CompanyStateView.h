//
//  CompanyStateView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

typedef enum : NSUInteger {
    CompanyStateTrack = 0,
    CompanyStateShare = 1
} CompanyState;

@protocol CompanyStateDelegate <NSObject>
- (void)tappedCompanyState:(CompanyState)companyState view:(UIView*)view;
- (void)tappedCompnayStateContact:(id)object;
@end

@interface CompanyStateView : BaseViewClass
@property (strong, nonatomic) id<CompanyStateDelegate>companyStateDelegate;
- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
- (void)setItems:(NSMutableArray*)items;
- (void)clearSelection;
@end

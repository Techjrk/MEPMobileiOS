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
@end

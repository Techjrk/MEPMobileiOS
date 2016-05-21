//
//  CompanyHeaderView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol CompanyHeaderDelegate <NSObject>
- (void)tappedCompanyMapViewLat:(CGFloat)lat lng:(CGFloat)lng;
@end

@interface CompanyHeaderView : BaseViewClass
@property (strong, nonatomic) id<CompanyHeaderDelegate>companyCampanyHeaderDelegate;
- (void)setHeaderInfo:(id)headerInfo;
- (CGRect)mapFrame;
@end

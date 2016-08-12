//
//  CompanyHeaderView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#define COMPANY_GEOCODE_LAT                         @"GEO_CODE_LAT"
#define COMPANY_GEOCODE_LNG                         @"GEO_CODE_LNG"
#define COMPANY_TITLE                               @"PROJECT_TITLE"
#define COMPANY_GEO_ADDRESS                         @"COMPANY_GEO_ADDRESS"

@protocol CompanyHeaderDelegate <NSObject>
- (void)tappedCompanyMapViewLat:(CGFloat)lat lng:(CGFloat)lng;
@end

@interface CompanyHeaderView : BaseViewClass
@property (strong, nonatomic) id<CompanyHeaderDelegate>companyCampanyHeaderDelegate;
- (void)setHeaderInfo:(id)headerInfo;
- (CGRect)mapFrame;
@end

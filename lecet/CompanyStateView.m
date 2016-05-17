//
//  CompanyStateView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyStateView.h"

#import "companyStateConstants.h"

@interface CompanyStateView()
@end

@implementation CompanyStateView

- (void)awakeFromNib {
    self.layer.shadowColor = [COMPANY_STATE_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
   
}

@end

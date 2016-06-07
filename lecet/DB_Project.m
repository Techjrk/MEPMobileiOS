//
//  DB_Project.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DB_Project.h"

@implementation DB_Project

- (NSString *)getProjectType {
    NSString *projectType = [NSString stringWithFormat:@"%@ %@ %@", self.primaryProjectTypeTitle==nil?@"":self.primaryProjectTypeTitle, self.projectCategoryTitle==nil?@"":self.projectCategoryTitle, self.projectGroupTitle==nil?@"":self.projectGroupTitle];

    return projectType;
}

- (NSString *)address {
    
    return [NSString stringWithFormat:@"%@, %@", self.county, self.state];
}

- (NSString*)bidAmountWithCurrency {

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    CGFloat estlow = 0;
    if (self.estLow != nil) {
        estlow = self.estLow.floatValue;
    }
    NSString *estLow = [formatter stringFromNumber:[NSNumber numberWithFloat:estlow]];
    NSString *currency = self.currencyType == nil?@"$":self.currencyType;
    return [NSString stringWithFormat:@"%@ %@", currency, estLow ];
    
}

- (NSString*)bidDateString {
    NSDate *date =[DerivedNSManagedObject dateFromDateAndTimeString:self.bidDate];
    if (date == nil) {
        return  @"";
    }
    return [DerivedNSManagedObject monthDayStringFromDate:date];

}

@end

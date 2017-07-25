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
    NSString *addr = @"";
    if (self.county != nil) {
        addr = [addr stringByAppendingString:self.county];
        
        if (self.state != nil) {
            addr = [addr stringByAppendingString:@", "];
        }
    }
    
    if (self.state != nil) {
        addr = [addr stringByAppendingString:self.state];
    }
    return addr;
}

- (NSString *)fullAddress {
    NSString *fullAddr = @"";
    if(self.address1 != nil) {
        fullAddr = [fullAddr stringByAppendingString:self.address1];
        
        if (self.city != nil | self.state != nil) {
            fullAddr = [fullAddr stringByAppendingString:@", "];
        }
    }
    
    if (self.city != nil) {
        fullAddr = [fullAddr stringByAppendingString:self.city];
        if (self.state != nil | self.zip5 != nil) {
            fullAddr = [fullAddr stringByAppendingString:@", "];
        }
    }
    
    if (self.state != nil) {
        fullAddr = [fullAddr stringByAppendingString:self.state];

        if (self.zip5 != nil) {
            fullAddr = [fullAddr stringByAppendingString:@" "];
        }
    }
    
    if (self.zip5 != nil) {
        fullAddr = [fullAddr stringByAppendingString:self.zip5];
 
    }
    
    return fullAddr;
}

- (NSString*)estLowAmountWithCurrency {

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    CGFloat estlow = 0;
    if (self.estLow != nil) {
        estlow = self.estLow.floatValue;
    }
    NSString *estLow = [formatter stringFromNumber:[NSNumber numberWithFloat:estlow]];
    NSString *currency = self.currencyType == nil?@"$":self.currencyType;
    
    if (estLow == 0) {
        return nil;
    } else {
        return [NSString stringWithFormat:@"%@ %@", currency, estLow ];
    }
    
}

- (NSString*)estHighAmountWithCurrency {
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    CGFloat esthigh = 0;
    if (self.estHigh != nil) {
        esthigh = self.estHigh.floatValue;
    }
    NSString *estHigh = [formatter stringFromNumber:[NSNumber numberWithFloat:esthigh]];
    NSString *currency = self.currencyType == nil?@"$":self.currencyType;
    
    if (estHigh == 0) {
        return nil;
    } else {
        return [NSString stringWithFormat:@"%@ %@", currency, estHigh ];
    }

}

- (NSString*)bidDateString {
    NSDate *date =[DerivedNSManagedObject dateFromDateAndTimeString:self.bidDate];
    if (date == nil) {
        return  @"";
    }
    return [DerivedNSManagedObject shortDateStringFromDate:date];

}

- (NSString *)dateAddedString {
    NSDate *date =[DerivedNSManagedObject dateFromDateAndTimeString:self.firstPublishDate];
    if (date != nil) {
        return  [DerivedNSManagedObject shortDateStringFromDate:date];
    }
    return nil;
}

- (NSString *)startDateString {
    NSDate *date =[DerivedNSManagedObject dateFromDateAndTimeString:self.targetStartDate];
    if (date != nil) {
        return  [DerivedNSManagedObject shortDateStringFromDate:date];
    }
    return nil;
}

- (NSString *)finishDateString {
    NSDate *date =[DerivedNSManagedObject dateFromDateAndTimeString:self.targetFinishDate];
    if (date != nil) {
        return  [DerivedNSManagedObject shortDateStringFromDate:date];
    }
    return nil;
}

- (NSString *)lastUpdateDateString {
    NSDate *date =[DerivedNSManagedObject dateFromDateAndTimeString:self.lastPublishDate];
    if (date != nil) {
        return  [DerivedNSManagedObject shortDateStringFromDate:date];
    }
    return nil;
}

@end

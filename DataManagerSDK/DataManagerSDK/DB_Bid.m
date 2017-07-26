//
//  DB_Bid.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DB_Bid.h"
#import "DB_Company.h"
#import "DB_Contact.h"
#import "DB_Project.h"

@implementation DB_Bid

- (NSString*)bidAmountWithCurrency {
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    CGFloat amt = 0;
    if (self.amount != nil) {
        amt = self.amount.floatValue;
    }
    NSString *amtString = [formatter stringFromNumber:[NSNumber numberWithFloat:amt]];
    
    NSString *currency = self.relationshipProject.currencyType == nil?@"$":self.relationshipProject.currencyType;
    return [NSString stringWithFormat:@"%@ %@", currency, amtString ];
    
}

@end

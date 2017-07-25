//
//  DB_Company.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DB_Company.h"

@implementation DB_Company

- (NSString *)address {
    
    return [NSString stringWithFormat:@"%@, %@", self.county, self.state];
}

- (NSString*)completeAddress {
    
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

@end

//
//  DB_CompanyContact.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DB_CompanyContact.h"
#import "DB_Company.h"
@implementation DB_CompanyContact

// Insert code here to add functionality to your managed object subclass

- (NSString *)fullAddress {
    

    NSString *fullAddr = @"";
    if(self.relationshipCompany.address1 != nil) {
        fullAddr = [fullAddr stringByAppendingString:self.relationshipCompany.address1];
        
        if (self.relationshipCompany.state != nil | self.relationshipCompany.zip5 != nil) {
            fullAddr = [fullAddr stringByAppendingString:@", "];
        }
    }
    
    if (self.relationshipCompany.state != nil) {
        fullAddr = [fullAddr stringByAppendingString:self.relationshipCompany.state];
        
        if (self.relationshipCompany.zip5 != nil) {
            fullAddr = [fullAddr stringByAppendingString:@" "];
        }
    }
    
    if (self.relationshipCompany.zip5 != nil) {
        fullAddr = [fullAddr stringByAppendingString:self.relationshipCompany.zip5];
        
    }
    
    return fullAddr;
}

@end

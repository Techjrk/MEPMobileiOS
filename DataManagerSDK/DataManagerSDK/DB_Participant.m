//
//  DB_Participant.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DB_Participant.h"
#import "DB_Project.h"

@implementation DB_Participant

- (NSString *)address {
    NSString *addr = @"";
    
    if (self.county != nil) {
        addr = [addr stringByAppendingString:self.county];
        
        if (self.state != nil ) {
            addr = [addr stringByAppendingString:@", "];
        }
    }
    
    if (self.state != nil) {
        addr = [addr stringByAppendingString:self.state];
    }
    
    return addr;
}

@end

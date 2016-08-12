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
    
    return [NSString stringWithFormat:@"%@ %@ %@, %@", self.address1, self.address2, self.county, self.state];
}

@end

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
    return [NSString stringWithFormat:@"%@, %@", self.county, self.state];
}

@end

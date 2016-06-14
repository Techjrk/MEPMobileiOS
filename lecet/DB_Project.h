//
//  DB_Project.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DB_Bid, DB_Participant, DB_Company;

NS_ASSUME_NONNULL_BEGIN

@interface DB_Project : DerivedNSManagedObject

- (NSString*)getProjectType;
- (NSString*)address;
- (NSString*)fullAddress;
- (NSString*)estLowAmountWithCurrency;
- (NSString*)estHighAmountWithCurrency;
- (NSString*)bidDateString;

@end

NS_ASSUME_NONNULL_END

#import "DB_Project+CoreDataProperties.h"

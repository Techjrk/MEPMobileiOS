//
//  DB_Company.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class DB_CompanyContact, DB_Bid, DB_Project;

@interface DB_Company : DerivedNSManagedObject

- (NSString *)address;

@end

NS_ASSUME_NONNULL_END

#import "DB_Company+CoreDataProperties.h"

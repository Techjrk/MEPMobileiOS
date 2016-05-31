//
//  DB_Project.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DB_Bid, DB_Participant;

NS_ASSUME_NONNULL_BEGIN

@interface DB_Project : DerivedNSManagedObject

- (NSString*)getProjectType;

@end

NS_ASSUME_NONNULL_END

#import "DB_Project+CoreDataProperties.h"

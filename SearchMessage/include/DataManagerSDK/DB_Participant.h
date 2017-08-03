//
//  DB_Participant.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "DerivedNSManagedObject.h"

@class DB_Project;

NS_ASSUME_NONNULL_BEGIN

@interface DB_Participant : DerivedNSManagedObject

- (NSString *)address;

@end

NS_ASSUME_NONNULL_END

#import "DB_Participant+CoreDataProperties.h"

//
//  DerivedNSManagedObject.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DerivedNSManagedObject : NSManagedObject

// For Overload
+ (nullable NSString*)primaryKey;

// Class Functions
+ (nullable NSDate *)dateFromDateAndTimeString:(nullable NSString *)dateString;
+ (nullable NSDate *)dateFromDayString:(nullable NSString *)dateString;
+ (nullable NSString *)dateStringFromDateDay:(nullable NSDate*)date;
+ (nullable NSString *)monthDayStringFromDate:(nullable NSDate*)date;
+ (nullable NSString *)timeStringDate:(nullable NSDate *)date;
+ (nullable NSString *)yearMonthFromDate:(nullable NSDate *)date;
+ (nullable id)objectOrNil:(nullable id)object;
+ (nonnull id)createEntity;
+ (nullable id)fetchObjectForPredicate:(nullable NSPredicate *)predicate key:(nullable NSString *)key ascending:(BOOL)ascending;
+ (nullable NSArray *)fetchObjectsForPredicate:(nullable NSPredicate *)predicate key:(nullable NSString *)key ascending:(BOOL)ascending;

// Instance Functions
- (void)saveContext;
- (void)deleteFromContext;
@end

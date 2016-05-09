//
//  DerivedNSManagedObject.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DerivedNSManagedObject.h"

#import "BaseManager.h"

@implementation DerivedNSManagedObject

#pragma mark - Overload
+ (NSString*)primaryKey{ return @"id";};

#pragma mark - Class functions

+ (nullable NSArray *)fetchObjectsForPredicate:(nullable NSPredicate *)predicate key:(nullable NSString *)key ascending:(BOOL)ascending {
    NSArray *results = nil;
    
    NSFetchRequest *request	= [[NSFetchRequest alloc] init];
    
    if (key) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
    }
    [request setEntity:[self entity]];
    [request setPredicate:predicate];
    
    results = [[[BaseManager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
    return results;
}

+ (id)fetchObjectForPredicate:(nullable NSPredicate *)predicate key:(nullable NSString *)key ascending:(BOOL)ascending{
    NSArray *results = [self fetchObjectsForPredicate:predicate key:key ascending:ascending];
    if ([results count] > 0)
        return [results objectAtIndex:0];
    
    return nil;
}


+ (NSDate *)dateFromDateAndTimeString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (dateString.length>19) {
        dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        dateString = [dateString substringWithRange:NSMakeRange(0, 19)];
    }
    //[formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateString];
}


+ (NSDate *)dateFromDayString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:dateString];
}

+ (NSString *)dateStringFromDateDay:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSString *)yearMonthFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter stringFromDate:date];
}


+ (NSString *)monthDayStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d"];
    return [formatter stringFromDate:date];
}

+ (NSString *)timeStringDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"hh:mm a"];
    return [formatter stringFromDate:date];
}


+ (BOOL)isEmpty:(id)object {
    return (object == nil
            || (object == [NSNull null])
            || ([object respondsToSelector:@selector(length)] && [(NSData *) object length] == 0)
            || ([object respondsToSelector:@selector(count)] && [(NSArray *) object count] == 0));
}

+ (id)objectOrNil:(id)object {
    return (([self isEmpty:(object)])?nil:object);
}

#pragma mark - ManagedObjects

+ (NSEntityDescription *)entity {
    NSString *className = [[self class] description];
    return [NSEntityDescription entityForName:className inManagedObjectContext: [[BaseManager sharedManager] managedObjectContext]];
    ;
}

+ (id)createEntity {
    return [[self alloc] initWithEntity:[self entity] insertIntoManagedObjectContext:[[BaseManager sharedManager]managedObjectContext]];
}

- (void)saveContext{
    [[BaseManager sharedManager]saveContext];
}

- (void)deleteFromContext{
    [[[BaseManager sharedManager] managedObjectContext ] deleteObject:self];
}

@end

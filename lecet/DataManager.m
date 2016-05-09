//
//  DataManager.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DataManager.h"

#import "DerivedNSManagedObject.h"

#define kbaseUrl                @"http://lecet.dt-staging.com/api/"
#define kUrlLogin               @"LecetUsers/login"
#define kUrlBids                @"Bids"
#define kUrlHappeningSoon       @"Projects/search"

@implementation DataManager

#pragma mark Date Function

- (NSDateComponents*)getDateComponents:(NSDate*)date {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday | kCFCalendarUnitWeekdayOrdinal fromDate:date];
}

- (NSDate*) getDateFirstDay:(NSDate*) date {
    NSDateComponents *componentsBase = [self getDateComponents:date];
    [componentsBase setDay:1];
    
    return [[NSCalendar currentCalendar] dateFromComponents: componentsBase];
}

- (NSDate*)getDateLastDay:(NSDate*)date{
    NSDate *firstDay = [self getDateFirstDay:date];
    NSDateComponents *componentsBase = [self getDateComponents:firstDay];
    [componentsBase setMonth:[componentsBase month]+1];
    [componentsBase setDay:0];
    return [[NSCalendar currentCalendar] dateFromComponents: componentsBase];
}

#pragma mark API

- (void)changeHTTPHeader:(AFHTTPSessionManager *)manager {
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

- (void)authenticate:(AFHTTPSessionManager *)manager {
    NSString *accessToken = [self getKeyChainValue:kKeychainAccessToken serviceName:kKeychainServiceName];
    
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];
}

- (NSString*)url:(NSString*)url {

    return [kbaseUrl stringByAppendingString:url];
}

- (void)userLogin:(NSString *)email password:(NSString *)password success:(APIBlock)success failure:(APIBlock)failure {
    
    [self HTTP_POST:[self url:kUrlLogin] parameters:@{@"email":email, @"password":password} success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:NO];
}

- (void)bids:(NSDate *)dateFilter  success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDate *startDate = [self getDateFirstDay:dateFilter];
    NSDate *lastDate = [self getDateLastDay:startDate];
   
    NSDictionary *filter = @{@"filter[where][and][0][createDate][gte]": [DerivedNSManagedObject dateStringFromDateDay:startDate], @"filter[where][and][1][createDate][lte]": [DerivedNSManagedObject dateStringFromDateDay:lastDate]};
    
    [self HTTP_GET:[self url:kUrlBids] parameters:filter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)happeningSoon:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure{

    NSDictionary *filter =@{@"filter[searchFilter][biddingInNext]":[NSNumber numberWithInteger:numberOfDays], @"q":@"a" };
    [self HTTP_GET:[self url:kUrlHappeningSoon] parameters:filter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}
@end

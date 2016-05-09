//
//  DataManager.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DataManager.h"

#import "DB_BidSoon.h"

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
        NSDictionary *results = object[@"results"];
        
        for (NSDictionary *item in results) {
            
            NSString *recordId = item[@"id"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %@", recordId];
            
            DB_BidSoon *record = [DB_BidSoon fetchObjectForPredicate:predicate key:nil ascending:YES];
            
            if (record == nil) {
                record = [DB_BidSoon createEntity];
            }
            
            NSDate *bidDate = [DerivedNSManagedObject dateFromDateAndTimeString:item[@"bidDate"]];
            
            NSString *bidDateString = [DerivedNSManagedObject dateStringFromDateDay:bidDate];

            NSString *yearMonth = [DerivedNSManagedObject yearMonthFromDate:bidDate];
            record.recordId = @([recordId integerValue]);
            
            record.bidYearMonthDay = bidDateString;
            record.bidYearMonth = yearMonth;
            
            record.addendaInd = [DerivedNSManagedObject objectOrNil:item[@"addendaInd"]];
            record.address1 = [DerivedNSManagedObject objectOrNil:item[@"address1"]];
            
            record.address2 = [DerivedNSManagedObject objectOrNil:item[@"address2"]];
            record.availableFrom = [DerivedNSManagedObject objectOrNil:item[@"availableFrom"]];
            record.bidDate = [DerivedNSManagedObject objectOrNil:item[@"bidDate"]];
            record.bidSubmitTo = [DerivedNSManagedObject objectOrNil:item[@"bidSubmitTo"]];
            record.bidTimeZone = [DerivedNSManagedObject objectOrNil:item[@"bidTimeZone"]];
            record.bondBidInd = [DerivedNSManagedObject objectOrNil:item[@"bondBidInd"]];
            record.bondPaymentInd = [DerivedNSManagedObject objectOrNil:item[@"bondPaymentInd"]];
      
            record.bondPfrmInd = [DerivedNSManagedObject objectOrNil:item[@"bondPfrmInd"]];
            record.city = [DerivedNSManagedObject objectOrNil:item[@"city"]];
            record.cnProjectUrl = [DerivedNSManagedObject objectOrNil:item[@"cnProjectUrl"]];
            record.contractNbr = [DerivedNSManagedObject objectOrNil:item[@"contractNbr"]];
            record.country = [DerivedNSManagedObject objectOrNil:item[@"country"]];
            record.county = [DerivedNSManagedObject objectOrNil:item[@"county"]];
            record.currencyType = [DerivedNSManagedObject objectOrNil:item[@"currencyType"]];
            record.details = [DerivedNSManagedObject objectOrNil:item[@"details"]];
            record.dodgeNumber = [DerivedNSManagedObject objectOrNil:item[@"dodgeNumber"]];
            record.dodgeVersion = [DerivedNSManagedObject objectOrNil:item[@"dodgeVersion"]];
            record.estLow = [DerivedNSManagedObject objectOrNil:item[@"estLow"]];
            record.fipsCounty = [DerivedNSManagedObject objectOrNil:item[@"fipsCounty"]];
            record.firstPublishDate = [DerivedNSManagedObject objectOrNil:item[@"firstPublishDate"]];
            record.geoLocationType = [DerivedNSManagedObject objectOrNil:item[@"geoLocationType"]];
            record.geocodeLat = [DerivedNSManagedObject objectOrNil:item[@"geocode"][@"lat"]];
            record.geocodeLng = [DerivedNSManagedObject objectOrNil:item[@"geocode"][@"lng"]];
            record.lastPublishDate = [DerivedNSManagedObject objectOrNil:item[@"lastPublishDate"]];
            record.notes = [DerivedNSManagedObject objectOrNil:item[@"notes"]];
            record.ownerClass = [DerivedNSManagedObject objectOrNil:item[@"ownerClass"]];
            record.planInd = [DerivedNSManagedObject objectOrNil:item[@"planInd"]];
            record.primaryProjectTypeId = [DerivedNSManagedObject objectOrNil:item[@"primaryProjectTypeId"]];
            record.priorPublishDate = [DerivedNSManagedObject objectOrNil:item[@"priorPublishDate"]];
            record.projDlvrySys = [DerivedNSManagedObject objectOrNil:item[@"projDlvrySys"]];
            record.projectStageId = [DerivedNSManagedObject objectOrNil:item[@"projectStageId"]];
            record.specAvailable = [DerivedNSManagedObject objectOrNil:item[@"specAvailable"]];
            record.state = [DerivedNSManagedObject objectOrNil:item[@"state"]];
            record.statusProjDlvrySys = [DerivedNSManagedObject objectOrNil:item[@"statusProjDlvrySys"]];
            record.statusText = [DerivedNSManagedObject objectOrNil:item[@"statusText"]];
            record.targetFinishDate = [DerivedNSManagedObject objectOrNil:item[@"targetFinishDate"]];
            record.targetStartDate = [DerivedNSManagedObject objectOrNil:item[@"targetStartDate"]];
            record.title = [DerivedNSManagedObject objectOrNil:item[@"title"]];
            record.zip5 = [DerivedNSManagedObject objectOrNil:item[@"zip5"]];
            record.zipPlus4 = [DerivedNSManagedObject objectOrNil:item[@"zipPlus4"]];
            
            [self saveContext];
        }

        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}
@end

//
//  DataManager.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DataManager.h"

#import "DB_BidSoon.h"
#import "DB_BidRecent.h"

#define kbaseUrl                @"http://lecet.dt-staging.com/api/"
#define kUrlLogin               @"LecetUsers/login"
#define kUrlBids                @"Bids/withGroup"
#define kUrlBidDetail           @"Bids/%li?"
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

- (DB_BidRecent*)saveBidItem:(NSDictionary*)item {
    NSString *recordId = item[@"id"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %@", recordId];
    
    DB_BidRecent *record = [DB_BidRecent fetchObjectForPredicate:predicate key:nil ascending:YES];
    
    if (record == nil) {
        record = [DB_BidRecent createEntity];
    }
    
    NSDictionary *project = item[@"project"];
    record.recordId = @([recordId integerValue]);;
    record.bidId = @([recordId integerValue]);
    record.addendaInd = [DerivedNSManagedObject objectOrNil:project[@"addendaInd"]];
    record.address1 = [DerivedNSManagedObject objectOrNil:project[@"address1"]];
    
    record.address2 = [DerivedNSManagedObject objectOrNil:project[@"address2"]];
    record.availableFrom = [DerivedNSManagedObject objectOrNil:project[@"availableFrom"]];
    record.bidDate = [DerivedNSManagedObject objectOrNil:project[@"bidDate"]];
    record.bidSubmitTo = [DerivedNSManagedObject objectOrNil:project[@"bidSubmitTo"]];
    record.bidTimeZone = [DerivedNSManagedObject objectOrNil:project[@"bidTimeZone"]];
    record.bondBidInd = [DerivedNSManagedObject objectOrNil:project[@"bondBidInd"]];
    record.bondPaymentInd = [DerivedNSManagedObject objectOrNil:project[@"bondPaymentInd"]];
    
    record.bondPfrmInd = [DerivedNSManagedObject objectOrNil:project[@"bondPfrmInd"]];
    record.city = [DerivedNSManagedObject objectOrNil:item[@"city"]];
    record.cnProjectUrl = [DerivedNSManagedObject objectOrNil:project[@"cnProjectUrl"]];
    record.contractNbr = [DerivedNSManagedObject objectOrNil:project[@"contractNbr"]];
    record.country = [DerivedNSManagedObject objectOrNil:project[@"country"]];
    record.county = [DerivedNSManagedObject objectOrNil:project[@"county"]];
    record.currencyType = [DerivedNSManagedObject objectOrNil:project[@"currencyType"]];
    record.details = [DerivedNSManagedObject objectOrNil:project[@"details"]];
    record.dodgeNumber = [DerivedNSManagedObject objectOrNil:project[@"dodgeNumber"]];
    record.dodgeVersion = [DerivedNSManagedObject objectOrNil:project[@"dodgeVersion"]];
    record.estLow = [DerivedNSManagedObject objectOrNil:project[@"estLow"]];
    record.fipsCounty = [DerivedNSManagedObject objectOrNil:project[@"fipsCounty"]];
    record.firstPublishDate = [DerivedNSManagedObject objectOrNil:project[@"firstPublishDate"]];
    record.geoLocationType = [DerivedNSManagedObject objectOrNil:project[@"geoLocationType"]];
    record.geocodeLat = [DerivedNSManagedObject objectOrNil:project[@"geocode"][@"lat"]];
    record.geocodeLng = [DerivedNSManagedObject objectOrNil:project[@"geocode"][@"lng"]];
    record.lastPublishDate = [DerivedNSManagedObject objectOrNil:project[@"lastPublishDate"]];
    record.notes = [DerivedNSManagedObject objectOrNil:project[@"notes"]];
    record.ownerClass = [DerivedNSManagedObject objectOrNil:project[@"ownerClass"]];
    record.planInd = [DerivedNSManagedObject objectOrNil:project[@"planInd"]];
    record.primaryProjectTypeId = [DerivedNSManagedObject objectOrNil:project[@"primaryProjectTypeId"]];
    record.priorPublishDate = [DerivedNSManagedObject objectOrNil:project[@"priorPublishDate"]];
    record.projDlvrySys = [DerivedNSManagedObject objectOrNil:project[@"projDlvrySys"]];
    record.projectStageId = [DerivedNSManagedObject objectOrNil:project[@"projectStageId"]];
    record.specAvailable = [DerivedNSManagedObject objectOrNil:project[@"specAvailable"]];
    record.state = [DerivedNSManagedObject objectOrNil:project[@"state"]];
    record.statusProjDlvrySys = [DerivedNSManagedObject objectOrNil:project[@"statusProjDlvrySys"]];
    record.statusText = [DerivedNSManagedObject objectOrNil:project[@"statusText"]];
    record.targetFinishDate = [DerivedNSManagedObject objectOrNil:project[@"targetFinishDate"]];
    record.targetStartDate = [DerivedNSManagedObject objectOrNil:project[@"targetStartDate"]];
    record.title = [DerivedNSManagedObject objectOrNil:project[@"title"]];
    record.zip5 = [DerivedNSManagedObject objectOrNil:project[@"zip5"]];
    record.zipPlus4 = [DerivedNSManagedObject objectOrNil:project[@"zipPlus4"]];
    
    NSDictionary *company = item[@"company"];
    record.companyName = [DerivedNSManagedObject objectOrNil:company[@"name"]];
    record.companyAddress1 = [DerivedNSManagedObject objectOrNil:company[@"address1"]];
    record.companyAddress2 = [DerivedNSManagedObject objectOrNil:company[@"address2"]];
    record.companyCounty = [DerivedNSManagedObject objectOrNil:company[@"county"]];
    record.companyFipsCounty = [DerivedNSManagedObject objectOrNil:company[@"fipsCounty"]];
    record.companyCity = [DerivedNSManagedObject objectOrNil:company[@"city"]];
    record.companyState = [DerivedNSManagedObject objectOrNil:company[@"state"]];
    
    record.companyZip5 = [DerivedNSManagedObject objectOrNil:company[@"zip5"]];
    record.companyZipPlus4 = [DerivedNSManagedObject objectOrNil:company[@"zipPlus4"]];
    record.companyCountry = [DerivedNSManagedObject objectOrNil:company[@"country"]];
    record.companyCkmsSiteId = [DerivedNSManagedObject objectOrNil:company[@"ckmsSiteId"]];
    record.companyCnCompanySiteUrl = [DerivedNSManagedObject objectOrNil:company[@"cnCompanysiteUrl"]];
    record.companyWwwUrl = [DerivedNSManagedObject objectOrNil:company[@"wwwUrl"]];
    record.companyDcisFactorCntctCode = [DerivedNSManagedObject objectOrNil:company[@"dcisFactorCntctCode"]];
    record.companyDcisFactorCode = [DerivedNSManagedObject objectOrNil:company[@"dcisFactorCode"]];
    record.companyId = [DerivedNSManagedObject objectOrNil:company[@"id"]];
    record.companyCreatedAt = [DerivedNSManagedObject objectOrNil:company[@"createdAt"]];
    record.companyUpdatedAt = [DerivedNSManagedObject objectOrNil:company[@"updatedAt"]];
    
    NSDictionary *contact = item[@"contact"];
    
    if (contact) {
        record.contactName = [DerivedNSManagedObject objectOrNil:contact[@"name"]];
        record.contactTitle = [DerivedNSManagedObject objectOrNil:contact[@"title"]];
        record.contactEmail = [DerivedNSManagedObject objectOrNil:contact[@"email"]];
        record.contactCkmsContactId = [DerivedNSManagedObject objectOrNil:contact[@"ckmsContactId"]];
        record.contactPhoneNumber = [DerivedNSManagedObject objectOrNil:contact[@"phoneNumber"]];
        record.contactFaxNumber = [DerivedNSManagedObject objectOrNil:contact[@"faxNumber"]];
        record.contactName = [DerivedNSManagedObject objectOrNil:contact[@"name"]];
        record.contactId = [DerivedNSManagedObject objectOrNil:contact[@"id"]];
        record.contactCompanyId = [DerivedNSManagedObject objectOrNil:contact[@"companyId"]];
    }
    
    return record;
}

- (void)bids:(NSDate *)dateFilter  success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDictionary *parameter = @{@"filter[order]":@"createDate DESC", @"filter[limit]":@"100"};
    
    NSString *url = [self url:kUrlBids  ];
    
    [self HTTP_GET:url parameters:parameter success:^(id object) {
        
        for (NSDictionary *item in object) {
            [self saveBidItem:item];
        }

        [self saveContext];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)bidDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [[self url:[NSString stringWithFormat:kUrlBidDetail, (long)recordId.integerValue]  ]stringByAppendingString:@"filter[include]=project&filter[include]=contact&filter[include]=company"];
    
    [self HTTP_GET:url parameters:nil success:^(id object) {
        
        DB_BidRecent *item = [self saveBidItem:object];
        
        [self saveContext];
        
        success(item);
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

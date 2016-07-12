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

#import "DB_Bid.h"
#import "DB_Company.h"
#import "DB_Contact.h"
#import "DB_Project.h"
#import "DB_Participant.h"
#import "DB_CompanyContact.h"

#import "AppDelegate.h"
#import "BusyViewController.h"

#define kbaseUrl                            @"http://lecet.dt-staging.com/api/"
#define kUrlLogin                           @"LecetUsers/login"
#define kUrlBidsRecentlyMade                @"Bids/"
#define kUrlBidsHappeningSoon               @"Projects?"
#define kUrlBidsRecentlyUpdated             @"Projects?"
#define kUrlBidsRecentlyAdded               @"Projects?"
#define kUrlProjectDetail                   @"Projects/%li?"
#define kUrlCompanyDetail                   @"Companies/%li?"
#define kUrlCompanyBids                     @"Bids/"
#define kUrlUserInfo                        @"LecetUsers/%li?"
#define kUrlContactInfo                     @"Contacts/%li?"
#define kUrlProjectsNear                    @"Projects/near"
#define kUrlUserProjectTrackList            @"LecetUsers/%li/projectTrackingLists"
#define kUrlUserCompanyTrackList            @"LecetUsers/%li/companyTrackingLists"
#define kUrlProjectAvailableTrackList       @"Projects/%li/availabletrackinglists"
#define kUrlCompanyAvailableTrackList       @"Companies/%li/availabletrackinglists"
#define kUrlBidCalendar                     @"Projects/bidcalendar"
#define kUrlCompanyInfo                     @"Companies/search?"
#define kUrlContactSearch                   @"Contacts/search"
#define kUrlSavedSearches                   @"LecetUsers/%li/searches"

#define kUrlParentStage                     @"ProjectParentStages"

#define kUrlProjectTrackingList             @"projectlists/%li/projects"
#define kUrlProjectTrackingListUpdates      @"projectlists/%li/updates"
#define kUrlProjectTrackingListMoveIds      @"projectlists/%li"
#define kUrlProjectAddTrackingList          @"projectlists/%li/projects/rel/%li"
#define kUrlProjectSearch                   @"Projects/search"
#define kUrlProjectHide                     @"Projects/%li/hide"
#define kUrlProjectUnhide                   @"Projects/%li/unhide"

#define kUrlCompanyTrackingList             @"companylists/%li/companies"
#define kUrlCompanyTrackingListUpdates      @"companylists/%li/updates"
#define kUrlCompanyTrackingListMoveIds      @"companylists/%li"
#define kUrlCompanyAddTrackingList          @"companylists/%li/companies/rel/%li"
#define kUrlCompanySearch                   @"Companies/search"

#define kUrlProjectGroup                    @"ProjectGroups?"
#define kUrlProjectCategory                 @"ProjectCategories?"
#define kUrlProjectTypes                    @"ProjectGroups"

#define kUrlWorkTypes                       @"WorkTypes?"
@interface DataManager()
@end
@implementation DataManager
@synthesize locationManager;


+ (id)sharedManager {
    DataManager *manager = [super sharedManager];
    if (manager.locationManager == nil) {
        manager.locationManager = [[LocationManager alloc] init];
    }
    return manager;
}

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

- (void)setHTTPHeaderBody:(AFHTTPSessionManager *)manager withData:(id)data {
    
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

#pragma mark Managed Objects Persist Routines

- (DB_Bid*)saveManageObjectBid:(NSDictionary*)bid {
    
    NSNumber *recordId = bid[@"id"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", recordId.integerValue];
    
    DB_Bid *record = [DB_Bid fetchObjectForPredicate:predicate key:nil ascending:YES];
    
    if (record == nil) {
        record = [DB_Bid createEntity];
    }
    
    record.recordId = recordId;
    record.awardInd = [NSNumber numberWithBool:[bid[@"awardInd"] boolValue]];
    record.createDate = bid[@"createDate"];
    
    NSNumber *amount = [DerivedNSManagedObject objectOrNil:bid[@"amount"]];
    if (amount != nil) {
        record.amount = [NSNumber numberWithFloat:amount.floatValue];
    }
    
    NSDictionary *project = bid[@"project"];
    if (project != nil) {
        record.relationshipProject = [self saveManageObjectProject:project];
    }
    
    NSDictionary *contact = bid[@"contact"];
    if (contact != nil) {
        record.relationshipContact = [self saveManageObjectContact:bid[@"contact"]];
    }
    
    NSDictionary *company = bid[@"company"];
    if (company != nil) {
        record.relationshipCompany = [self saveManageObjectCompany:company];
    }
    
    return record;
}

- (DB_Project*)saveManageObjectProject:(NSDictionary*)project {
    
    NSNumber *recordId = [DerivedNSManagedObject objectOrNil:project[@"id"]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", recordId.integerValue];
    
    DB_Project *record = [DB_Project fetchObjectForPredicate:predicate key:nil ascending:YES];
    
    if (record == nil) {
        record = [DB_Project createEntity];
    }
    
    record.recordId = @([recordId integerValue]);
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
    record.city = [DerivedNSManagedObject objectOrNil:project[@"city"]];
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
    
    NSDictionary *geoCode = [DerivedNSManagedObject objectOrNil:project[@"geocode"]];
    if (geoCode != nil) {
        record.geocodeLat = [DerivedNSManagedObject objectOrNil:project[@"geocode"][@"lat"]];
        record.geocodeLng = [DerivedNSManagedObject objectOrNil:project[@"geocode"][@"lng"]];
    } else {
        record.geocodeLat = @0;
        record.geocodeLng = @0;
    }
    
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
    
    if (record.bidDate != nil) {
        
        NSDate *bidDate = [DerivedNSManagedObject dateFromDateAndTimeString:record.bidDate];
        
        NSString *bidDateString = [DerivedNSManagedObject dateStringFromDateDay:bidDate];
        
        NSString *yearMonth = [DerivedNSManagedObject yearMonthFromDate:bidDate];
        
        record.bidYearMonthDay = bidDateString;
        record.bidYearMonth = yearMonth;
        
    }
    
    NSDictionary *projectStage = [DerivedNSManagedObject objectOrNil:project[@"projectStage"]];
    if (projectStage != nil) {
        record.projectStageName = [DerivedNSManagedObject objectOrNil:projectStage[@"name"]];
        record.projectStageId = [DerivedNSManagedObject objectOrNil:projectStage[@"id"]];
        record.projectStageParentId = [DerivedNSManagedObject objectOrNil:projectStage[@"parentId"]];
    }
    
    NSDictionary *primaryProjectType = [DerivedNSManagedObject objectOrNil:project[@"primaryProjectType"]];
    if (primaryProjectType != nil) {
        record.primaryProjectTypeTitle = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"title"]];
        record.primaryProjectTypeBuildingOrHighway = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"buildingOrHighway"]];
        record.primaryProjectTypeId = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"id"]];
        
        NSDictionary *category = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"projectCategory"]];
        if (category != nil) {
            record.projectCategoryId = [DerivedNSManagedObject objectOrNil:category[@"id"]];
            record.projectCategoryTitle = category[@"title"];
        }
        
        NSDictionary *projectGroup = [DerivedNSManagedObject objectOrNil:category[@"projectGroup"]];
        if (projectGroup != nil) {
            record.projectGroupId = [DerivedNSManagedObject objectOrNil:projectGroup[@"id"]];
            record.projectGroupTitle = [DerivedNSManagedObject objectOrNil:projectGroup[@"title"]];
        }
    }
    
    NSDictionary *bids = project[@"bids"];
    if (bids != nil) {
        for (NSDictionary *bidItem in bids) {
            [self saveManageObjectBid:bidItem].relationshipProject = record;
        }
    }
    
    NSDictionary *participants = project[@"contacts"];
    if (participants != nil) {
        for (NSDictionary *participant in participants) {
            [self saveManageObjectParticipant:participant].relationshipProject = record;
        }
    }
    
    return record;
}

- (DB_Contact*)saveManageObjectContact:(NSDictionary*)contact {
    
    NSNumber *recordId = contact[@"id"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", recordId.integerValue];
    
    DB_Contact *record = [DB_Contact fetchObjectForPredicate:predicate key:nil ascending:YES];
    
    if (record == nil) {
        record = [DB_Contact createEntity];
    }

    record.recordId = recordId;
    record.name = [DerivedNSManagedObject objectOrNil:contact[@"name"]];
    record.title = [DerivedNSManagedObject objectOrNil:contact[@"title"]];
    record.email = [DerivedNSManagedObject objectOrNil:contact[@"email"]];
    record.ckmsContactId = [DerivedNSManagedObject objectOrNil:contact[@"ckmsContactId"]];
    record.phoneNumber = [DerivedNSManagedObject objectOrNil:contact[@"phoneNumber"]];
    record.faxNumber = [DerivedNSManagedObject objectOrNil:contact[@"faxNumber"]];
    record.companyId = [DerivedNSManagedObject objectOrNil:contact[@"companyId"]];
    
    return record;
}

- (DB_Company*)saveManageObjectCompany:(NSDictionary*)company {
    NSNumber *recordId = company[@"id"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", recordId.integerValue];
    
    DB_Company *record = [DB_Company fetchObjectForPredicate:predicate key:nil ascending:YES];
    
    if (record == nil) {
        record = [DB_Company createEntity];
    }
    
    record.recordId = recordId;
    record.name = [DerivedNSManagedObject objectOrNil:company[@"name"]];
    record.address1 = [DerivedNSManagedObject objectOrNil:company[@"address1"]];
    record.address2 = [DerivedNSManagedObject objectOrNil:company[@"address2"]];
    record.county = [DerivedNSManagedObject objectOrNil:company[@"county"]];
    record.fipsCounty = [DerivedNSManagedObject objectOrNil:company[@"fipsCounty"]];
    record.city = [DerivedNSManagedObject objectOrNil:company[@"city"]];
    record.state = [DerivedNSManagedObject objectOrNil:company[@"state"]];
    record.zip5 = [DerivedNSManagedObject objectOrNil:company[@"zip5"]];
    record.zipPlus4 = [DerivedNSManagedObject objectOrNil:company[@"zipPlus4"]];
    record.country = [DerivedNSManagedObject objectOrNil:company[@"country"]];
    record.ckmsSiteId = [DerivedNSManagedObject objectOrNil:company[@"ckmsSiteId"]];
    record.cnCompanysiteUrl = [DerivedNSManagedObject objectOrNil:company[@"cnCompanysiteUrl"]];
    record.wwwUrl = [DerivedNSManagedObject objectOrNil:company[@"wwwUrl"]];
    record.dcisFactorCntctCode = [DerivedNSManagedObject objectOrNil:company[@"dcisFactorCntctCode"]];
    record.dcisFactorCode = [DerivedNSManagedObject objectOrNil:company[@"dcisFactorCode"]];
    record.createdAt = [DerivedNSManagedObject objectOrNil:company[@"createdAt"]];
    record.updatedAt = [DerivedNSManagedObject objectOrNil:company[@"updatedAt"]];
    
    NSArray *contacts = company[@"contacts"];
    if (contacts != nil) {
        for (NSDictionary *item in contacts) {
            
            NSNumber *number = item[@"id"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", number.integerValue];
            
            DB_CompanyContact *itemContact = [DB_CompanyContact fetchObjectForPredicate:predicate key:nil ascending:YES];
            
            if (itemContact == nil) {
                itemContact = [DB_CompanyContact createEntity];
            }
            
            itemContact.recordId = number;
            itemContact.name = [DerivedNSManagedObject objectOrNil:item[@"name"]];
            itemContact.title = [DerivedNSManagedObject objectOrNil:item[@"title"]];
            itemContact.email = [DerivedNSManagedObject objectOrNil:item[@"email"]];
            itemContact.ckmsContactId = [DerivedNSManagedObject objectOrNil:item[@"ckmsContactId"]];
            itemContact.phoneNumber = [DerivedNSManagedObject objectOrNil:item[@"phoneNumber"]];
            itemContact.faxNumber = [DerivedNSManagedObject objectOrNil:item[@"faxNumber"]];
            itemContact.companyId = [DerivedNSManagedObject objectOrNil:item[@"companyId"]];
            itemContact.relationshipCompany = record;
        }
    }
    
    NSArray *associatedProjects = company[@"projects"];
    if (associatedProjects != nil) {
     
        for (NSDictionary *project in associatedProjects) {
            [record addRelationshipAssociatedProjectsObject:[self saveManageObjectProject:project]];
        }
    }

    return record;
}

- (DB_Participant*)saveManageObjectParticipant:(NSDictionary*)participant {

    NSNumber *recordId = participant[@"id"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", recordId.integerValue];
    DB_Participant *record = [DB_Participant fetchObjectForPredicate:predicate key:nil ascending:NO];
    
    if (record == nil) {
        record = [DB_Participant createEntity];
    }
    
    record.recordId = recordId;
    record.companyId = [DerivedNSManagedObject objectOrNil:participant[@"companyId"]];
    record.contactId =  [DerivedNSManagedObject objectOrNil:participant[@"contactId"]];
    
    NSDictionary *contactType = participant[@"contactType"];
    if (contactType != nil) {
        record.contactTypeGroup = [DerivedNSManagedObject objectOrNil:contactType[@"group"]];
    }
    
    NSDictionary *company = participant[@"company"];
    if (company != nil) {
        record.name = [DerivedNSManagedObject objectOrNil:company[@"name"]];
        record.address1 = [DerivedNSManagedObject objectOrNil:company[@"address1"]];
        record.address2 = [DerivedNSManagedObject objectOrNil:company[@"address2"]];
        record.county = [DerivedNSManagedObject objectOrNil:company[@"county"]];
        record.fipsCounty = [DerivedNSManagedObject objectOrNil:company[@"fipsCounty"]];
        record.city = [DerivedNSManagedObject objectOrNil:company[@"city"]];
        record.state = [DerivedNSManagedObject objectOrNil:company[@"state"]];
        record.zip5 = [DerivedNSManagedObject objectOrNil:company[@"zip5"]];
        record.zipPlus4 = [DerivedNSManagedObject objectOrNil:company[@"zipPlus4"]];
        record.ckmsSiteId = [DerivedNSManagedObject objectOrNil:company[@"ckmsSiteId"]];
        record.cnCompanysiteUrl = [DerivedNSManagedObject objectOrNil:company[@"cnCompanysiteUrl"]];
        record.wwwUrl = [DerivedNSManagedObject objectOrNil:company[@"wwwUrl"]];
        record.dcisFactorCntctCode = [DerivedNSManagedObject objectOrNil:company[@"dcisFactorCntctCode"]];
        record.dcisFactorCode = [DerivedNSManagedObject objectOrNil:company[@"dcisFactorCode"]];
        record.createdAt = [DerivedNSManagedObject objectOrNil:company[@"createdAt"]];
        record.county = [DerivedNSManagedObject objectOrNil:company[@"county"]];
    }
    
    return record;
}

#pragma mark - API BIDS HTTP REQUEST

- (void)bidsRecentlyMade:(NSDate *)dateFilter  success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDate *previousMonth = [DerivedNSManagedObject getDate:dateFilter daysAhead:-30];
    
    NSDictionary *parameter = @{@"filter[include][0][project][primaryProjectType][projectCategory]":@"projectGroup",
                                @"filter[include][1]":@"company",
                                @"filter[include][2]":@"contact",
                                @"filter[where][createDate][gt]":[DerivedNSManagedObject dateStringFromDateDay:previousMonth],
                                @"filter[order]":@"createDate DESC",
                                @"filter[limit]":@"100",
                                @"filter[where][rank]":@"1"};
    
    NSString *url = [self url:kUrlBidsRecentlyMade];
    
    [self HTTP_GET:url parameters:parameter success:^(id object) {
        
        NSArray *currrentRecords = [DB_Bid fetchObjectsForPredicate:nil key:nil ascending:NO];
        if (currrentRecords != nil) {
            for (DB_Bid *item in currrentRecords) {
                item.isRecentMade = [NSNumber numberWithBool:NO];
            }
        }
        for (NSDictionary *item in object) {
            
            [self saveManageObjectBid:item].isRecentMade = [NSNumber numberWithBool:YES];
            
        }

        [self saveContext];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)bidsHappeningSoon:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure {
    
    /*
     NSDictionary *filter =@{@"filter[searchFilter][biddingInNext]":[NSNumber numberWithInteger:numberOfDays], @"filter[order]":@"bidDate ASC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup" };
     */
    
    NSDate *previousMonth = [DerivedNSManagedObject getDate:[NSDate date] daysAhead:(numberOfDays)];
    
    NSDictionary *filter =@{@"filter[where][bidDate][lte]":[DerivedNSManagedObject dateStringFromDateDay:previousMonth], @"filter[where][bidDate][gte]":[DerivedNSManagedObject dateStringFromDateDay:[NSDate date]],@"filter[order]":@"firstPublishDate DESC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup", @"filter[limit]":@"250"};
    
    
    [self HTTP_GET:[self url:kUrlBidsHappeningSoon] parameters:filter success:^(id object) {
        
        NSArray *currrentRecords = [DB_Project fetchObjectsForPredicate:nil key:nil ascending:NO];
        if (currrentRecords != nil) {
            for (DB_Project *item in currrentRecords) {
                item.isHappenSoon = [NSNumber numberWithBool:NO];
            }
        }
        
        //NSDictionary *results = object[@"results"];
        NSArray *results = object;
        for (NSDictionary *item in results) {
            [self saveManageObjectProject:item].isHappenSoon = [NSNumber numberWithBool:YES];;
        }
        [self saveContext];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)bidsRecentlyAddedLimit:(NSDate*)currentDate success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDate *previousMonth = [DerivedNSManagedObject getDate:currentDate daysAhead:-30];
    
    NSDictionary *filter =@{@"filter[where][firstPublishDate][gte]":[DerivedNSManagedObject dateStringFromDateDay:previousMonth], @"filter[order]":@"firstPublishDate DESC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup", @"filter[limit]":@"250"};
    
    [self HTTP_GET:[self url:kUrlBidsRecentlyAdded] parameters:filter success:^(id object) {
        
        NSArray *currrentRecords = [DB_Project fetchObjectsForPredicate:nil key:nil ascending:NO];
        if (currrentRecords != nil) {
            for (DB_Project *item in currrentRecords) {
                item.isRecentAdded = [NSNumber numberWithBool:NO];
            }
        }
        
        NSArray *results = object;
        
        for (NSDictionary *item in results) {
            [self saveManageObjectProject:item].isRecentAdded = [NSNumber numberWithBool:YES];;
        }
        [self saveContext];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
    
}

- (void)bidsRecentlyUpdated:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure {
    /*
    NSDictionary *filter =@{@"filter[searchFilter][updatedInLast]":[NSString stringWithFormat:@"%li",(long)numberOfDays],
                            @"filter[order]":@"lastPublishDate DESC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup" };
     */
    
    NSDate *previousMonth = [DerivedNSManagedObject getDate:[NSDate date] daysAhead:-(numberOfDays)];
    
    NSDictionary *filter =@{@"filter[where][lastPublishDate][gte]":[DerivedNSManagedObject dateStringFromDateDay:previousMonth], @"filter[where][lastPublishDate][lte]":[DerivedNSManagedObject dateStringFromDateDay:[NSDate date]],@"filter[order]":@"firstPublishDate DESC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup", @"filter[limit]":@"250"};

    
    [self HTTP_GET:[self url:kUrlBidsRecentlyUpdated] parameters:filter success:^(id object) {
        
        NSArray *currrentRecords = [DB_Project fetchObjectsForPredicate:nil key:nil ascending:NO];
        if (currrentRecords != nil) {
            for (DB_Project *item in currrentRecords) {
                item.isRecentUpdate = [NSNumber numberWithBool:NO];
            }
        }
        
        //NSDictionary *results = object[@"results"];
        NSDictionary *results = object;
        for (NSDictionary *item in results) {
            [self saveManageObjectProject:item].isRecentUpdate = [NSNumber numberWithBool:YES];;
        }
        [self saveContext];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)projectsNear:(CGFloat)lat lng:(CGFloat)lng distance:(NSNumber*)distance filter:(id)filter success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDictionary *parameter = @{@"lat":[NSNumber numberWithFloat:lat], @"lng":[NSNumber numberWithFloat:lng], @"dist":distance, @"filter[include][0]":@"projectStage", @"filter[include][1][contacts]":@"company"};
    [self HTTP_GET:[self url:kUrlProjectsNear] parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)bidCalendarForYear:(NSNumber *)year month:(NSNumber *)month success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDictionary *parameter = @{@"month":month, @"year":year};
    
    [self HTTP_GET:[self url:kUrlBidCalendar] parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

#pragma mark - API DETAIL INFO HTTP REQUEST

- (void)projectDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [[self url:[NSString stringWithFormat:kUrlProjectDetail, (long)recordId.integerValue]  ]stringByAppendingString:@"filter[include][0]=bids&filter[include][1][bids]=contact&filter[include][2][bids]=company&filter[include][3]=projectStage&filter[include][4][primaryProjectType][projectCategory]=projectGroup&filter[include][5][contacts]=contactType&filter[include][6][contacts]=company"];
    
    [self HTTP_GET:url parameters:nil success:^(id object) {
        
        DB_Project *item = [self saveManageObjectProject:object];
        
        [self saveContext];
        
        success(item);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)companyDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure {
    NSDictionary *filter = @{@"filter[include][0]":@"contacts", @"filter[include][1][projects]":@"projectStage", @"filter[include][2][projects][primaryProjectType][projectCategory]":@"projectGroup"};
    [self HTTP_GET:[self url:[NSString stringWithFormat:kUrlCompanyDetail, (long)recordId.integerValue]] parameters:filter success:^(id object) {
        
        DB_Company *item = [self saveManageObjectCompany:object];
        
        [self saveContext];
        success(item);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)companyProjectBids:(NSNumber*)companyId success:(APIBlock)success failure:(APIBlock)failure {
    NSDictionary *parameter = @{@"filter[include][0][project][primaryProjectType][projectCategory]":@"projectGroup",
                                @"filter[include][1]":@"company",
                                @"filter[include][2]":@"contact",
                                @"filter[order]":@"createDate DESC",
                                @"filter[where][companyId]":companyId};
    
    NSString *url = [self url:kUrlCompanyBids];
    
    [self HTTP_GET:url parameters:parameter success:^(id object) {
        
        for (NSDictionary *item in object) {
            [self saveManageObjectBid:item];
        }
        
        [self saveContext];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)userInformation:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure{
    
    NSString *url = [self url:[NSString stringWithFormat:kUrlUserInfo, (long)userId.integerValue ]];
    
    [self HTTP_GET:url parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)contactInformation:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure{
    NSString *url = [self url:[NSString stringWithFormat:kUrlContactInfo, (long)userId.integerValue ]];
    
    [self HTTP_GET:url parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)getCompanyInfo:(NSNumber *)firstCompanyId lastCompanyId:(NSNumber *)lastCompanyId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDictionary *parameter = @{@"filter[searchFilter][companyId][gte]":firstCompanyId, @"filter[searchFilter][companyId][lte]":lastCompanyId};
    
    [self HTTP_GET:[self url:kUrlCompanyInfo] parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)contactSearch:(NSMutableDictionary *)filter data:(NSMutableDictionary *)data success:(APIBlock)success failure:(APIBlock)failure {
    
    [self HTTP_GET:[self url:kUrlContactSearch] parameters:filter success:^(id object) {
        
        data[SEARCH_RESULT_CONTACT] = (id)[object mutableCopy];
        
        success(data);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)savedSearches:(NSMutableDictionary *)data success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];

    NSString *url = [NSString stringWithFormat:kUrlSavedSearches,(long)userId.integerValue ];
    
    NSMutableArray *project = [[NSMutableArray alloc] init];
    NSMutableArray *company = [[NSMutableArray alloc] init];
    data[SEARCH_RESULT_SAVED_PROJECT] = project;
    data[SEARCH_RESULT_SAVED_COMPANY] = company;
 
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        
        for (NSDictionary *item in object) {
            
            if ([item[@"modelName"] isEqualToString:@"Project"]) {
                [project addObject:item];
            } else if ([item[@"modelName"] isEqualToString:@"Company"]) {
                [company addObject:item];
            }
            
        }
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)parentStage:(APIBlock)success failure:(APIBlock)failure {

    [self HTTP_GET:[self url:kUrlParentStage] parameters:@{@"filter[include]":@"stages"} success:^(id object) {
        
        success(object);
        
    } failure:^(id object) {
    
        failure(object);
        
    } authenticated:YES];
    
}

#pragma mark - PROJECT TRACK LISTS HTTP REQUEST

- (void)userProjectTrackingList:(NSNumber *)userId success:(APIBlock)success failure:(APIBlock)failure {
  
    NSString *url = [NSString stringWithFormat:kUrlUserProjectTrackList, (long)userId.integerValue];
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)projectAvailableTrackingList:(NSNumber *)recordId success:(APIBlock)success failure:(APIBlock)failure {
    NSString *url = [NSString stringWithFormat:kUrlProjectAvailableTrackList, (long)recordId.integerValue];
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)projectTrackingList:(NSNumber *)trackId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDictionary *parameter = @{@"filter[include][0][primaryProjectType][projectCategory]":@"projectGroup",@"filter[include]":@"updates"};
    
    NSString *url = [NSString stringWithFormat:kUrlProjectTrackingList, (long)trackId.integerValue];
    [self HTTP_GET:[self url:url] parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)projectTrackingListUpdates:(NSNumber *)trackId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [NSString stringWithFormat:kUrlProjectTrackingListUpdates, (long)trackId.integerValue];
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)projectTrackingMoveIds:(NSNumber *)trackId recordIds:(NSDictionary*)track success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [NSString stringWithFormat:kUrlProjectTrackingListMoveIds, (long)trackId.integerValue];
    [self HTTP_PUT_BODY:[self url:url] parameters:track success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)projectAddTrackingList:(NSNumber *)trackId recordId:(NSNumber *)recordId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [NSString stringWithFormat:kUrlProjectAddTrackingList, (long)trackId.integerValue, (long)recordId.integerValue];
    [self HTTP_PUT:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)projectSearch:(NSMutableDictionary *)filter data:(NSMutableDictionary *)data success:(APIBlock)success failure:(APIBlock)failure {

    [self HTTP_GET:[self url:kUrlProjectSearch] parameters:filter success:^(id object) {
    
        data[SEARCH_RESULT_PROJECT] = (id)[object mutableCopy];
        
        success(data);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)hideProject:(NSNumber *)recordId success:(APIBlock)success failure:(APIBlock)failure {

    NSString *url = [NSString stringWithFormat:kUrlProjectHide, (long)recordId.integerValue ];
    [self HTTP_PUT:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)unhideProject:(NSNumber *)recordId success:(APIBlock)success failure:(APIBlock)failure {

    NSString *url = [NSString stringWithFormat:kUrlProjectUnhide, (long)recordId.integerValue ];
    [self HTTP_PUT:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

#pragma mark - COMPANY TRACK LISTS HTTP REQUEST

- (void)userCompanyTrackingList:(NSNumber *)userId success:(APIBlock)success failure:(APIBlock)failure {

    NSString *url = [NSString stringWithFormat:kUrlUserCompanyTrackList, (long)userId.integerValue];
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)companyAvailableTrackingList:(NSNumber *)recordId success:(APIBlock)success failure:(APIBlock)failure {
    NSString *url = [NSString stringWithFormat:kUrlCompanyAvailableTrackList, (long)recordId.integerValue];
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)companyTrackingList:(NSNumber *)trackId success:(APIBlock)success failure:(APIBlock)failure {
   
    NSString *url = [NSString stringWithFormat:kUrlCompanyTrackingList, (long)trackId.integerValue];
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)companyTrackingListUpdates:(NSNumber *)trackId success:(APIBlock)success failure:(APIBlock)failure {

    NSString *url = [NSString stringWithFormat:kUrlCompanyTrackingListUpdates, (long)trackId.integerValue];
    NSDictionary *filter = @{@"filter[order]":@"updatedAt DESC"};
    [self HTTP_GET:[self url:url] parameters:filter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)companyTrackingMoveIds:(NSNumber *)trackId recordIds:(NSDictionary*)track success:(APIBlock)success failure:(APIBlock)failure {

    NSString *url = [NSString stringWithFormat:kUrlCompanyTrackingListMoveIds, (long)trackId.integerValue];
    [self HTTP_PUT_BODY:[self url:url] parameters:track success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)companyAddTrackingList:(NSNumber *)trackId recordId:(NSNumber *)recordId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [NSString stringWithFormat:kUrlCompanyAddTrackingList, (long)trackId.integerValue, (long)recordId.integerValue];
    [self HTTP_PUT:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)companySearch:(NSMutableDictionary *)filter data:(NSMutableDictionary *)data success:(APIBlock)success failure:(APIBlock)failure {
    
    [self HTTP_GET:[self url:kUrlCompanySearch] parameters:filter success:^(id object) {
        
        data[SEARCH_RESULT_COMPANY] = (id)[object mutableCopy];
        
        success(data);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

#pragma mark - PROJECT GROUP HTTP REQUEST

- (void)projectGroupRequest:(APIBlock)success failure:(APIBlock)failure {
    NSDictionary *filter =@{@"filter[include]":@"projectCategories"};
    [self HTTP_GET:[self url:kUrlProjectGroup] parameters:filter success:^(id object) {
        success(object);
        
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

#pragma mark - PROJECT CATEGORY HTTP REQUEST
- (void)projectCategoryList:(APIBlock)success failure:(APIBlock)failure {

    [self HTTP_GET:[self url:kUrlProjectCategory] parameters:nil success:^(id object) {
        success(object);
        
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)projectCategoryLisByGroupID:(NSNumber *)projectGroupID success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDictionary *filter =@{@"filter[where][projectGroupId]":projectGroupID};
    
    [self HTTP_GET:[self url:kUrlProjectCategory] parameters:filter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
  
}

- (void)projectTypes:(APIBlock)success failure:(APIBlock)failure {

    [self HTTP_GET:[self url:kUrlProjectTypes] parameters:@{@"filter[include][projectCategories]":@"projectTypes"} success:^(id object) {
    
        success(object);
        
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

#pragma mark - WORK TYPES
- (void)workTypes:(APIBlock)success failure:(APIBlock)failure {
    
    [self HTTP_GET:[self url:kUrlWorkTypes] parameters:nil success:^(id object) {
        success(object);
        
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

#pragma mark - MISC FEATURE

- (void)featureNotAvailable {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Feature will be available in future sprint!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action) {
                                                            
                                                        }];
    
    [alert addAction:closeAction];
    

    [[self getActiveViewController] presentViewController:alert animated:YES completion:nil];

}

- (void)showBusyScreen {
    
    BusyViewController *screen = [BusyViewController new];
    screen.modalPresentationStyle = UIModalPresentationCustom;
    [[self getActiveViewController] presentViewController:screen animated:NO completion:nil];
    
}

- (void)promptMessage:(NSString*)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_CLOSE")
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action) {
                                                           
                                                        }];
    
    [alert addAction:closeAction];
    
    [[self getActiveViewController] presentViewController:alert animated:YES completion:nil];
    
}

- (BOOL)isDebugMode {

    NSArray *processInfo = [[NSProcessInfo processInfo] arguments];
    return [processInfo containsObject:@"IS_DEBUG"];
    
}

- (void)dismissPopup {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DISMISS_POPUP object:nil];
}

@end

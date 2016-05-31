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
#define kUrlBidsHappeningSoon               @"Projects/search"
#define kUrlBidsRecentlyUpdated             @"Projects/search"
#define kUrlBidsRecentlyAdded               @"Projects?"
#define kUrlProjectDetail                   @"Projects/%li?"
#define kUrlCompanyDetail                   @"Companies/%li?"

@interface DataManager()
@end
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
    
    NSNumber *recordId = project[@"id"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", recordId.integerValue];

    DB_Project *record = [DB_Project fetchObjectForPredicate:predicate key:nil ascending:YES];
    
    if (record == nil) {
        record = [DB_Project createEntity];
    }

    //record.isHappenSoon = [NSNumber numberWithBool:YES];
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
    
    if (record.bidDate != nil) {
        
        NSDate *bidDate = [DerivedNSManagedObject dateFromDateAndTimeString:record.bidDate];
        
        NSString *bidDateString = [DerivedNSManagedObject dateStringFromDateDay:bidDate];
        
        NSString *yearMonth = [DerivedNSManagedObject yearMonthFromDate:bidDate];
        
        record.bidYearMonthDay = bidDateString;
        record.bidYearMonth = yearMonth;

    }
    
    NSDictionary *projectStage = project[@"projectStage"];
    if (projectStage != nil) {
        record.projectStageName = projectStage[@"name"];
        record.projectStageId = projectStage[@"id"];
        record.projectStageParentId = projectStage[@"parentId"];
    }
    
    NSDictionary *primaryProjectType = project[@"primaryProjectType"];
    if (primaryProjectType != nil) {
        record.primaryProjectTypeTitle = primaryProjectType[@"title"];
        record.primaryProjectTypeBuildingOrHighway = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"buildingOrHighway"]];
        record.primaryProjectTypeId = primaryProjectType[@"id"];
        
        NSDictionary *category = primaryProjectType[@"projectCategory"];
        record.projectCategoryId = category[@"id"];
        record.projectCategoryTitle = category[@"title"];
        
        NSDictionary *projectGroup = category[@"projectGroup"];
        record.projectGroupId = projectGroup[@"id"];
        record.projectGroupTitle = projectGroup[@"title"];
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

#pragma mark - HTTP REQUEST

- (void)bidsRecentlyMade:(NSDate *)dateFilter  success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDictionary *parameter = @{@"filter[include][0][project][primaryProjectType][projectCategory]":@"projectGroup",
                                @"filter[include][1]":@"company",
                                @"filter[include][2]":@"contact",
                                @"filter[order]":@"createDate DESC",
                                @"filter[limit]":@"100"};
    
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

- (void)projectDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [[self url:[NSString stringWithFormat:kUrlProjectDetail, (long)recordId.integerValue]  ]stringByAppendingString:@"filter[include][0]=bids&filter[include][1][bids]=contact&filter[include][2][bids]=company&filter[include][3]=projectStage&filter[include][4][primaryProjectType][projectCategory]&projectGroup&filter[include][5][contacts]=contactType&filter[include][6][contacts]=company"];
    
    [self HTTP_GET:url parameters:nil success:^(id object) {
        
        DB_Project *item = [self saveManageObjectProject:object];
        
        [self saveContext];
        
        success(item);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)bidsHappeningSoon:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure{

    //NSDictionary *filter =@{@"filter[searchFilter][biddingInNext]":[NSNumber numberWithInteger:numberOfDays], @"filter[order]":@"bidDate ASC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup" };
    
    NSDictionary *filter =@{@"filter[searchFilter][biddingWithin][min]":@"2015-11-01", @"filter[searchFilter][biddingWithin][max]":@"2015-11-30",@"filter[order]":@"bidDate ASC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup" };

    [self HTTP_GET:[self url:kUrlBidsHappeningSoon] parameters:filter success:^(id object) {
        
        NSArray *currrentRecords = [DB_Project fetchObjectsForPredicate:nil key:nil ascending:NO];
        if (currrentRecords != nil) {
            for (DB_Project *item in currrentRecords) {
                item.isHappenSoon = [NSNumber numberWithBool:NO];
            }
        }
        
        NSDictionary *results = object[@"results"];
        
        for (NSDictionary *item in results) {
            [self saveManageObjectProject:item].isHappenSoon = [NSNumber numberWithBool:YES];;
        }
        [self saveContext];

        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)bidsRecentlyAddedLimit:(NSNumber*)limit success:(APIBlock)success failure:(APIBlock)failure {
    NSDictionary *filter =@{@"filter[limit]":[NSString stringWithFormat:@"%li",(long)limit.integerValue], @"filter[order]":@"firstPublishDate DESC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup"};
    
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
    NSDictionary *filter =@{@"filter[searchFilter][updatedInLast]":[NSString stringWithFormat:@"%li",(long)numberOfDays],
                            @"filter[order]":@"lastPublishDate DESC", @"filter[include]":@"projectStage", @"filter[include][primaryProjectType][projectCategory]":@"projectGroup" };
    
    [self HTTP_GET:[self url:kUrlBidsRecentlyUpdated] parameters:filter success:^(id object) {
        
        NSArray *currrentRecords = [DB_Project fetchObjectsForPredicate:nil key:nil ascending:NO];
        if (currrentRecords != nil) {
            for (DB_Project *item in currrentRecords) {
                item.isRecentUpdate = [NSNumber numberWithBool:NO];
            }
        }
        
        NSDictionary *results = object[@"results"];
        
        for (NSDictionary *item in results) {
            [self saveManageObjectProject:item].isRecentUpdate = [NSNumber numberWithBool:YES];;
        }
        [self saveContext];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)companyDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure {
    NSDictionary *filter = @{@"filter[include]":@"contacts"};
    [self HTTP_GET:[self url:[NSString stringWithFormat:kUrlCompanyDetail, recordId.integerValue]] parameters:filter success:^(id object) {
        
        DB_Company *item = [self saveManageObjectCompany:object];
        
        [self saveContext];
        success(item);
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


@end

//
//  DataManager.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DataManager.h"

#import <MessageUI/MessageUI.h>
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

#import "ProjectDetailViewController.h"

//Set kProduction = 1 (Production), 0 (Staging)

#define kbaseUrl                            [kHost stringByAppendingString:@"api/"]
#define kPasswordHash                       @"Lecet MEP"
#define kUrlLogin                           @"LecetUsers/login"
#define kUrlLoginFingerPrint                @"LecetUsers/login/fingerprint"
#define kUrlBidsRecentlyMade                @"Bids/"
#define kUrlBidsHappeningSoon               @"Projects?"
#define kUrlBidsRecentlyUpdated             @"Projects?"
#define kUrlBidsRecentlyAdded               @"Projects?"
#define kUrlProjectDetail                   @"Projects/%li?"
#define kUrlCompanyDetail                   @"Companies/%li?"
#define kUrlCompanyBids                     @"Bids/"
#define kUrlUserInfo                        @"LecetUsers/%li?"
#define kUrlHiddenProjects                  @"LecetUsers/%li?"
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
#define kUrlJurisdiction                    @"Regions/tree"
#define kUrlRecentlyViewed                  @"LecetUsers/%li/activities"
#define kUrlActivities                      @"Activities"
#define kUrlFingerPrint                     @"LecetUsers/%li/fingerprint"

#define kUrlProjectTrackingList             @"projectlists/%li/projects"
#define kUrlProjectTrackingListUpdates      @"projectlists/%li/updates"
//#define kUrlProjectTrackingListMoveIds      @"projectlists/%li"
#define kUrlProjectTrackingListMoveIds      @"projectlists/%li/syncItems"
#define kUrlProjectAddTrackingList          @"projectlists/%li/projects/rel/%li"
#define kUrlProjectSearch                   @"Projects/search"
#define kUrlProjectHide                     @"Projects/%li/hide"
#define kUrlProjectUnhide                   @"Projects/%li/unhide"
#define kUrlProjectJurisdiction             @"Projects/%li/jurisdiction"

#define kUrlCompanyTrackingList             @"companylists/%li/companies"
#define kUrlCompanyTrackingListUpdates      @"companylists/%li/updates"
#define kUrlCompanyTrackingListMoveIds      @"companylists/%li/syncItems"
#define kUrlCompanyAddTrackingList          @"companylists/%li/companies/rel/%li"
#define kUrlCompanySearch                   @"Companies/search"

#define kUrlProjectGroup                    @"ProjectGroups?"
#define kUrlProjectCategory                 @"ProjectCategories?"
#define kUrlProjectTypes                    @"ProjectGroups"

#define kUrlWorkTypes                       @"WorkTypes?"

#define kNotificationKey                    @"kNotificationKey"

#define kUrlSearches                        @"Searches"
#define kUrlSearchesUpdate                  @"Searches/%li"
#define kURLChangePassword                  @"LecetUsers/%li/changePassword"

#define kUrlProjectUserNotes                @"Projects/%li/userNotes"
#define kUrlProjectUserImages               @"Projects/%li/images"
#define kUrlProjectUserImageUpload          @"Projects/%li/uploadImage"

#define kUrlNotes                           @"Notes/%li"
#define kUrlImage                           @"Images/%li"

#define kUrlPins                            @"Pins"
#define kUrlNewProject                      @"Projects/createInstance"
#define kUrlEditProject                     @"Projects/%li/editInstance"
#define kUrlNotify                          @"Projects/notify"

#define kUrlProjectType                     @"ProjectTypes/%li"
#define kUrlProjectStage                    @"ProjectStages/%li"
#define kUrlCounty                          @"Counties"

@interface DataManager()<MFMailComposeViewControllerDelegate>
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
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *parameter = @{@"email":email, @"password":password, @"deviceType": @"ios"};
    
    if (appDelegate.pushToken != nil) {
        parameter = @{@"email":email, @"password":password,@"deviceToken": appDelegate.pushToken, @"deviceType": @"ios"};
    }
    
    [[DataManager sharedManager] storeKeyChainValue:kKeychainUserIsAdmin password:@"0" serviceName:kKeychainServiceName];

    [self HTTP_POST:[self url:kUrlLogin] parameters: parameter success:^(id object) {

        NSString *token = object[@"id"];
        NSNumber *userId = object[@"userId"];
        
        [[DataManager sharedManager] storeKeyChainValue:kKeychainAccessToken password:token serviceName:kKeychainServiceName];
        
        [[DataManager sharedManager] storeKeyChainValue:kKeychainUserId password:[NSString stringWithFormat:@"%li",(long)userId.integerValue] serviceName:kKeychainServiceName];

        [self userInformation:userId success:^(id object) {
            
            NSArray *roles = object[@"roles"];
            for (NSDictionary *role in roles) {
                
                NSString *name = role[@"name"];
                if ([name isEqualToString:@"superAdmin"]) {
                    [[DataManager sharedManager] storeKeyChainValue:kKeychainUserIsAdmin password:@"1" serviceName:kKeychainServiceName];
                }

            }
            success(object);
        } failure:^(id object) {
            failure(object);
        }];
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
    
    NSNumber *rank = [DerivedNSManagedObject objectOrNil:bid[@"rank"]];
    if (rank != nil) {
        record.rank = [NSNumber numberWithFloat:rank.integerValue];;
    }
    
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
        record.isHidden = [NSNumber numberWithBool:NO];
    }
    
    record.recordId = @([recordId integerValue]);
    
    NSNumber *addendaInd = [DerivedNSManagedObject objectOrNil:project[@"addendaInd"]];
    
    if (addendaInd == nil) {
        addendaInd = @(0);
    }
    record.addendaInd = [addendaInd stringValue];
    
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
    record.estHigh = [DerivedNSManagedObject objectOrNil:project[@"estHigh"]];
    
    record.fipsCounty = [DerivedNSManagedObject objectOrNil:project[@"fipsCounty"]];
    record.firstPublishDate = [DerivedNSManagedObject objectOrNil:project[@"firstPublishDate"]];
    record.geoLocationType = [DerivedNSManagedObject objectOrNil:project[@"geoLocationType"]];
    record.unionDesignation = [DerivedNSManagedObject objectOrNil:project[@"unionDesignation"]];
    
    NSDictionary *geoCode = [DerivedNSManagedObject objectOrNil:project[@"geocode"]];
    if (geoCode != nil) {
        record.geocodeLat = [DerivedNSManagedObject objectOrNil:project[@"geocode"][@"lat"]];
        record.geocodeLng = [DerivedNSManagedObject objectOrNil:project[@"geocode"][@"lng"]];
    } else {
        record.geocodeLat = @0;
        record.geocodeLng = @0;
    }
    
    record.lastPublishDate = [DerivedNSManagedObject objectOrNil:project[@"lastPublishDate"]];
    //record.notes = [DerivedNSManagedObject objectOrNil:project[@"notes"]];
    record.ownerClass = [DerivedNSManagedObject objectOrNil:project[@"ownerClass"]];
    
    NSNumber *planInd = [DerivedNSManagedObject objectOrNil:project[@"planInd"]];
    
    if (planInd == nil) {
        planInd = @(0);
    }
    record.planInd = [planInd stringValue];
    
    record.primaryProjectTypeId = [DerivedNSManagedObject objectOrNil:project[@"primaryProjectTypeId"]];
    record.priorPublishDate = [DerivedNSManagedObject objectOrNil:project[@"priorPublishDate"]];
    record.projDlvrySys = [DerivedNSManagedObject objectOrNil:project[@"projDlvrySys"]];
    record.projectStageId = [DerivedNSManagedObject objectOrNil:project[@"projectStageId"]];
    
    NSNumber *specAvailable = [DerivedNSManagedObject objectOrNil:project[@"specAvailable"]];
    if (specAvailable == nil) {
        specAvailable = @(0);
    }
    record.specAvailable = [specAvailable stringValue];
    
    record.state = [DerivedNSManagedObject objectOrNil:project[@"state"]];
    record.statusProjDlvrySys = [DerivedNSManagedObject objectOrNil:project[@"statusProjDlvrySys"]];
    record.statusText = [DerivedNSManagedObject objectOrNil:project[@"statusText"]];
    record.targetFinishDate = [DerivedNSManagedObject objectOrNil:project[@"targetFinishDate"]];
    record.targetStartDate = [DerivedNSManagedObject objectOrNil:project[@"targetStartDate"]];
    record.title = [DerivedNSManagedObject objectOrNil:project[@"title"]];
    record.zip5 = [DerivedNSManagedObject objectOrNil:project[@"zip5"]];
    record.zipPlus4 = [DerivedNSManagedObject objectOrNil:project[@"zipPlus4"]];
    
    record.projectNotes = [DerivedNSManagedObject objectOrNil:project[@"projectNotes"]];
    record.stdIncludes = [DerivedNSManagedObject objectOrNil:project[@"stdIncludes"]];
    
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
            DB_Bid *bid = [self saveManageObjectBid:bidItem];
            bid.relationshipProject = record;
            
        }
    }
    
    NSDictionary *participants = project[@"contacts"];
    if (participants != nil) {
        for (NSDictionary *participant in participants) {
            DB_Participant *item =[self saveManageObjectParticipant:participant];
            item.relationshipProject = record;
        }
    }
    
    NSArray *userImages = project[@"images"];
    NSArray *userNotes = project[@"userNotes"];
    
    record.hasNotesImages = @( (userImages.count>0)&&(userNotes.count>0) );
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
        record.recordId = recordId;
    }
    
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

    NSArray *bids = company[@"bids"];
    if (bids) {
        for (NSDictionary *bid in bids) {
            DB_Bid *bidItem = [self saveManageObjectBid:bid];
            [record addRelationshipBidObject:bidItem];
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
    
    NSString *filter = [NSString stringWithFormat:@"{\"include\":[\"contact\",\"company\",{\"project\":{\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}}}], \"limit\":100, \"order\":\"createDate DESC\", \"where\":{\"and\":[{\"createDate\":{\"gt\":\"%@\"}},{\"rank\":1}]},\"dashboardTypes\":true}",[DerivedNSManagedObject dateStringFromDateDay:previousMonth]];
    NSString *url = [self url:kUrlBidsRecentlyMade];
    
    [self HTTP_GET:url parameters:@{@"filter":filter} success:^(id object) {
        
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
    
    NSDate *previousMonth = [DerivedNSManagedObject getDate:[NSDate date] daysAhead:(numberOfDays)];
    
    NSString *filter = [NSString stringWithFormat:@"{\"include\":[\"projectStage\", {\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}}],\"where\":{\"and\":[{\"bidDate\":{\"gte\":\"%@\"}},{\"bidDate\":{\"lte\":\"%@\"}}]},\"dashboardTypes\":true,\"limit\":250, \"order\":\"firstPublishDate DESC\"}", [DerivedNSManagedObject dateStringFromDateDay:[NSDate date]], [DerivedNSManagedObject dateStringFromDateDay:previousMonth]];
    
    [self HTTP_GET:[self url:kUrlBidsHappeningSoon] parameters:@{@"filter":filter} success:^(id object) {
        
        NSArray *currrentRecords = [DB_Project fetchObjectsForPredicate:nil key:nil ascending:YES];
        if (currrentRecords != nil) {
            for (DB_Project *item in currrentRecords) {
                item.isHappenSoon = [NSNumber numberWithBool:NO];
            }
        }
        
        NSArray *results = object;
        for (NSDictionary *item in results) {
            
            DB_Project *project = [self saveManageObjectProject:item];
            project.isHappenSoon = [NSNumber numberWithBool:YES];
            
        }
        [self saveContext];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)bidsRecentlyAddedLimit:(NSDate*)currentDate success:(APIBlock)success failure:(APIBlock)failure {
    
    NSDate *previousMonth = [DerivedNSManagedObject getDate:currentDate daysAhead:-30];
    
    NSString *filter = [NSString stringWithFormat:@"{\"include\":[\"projectStage\", {\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}}],\"where\":{\"firstPublishDate\":{\"gte\":\"%@\"}}, \"limit\":250,\"dashboardTypes\":true,\"order\":\"firstPublishDate DESC\"}", [DerivedNSManagedObject dateStringFromDateDay:previousMonth]];
    
    [self HTTP_GET:[self url:kUrlBidsRecentlyAdded] parameters:@{@"filter":filter} success:^(id object) {
        
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
    
    NSDate *previousMonth = [DerivedNSManagedObject getDate:[NSDate date] daysAhead:-(numberOfDays)];
    
    NSString *filter = [NSString stringWithFormat:@"{\"include\":[\"projectStage\", {\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}}], \"where\":{\"lastPublishDate\":{\"gte\":\"%@\"}}, \"limit\":250,\"dashboardTypes\":true,\"order\":\"firstPublishDate DESC\"}", [DerivedNSManagedObject dateStringFromDateDay:previousMonth]];

    
    [self HTTP_GET:[self url:kUrlBidsRecentlyUpdated] parameters:@{@"filter":filter} success:^(id object) {
        
        NSArray *currrentRecords = [DB_Project fetchObjectsForPredicate:nil key:nil ascending:NO];
        if (currrentRecords != nil) {
            if ([currrentRecords isKindOfClass:[NSArray class]]) {
                for (DB_Project *item in currrentRecords) {
                    if (!item.isDeleted) {
                        item.isRecentUpdate = [NSNumber numberWithBool:NO];
                    }
                }
            } else {
                NSLog(@"error");
            }
        }
        
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
    
    //NSString *allFilter = @"{\"include\":[\"userNotes\",\"images\",\"projectStage\",{\"contacts\":[\"company\"]}],\"limit\":200,\"nolimit\":false, \"order\":\"id DESC\"}";
    
    NSString *allFilter = @"{\"include\":[\"workTypes\",\"userNotes\",\"images\",\"projectStage\",{\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}},{\"contacts\":[\"company\"]}],\"limit\":200, \"order\":\"id DESC\"}";
    
    NSData *data = [allFilter dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *errorData;
    NSMutableDictionary *dictionary = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorData] mutableCopy];

    NSDictionary *filterToAdd = (NSDictionary*)filter;
    if (filter != nil) {
        [dictionary addEntriesFromDictionary:filterToAdd];
    }
    

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSDictionary *parameter = @{@"lat":[NSNumber numberWithFloat:lat], @"lng":[NSNumber numberWithFloat:lng], @"dist":distance, @"filter":jsonString};
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
    
    NSString *url = [self url:[NSString stringWithFormat:kUrlProjectDetail, (long)recordId.integerValue]];
    NSString *filter = @"{\"include\":[{\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}},\"secondaryProjectTypes\",\"projectStage\",{\"bids\":[\"company\",\"contact\"]},{\"contacts\":[\"contactType\",\"company\"]}]}";
    [self HTTP_GET:url parameters:@{@"filter":filter} success:^(id object) {
                
        DB_Project *item = [self saveManageObjectProject:object];
        
        [self saveContext];
        
        success(item);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)projectJurisdiction:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure {
  
    NSString *url = [self url:[NSString stringWithFormat:kUrlProjectJurisdiction, (long)recordId.integerValue]];
    [self HTTP_GET:url parameters:nil success:^(id object) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", recordId.integerValue];
        
        DB_Project *record = [DB_Project fetchObjectForPredicate:predicate key:nil ascending:YES];

        if (record != nil) {
            
            //record.project
        }
        
        success(object);
        
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)companyDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure {
    
    //NSString *filter = @"{\"include\":[\"contacts\",{\"projects\":{\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}}},{\"bids\":[\"company\",\"contact\",\"project\"]}]}";
    
    NSString *filter = @"{\"include\":[\"contacts\",{\"projects\":[{\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}},\"userNotes\",\"images\"]},{\"bids\":[\"company\",\"contact\",\"project\"]}]}";
    [self HTTP_GET:[self url:[NSString stringWithFormat:kUrlCompanyDetail, (long)recordId.integerValue]] parameters:@{@"filter":filter} success:^(id object) {
        
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
    NSString *filter = @"{\"include\":[\"roles\",{\"jurisdiction\":[\"regions\",\"districts\",\"locals\"]}]}";
    [self HTTP_GET:url parameters:@{@"filter":filter} success:^(id object) {
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
        data[SEARCH_RESULT_CONTACT_FILTER] = (id)filter;
        data[SEARCH_RESULT_CONTACT_URL] = (id)[self url:kUrlContactSearch];
        
        success(data);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)genericSearchUsingUrl:(NSString*)url filter:(NSMutableDictionary*)filter success:(APIBlock)success failure:(APIBlock)failure{

    [self HTTP_GET:url parameters:filter success:^(id object) {
        
        success(object);
        
    } failure:^(id object) {
        
        failure(object);
    
    } authenticated:YES];

}
- (void)savedSearches:(NSMutableDictionary *)data success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *userId =[self getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];

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

- (void)jurisdiction:(APIBlock)success failure:(APIBlock)failure {

    [self HTTP_GET:[self url:kUrlJurisdiction] parameters:nil success:^(id object) {
        
        success(object);
        
    } failure:^(id object) {
        
        failure(object);
        
    } authenticated:YES];

}

- (void)recentlyViewed:(APIBlock)success failure:(APIBlock)failure {
  
    NSString *userId =[self getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];

    NSString *url = [self url:[NSString stringWithFormat:kUrlRecentlyViewed,(long)userId.integerValue]];
                     
    [self HTTP_GET:url parameters:@{@"filter":@"{\"include\":[\"project\",\"company\"],\"where\":{\"code\":{\"inq\":[\"VIEW_PROJECT\",\"VIEW_COMPANY\"]}},\"limit\":10,\"order\":\"updatedAt DESC\"}"} success:^(id object) {
        
        success(object);
        
    } failure:^(id object) {
        
        failure(object);
        
    } authenticated:YES];

}

- (void)userActivitiesForRecordId:(NSNumber*)recordId viewType:(NSUInteger)viewType success:(APIBlock) success failure:(APIBlock)failure {
    
    NSString *url = [self url:kUrlActivities];
    
    NSString *view = viewType == 0?@"VIEW_PROJECT":@"VIEW_COMPANY";
    NSString *field = viewType == 0?@"projectId":@"companyId";
    NSDictionary *parameter = @{@"code":view, field:recordId};
    [self HTTP_POST_BODY:url parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)registerFingerPrintForSuccess:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *userId =[self getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    NSString *email =[self getKeyChainValue:kKeychainEmail serviceName:kKeychainServiceName];
    
   
    NSString *url = [self url:[NSString stringWithFormat:kUrlFingerPrint,(long)userId.integerValue]];

    NSString *hash = encryptStringUsingPassword(email, kPasswordHash);
    [self HTTP_PUT_BODY:url parameters:@{@"fingerprintHash":hash} success:^(id object) {
        
        NSDate *expirationDate = dateAdd(1);
        
        [self storeKeyChainValue:kKeychainTouchIDToken password:hash serviceName:kKeychainServiceName];
        
        [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:kKeychainTouchIDExpiration];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)loginFingerPrintForSuccess:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [self url:kUrlLoginFingerPrint];
 
    NSString *email =[self getKeyChainValue:kKeychainEmail serviceName:kKeychainServiceName];
    NSString *hash =[self getKeyChainValue:kKeychainTouchIDToken serviceName:kKeychainServiceName];
    
    [self HTTP_POST:url parameters:@{@"email":email,@"fingerprintHash":hash} success:^(id object) {
        
        NSString *token = object[@"id"];
        NSNumber *userId = object[@"userId"];
        
        [self storeKeyChainValue:kKeychainAccessToken password:token serviceName:kKeychainServiceName];
        
        [self storeKeyChainValue:kKeychainUserId password:[NSString stringWithFormat:@"%li",(long)userId.integerValue] serviceName:kKeychainServiceName];

        success(object);
        
    } failure:^(id object) {
        failure(object);
    } authenticated:NO];
   
}

- (void)updateUserInformation:(NSNumber*)userId userUpdateData:(id)paramData success:(APIBlock)success failure:(APIBlock)failure{
    
    NSString *url = [self url:[NSString stringWithFormat:kUrlUserInfo, (long)userId.integerValue ]];
    
    [self HTTP_PUT_BODY:url parameters:paramData success:^(id object)  {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (BOOL)isAdmin {
    NSString *userType =[[DataManager sharedManager] getKeyChainValue:kKeychainUserIsAdmin serviceName:kKeychainServiceName];

    return userType.integerValue == 1;
}
#pragma mark - PROJECT TRACK LISTS HTTP REQUEST

- (void)userProjectTrackingList:(NSNumber *)userId success:(APIBlock)success failure:(APIBlock)failure {
  
    NSString *url = [NSString stringWithFormat:kUrlUserProjectTrackList, (long)userId.integerValue];
    [self HTTP_GET:[self url:url] parameters:@{@"filter":@"{\"include\":[\"projects\"]}"} success:^(id object) {
        
        NSMutableArray *mutableArray = [object mutableCopy];
        
        for (int i=0; i<mutableArray.count; i++) {
            NSDictionary *item = mutableArray[i];
            NSMutableDictionary *mutableDict = [item mutableCopy];
            
            [mutableDict removeObjectForKey:@"projectIds"];
            
            NSArray *projects = mutableDict[@"projects"];
            
            NSMutableArray *newArray = [NSMutableArray new];
            for (NSDictionary *project in projects) {
                [newArray addObject:project[@"id"]];
            }
            
            mutableDict[@"projectIds"] = newArray;
            
        }
        
        
        success(mutableArray);
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
    
    //NSDictionary *parameter = @{@"filter[include][0][primaryProjectType][projectCategory]":@"projectGroup",@"filter[include]":@"updates"};
    
    NSString *filter = @"{\"include\":[\"updates\",{\"primaryProjectType\":{\"projectCategory\":\"projectGroup\"}}]}";
    NSString *url = [NSString stringWithFormat:kUrlProjectTrackingList, (long)trackId.integerValue];
    [self HTTP_GET:[self url:url] parameters:@{@"filter":filter} success:^(id object) {
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
        data[SEARCH_RESULT_PROJECT_FILTER] = (id)filter;
        data[SEARCH_RESULT_PROJECT_URL] = (id)[self url:kUrlProjectSearch];
        
        success(data);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)hideProject:(NSNumber *)recordId success:(APIBlock)success failure:(APIBlock)failure {

    NSString *url = [NSString stringWithFormat:kUrlProjectHide, (long)recordId.integerValue ];
    [self HTTP_PUT:[self url:url] parameters:nil success:^(id object) {
        DB_Project *project = [self saveManageObjectProject:object];
        project.isHidden = [NSNumber numberWithBool:YES];
        [self saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_DASHBOARD object:nil];
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)unhideProject:(NSNumber *)recordId success:(APIBlock)success failure:(APIBlock)failure {

    NSString *url = [NSString stringWithFormat:kUrlProjectUnhide, (long)recordId.integerValue ];
    [self HTTP_PUT:[self url:url] parameters:nil success:^(id object) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId == %li", recordId.integerValue];
        
        DB_Project *record = [DB_Project fetchObjectForPredicate:predicate key:nil ascending:YES];

        if (record != nil) {
            record.isHidden = [NSNumber numberWithBool:NO];
            [self saveContext];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_DASHBOARD object:nil];
        
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

#pragma mark - COMPANY TRACK LISTS HTTP REQUEST

- (void)userCompanyTrackingList:(NSNumber *)userId success:(APIBlock)success failure:(APIBlock)failure {

    NSString *url = [NSString stringWithFormat:kUrlUserCompanyTrackList, (long)userId.integerValue];
    [self HTTP_GET:[self url:url] parameters:@{@"filter":@"{\"include\":[\"companies\"]}"} success:^(id object) {
        
        NSMutableArray *mutableArray = [object mutableCopy];
        
        for (int i=0; i<mutableArray.count; i++) {
            NSDictionary *item = mutableArray[i];
            NSMutableDictionary *mutableDict = [item mutableCopy];
            
            [mutableDict removeObjectForKey:@"companyIds"];
            
            NSArray *projects = mutableDict[@"companies"];
            
            NSMutableArray *newArray = [NSMutableArray new];
            for (NSDictionary *project in projects) {
                [newArray addObject:project[@"id"]];
            }
            
            mutableDict[@"companyIds"] = newArray;
            
        }

        success(mutableArray);
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
    NSArray *ids = [DerivedNSManagedObject objectOrNil:track[@"companyIds"]];
    NSDictionary *dicTrack;
    if (ids.count > 0) {
        dicTrack = @{@"itemIds":ids};
    } else {
        dicTrack = @{@"itemIds":@[]};
    }
    
    [self HTTP_PUT_BODY:[self url:url] parameters:dicTrack success:^(id object) {
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
        data[SEARCH_RESULT_COMPANY_FILTER] = (id)filter;
        data[SEARCH_RESULT_COMPANY_URL] = (id)[self url:kUrlCompanySearch];
        
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

- (void)hiddentProjects:(APIBlock)success failure:(APIBlock)failure {

    NSString *userId =[self getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    
    NSString *url = [self url:[NSString stringWithFormat:kUrlHiddenProjects, (long)userId.integerValue ]];
    
    NSString *hiddenProjects = @"{\"include\":\"hiddenProjects\"}";
    //[self HTTP_GET:url parameters:@{@"filter[include]":@"hiddenProjects"} success:^(id object) {
    [self HTTP_GET:url parameters:@{@"filter":hiddenProjects} success:^(id object) {
        
        for (NSDictionary *item in object[@"hiddenProjects"]) {
            
            DB_Project *project = [self saveManageObjectProject:item];
            project.isHidden = [NSNumber numberWithBool:YES];
            [self saveContext];
            
        }
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


- (void)promptMessageUpdatedProject:(NSString *)message notificationPayload:(NSDictionary *)payload {

    NSNumber *recordId = nil;
    
    NSDictionary *body = payload[@"body"];
    if (body) {
        recordId = body[@"projectId"];
        
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *viewAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_VIEW")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self showProjectDetail:recordId];
                                                        }];

    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_CLOSE")
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action) {
                                                            
                                                        }];
    

    if (recordId) {
        [alert addAction:viewAction];
    }
    [alert addAction:closeAction];
    
    [[self getActiveViewController] presentViewController:alert animated:YES completion:nil];
    
}

- (void)showProjectDetail:(NSNumber *)recordID {
    if ([self isModal]) {
        [[self getActiveViewController] dismissViewControllerAnimated:NO completion:^{
            [self projectDetail:recordID success:^(id object){
                ProjectDetailViewController *detail = [ProjectDetailViewController new];
                detail.view.hidden = NO;
                [detail detailsFromProject:object];
                [[self getActiveViewController].navigationController pushViewController:detail animated:YES];
            }failure:^(id fObject){
            }];
        }];
    } else {
        [self projectDetail:recordID success:^(id object){
            ProjectDetailViewController *detail = [ProjectDetailViewController new];
            detail.view.hidden = NO;
            [detail detailsFromProject:object];
            [[self getActiveViewController].navigationController pushViewController:detail animated:YES];
        }failure:^(id fObject){
        }];
    }
}

- (BOOL)isModal {
    if ([[self getActiveViewController] presentingViewController]) {
        return YES;
    }
    else if ([[[self getActiveViewController] presentingViewController] presentedViewController] == [self getActiveViewController].navigationController) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)dismissPopup {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DISMISS_POPUP object:nil];
}

- (void)setNotification:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setObject:@(enabled) forKey:kNotificationKey];
}

- (BOOL)isNotificationEnabled {
    NSNumber *enabled = [[NSUserDefaults standardUserDefaults] objectForKey:kNotificationKey];
    
    if (enabled == nil) {
        return NO;
    } else {
        return enabled.boolValue;
    }
}

- (void)sendEmail:(NSString*)textEmail {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setMessageBody:textEmail isHTML:YES];
        [mail setToRecipients:@[]];
        
        [[self getActiveViewController] presentViewController:mail animated:YES completion:NULL];
    } else {
        [self promptMessage:@"Email settings not configured."];
    }

}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *message = @"";
    switch (result) {
        case MFMailComposeResultFailed:
            message = @"Mail failed:  An error occurred when trying to compose this email";
            break;
        default:
            message = @"An error occurred when trying to compose this email";
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    if (message.length>0) {
        [self promptMessage:message];
    }
}


- (void)copyTextToPasteBoard:(NSString*)text withMessage:(NSString *)message{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
    [self promptMessage:message];
}

- (BOOL)shouldLoginUsingTouchId {
    NSString *hash = [[DataManager sharedManager] getKeyChainValue:kKeychainTouchIDToken serviceName:kKeychainServiceName];
    
    if (hash == nil) {
        hash = @"";
    }
    NSString *str = [[TouchIDManager sharedTouchIDManager] canAuthenticate];

    return ((str.length == 0) & (hash.length > 0 ));
}

- (void)projectSaveSearch:(NSMutableDictionary *)filter data:(NSMutableDictionary *)data updateOldData:(BOOL)update success:(APIBlock)success failure:(APIBlock)failure {

    if (update) {
        
        NSString *uid = filter[@"id"];
        NSString *url = [NSString stringWithFormat:kUrlSearchesUpdate, (long)uid.integerValue];
        [filter removeObjectForKey:@"title"];
        [self HTTP_PUT_BODY:[self url:url] parameters:filter success:^(id object) {
            
            //data[SEARCH_RESULT_PROJECT] = (id)[object mutableCopy];
            //data[SEARCH_RESULT_PROJECT_FILTER] = (id)filter;
            
            data[SEARCH_RESULT_PROJECT_FILTER] = (id)[object mutableCopy];
            
            success(data);
            
        } failure:^(id object) {
            failure(object);
        } authenticated:YES];
        
    } else {
        
        [self HTTP_POST_BODY:[self url:kUrlSearches] parameters:filter success:^(id object) {
            
            //data[SEARCH_RESULT_PROJECT] = (id)[object mutableCopy];
            //data[SEARCH_RESULT_PROJECT_FILTER] = (id)filter;
            data[SEARCH_RESULT_PROJECT_FILTER] = (id)[object mutableCopy];
            
            success(data);
            
        } failure:^(id object) {
            failure(object);
        } authenticated:YES];
    }
    
    
    
}

- (void)companySaveSearch:(NSMutableDictionary *)filter data:(NSMutableDictionary *)data updateOldData:(BOOL)update success:(APIBlock)success failure:(APIBlock)failure {
    
    if (update) {
        
        NSString *uid = filter[@"id"];
        NSString *url = [NSString stringWithFormat:kUrlSearchesUpdate, (long)uid.integerValue];
        [filter removeObjectForKey:@"title"];
        
        [self HTTP_PUT_BODY:[self url:url] parameters:filter success:^(id object) {
            
            //data[SEARCH_RESULT_PROJECT] = (id)[object mutableCopy];
            //data[SEARCH_RESULT_PROJECT_FILTER] = (id)filter;
           
            data[SEARCH_RESULT_COMPANY_FILTER] = (id)[object mutableCopy];

            success(data);
            
        } failure:^(id object) {
            failure(object);
        } authenticated:YES];
        
    } else {
    
        [self HTTP_POST_BODY:[self url:kUrlSearches] parameters:filter success:^(id object) {
            
            //data[SEARCH_RESULT_PROJECT] = (id)[object mutableCopy];
            //data[SEARCH_RESULT_PROJECT_FILTER] = (id)filter;
            data[SEARCH_RESULT_COMPANY_FILTER] = (id)[object mutableCopy];

            
            success(data);
            
        } failure:^(id object) {
            failure(object);
        } authenticated:YES];
        
    }
    
}

#pragma mark - Change Password
- (void)changePassword:(NSMutableDictionary *)parameter success:(APIBlock)success failure:(APIBlock)failure{
    
    NSString *userId =[self getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    
    NSString *url = [NSString stringWithFormat:kURLChangePassword,(long)userId.integerValue];
    
    [self HTTP_PUT_BODY:[self url:url] parameters:parameter success:^(id object) {
        success(success);
    }failure:^(id object) {
        failure(object);
    }authenticated:YES];
}

#pragma mark - Project User Notes
- (void)projectUserNotes:(NSNumber *)projectID success:(APIBlock)success failure:(APIBlock)failure {
    NSString *url = [NSString stringWithFormat:kUrlProjectUserNotes, (long)projectID.integerValue];
    [self HTTP_GET:[self url:url] parameters:@{@"filter":@"{\"include\":[\"author\"]}"} success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)addProjectUserNotes:(NSNumber *)projectID parameter:(NSDictionary *)param success:(APIBlock)success failure:(APIBlock)failure {
    NSString *url = [NSString stringWithFormat:kUrlProjectUserNotes, (long)projectID.integerValue];
    [self HTTP_POST_BODY:[self url:url] parameters:param success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)updateProjectUserNotes:(NSNumber *)projectID parameter:(NSDictionary *)param success:(APIBlock)success failure:(APIBlock)failure {
    NSString *url = [NSString stringWithFormat:kUrlNotes, (long)projectID.integerValue];
    [self HTTP_PUT_BODY:[self url:url] parameters:param success:^(id object){
        success(object);
    }failure:^(id object){
        failure(object);
    }authenticated:YES];
    
}

- (void)deleteProjectUserNotes:(NSNumber *)projectID success:(APIBlock)success failure:(APIBlock)failure {
    NSString *url = [NSString stringWithFormat:kUrlNotes, (long)projectID.integerValue];
    [self HTTP_DELETE:[self url:url] parameters:nil success:^(id object){
        success(object);
    }failure:^(id object){
        failure(object);
    }authenticated:YES];
}

#pragma mark - Project Images
- (void)projectUserImages:(NSNumber *)projectID success:(APIBlock)success failure:(APIBlock)failure {
    NSString *url = [NSString stringWithFormat:kUrlProjectUserImages, (long)projectID.integerValue];
    [self HTTP_GET:[self url:url] parameters:@{@"filter":@"{\"include\":[\"user\"]}"} success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)addProjectUserImage:(NSNumber*)projectID title:(NSString*)title text:(NSString*)text image:(UIImage*)image success:(APIBlock)success failure:(APIBlock)failure {

    NSString *encodedImage = [self base64StringForImage:image];

    NSString *url = [NSString stringWithFormat:kUrlProjectUserImageUpload, (long)projectID.integerValue];

    [self HTTP_POST_BODY:[self url:url] parameters:@{@"title":title, @"text":text, @"file":encodedImage} success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (NSString *)base64StringForImage:(UIImage *)image
{
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    NSLog(@"File size is : %.2f MB",maxFileSize/1024.0f/1024.0f);
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    //    NSLog(@"compression: %f", compression);
    
    NSString *base64Image = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return base64Image;
}

- (void)updateProjectUserImage:(NSNumber *)projectID title:(NSString *)title text:(NSString *)text image:(UIImage *)image success:(APIBlock)success failure:(APIBlock)failure{
    
    /*
    CGSize imageSize = image.size;
    imageSize.width = imageSize.width * 0.6;
    imageSize.height = imageSize.height * 0.6;
    UIGraphicsBeginImageContext( imageSize );
    [image drawInRect:CGRectMake(0,0,imageSize.width,imageSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *encodedImage = [UIImageJPEGRepresentation(newImage, 0.7) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    */
    
    NSString *encodedImage = [self base64StringForImage:image];
    NSString *url = [NSString stringWithFormat:kUrlImage, (long)projectID.integerValue];
    
    [self HTTP_PUT_BODY:[self url:url] parameters:@{@"title":title, @"text":text, @"file":encodedImage} success:^(id object){
        success(object);
    }failure:^(id object){
        failure(object);
    }authenticated:YES];}

- (void)deleteProjectUserImage:(NSNumber *)projectID success:(APIBlock)success failure:(APIBlock)failure {
    NSString *url = [NSString stringWithFormat:kUrlImage, (long)projectID.integerValue];
    [self HTTP_DELETE:[self url:url] parameters:nil success:^(id object){
        success(object);
    }failure:^(id object){
        failure(object);
    }authenticated:YES];
}

#pragma mark - New Project

- (void)createPin:(CLLocation*)location projectId:(NSNumber*)projectId success:(APIBlock)success failure:(APIBlock)failure;{
    
    NSString *userId =[self getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    
    NSDictionary *parameter = @{@"geocode": @{@"lat": [NSNumber numberWithFloat:location.coordinate.latitude], @"lng":[NSNumber numberWithFloat:location.coordinate.longitude]}, @"projectId":projectId, @"userId":userId};
    [self HTTP_POST_BODY:[self url:kUrlPins] parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];

}

- (void)createProject:(NSDictionary*)project success:(APIBlock)success failure:(APIBlock)failure {
    [self HTTP_POST_BODY:[self url:kUrlNewProject] parameters:project success:^(id object) {
        [self saveManageObjectProject:object];
        [self saveContext];
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
    
}

- (void)updateProject:(NSNumber*)projectId project:(NSDictionary*)project success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [NSString stringWithFormat:kUrlEditProject, (long)projectId.integerValue];
    
    [self HTTP_PUT_BODY:[self url:url] parameters:project success:^(id object) {
        [self saveManageObjectProject:object];
        [self saveContext];
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)projectType:(NSNumber*)typeId success:(APIBlock)success failure:(APIBlock)failure {
  
    NSString *url = [NSString stringWithFormat:kUrlProjectType, (long)typeId.integerValue];
    
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)projectStage:(NSNumber*)stageId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [NSString stringWithFormat:kUrlProjectStage, (long)stageId.integerValue];
    
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)projectJuridictionId:(NSNumber*)jurisdictionId success:(APIBlock)success failure:(APIBlock)failure {
    
    NSString *url = [NSString stringWithFormat:kUrlProjectStage, (long)jurisdictionId.integerValue];
    
    [self HTTP_GET:[self url:url] parameters:nil success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)listCounties:(NSString*)code success:(APIBlock)success failure:(APIBlock)failure{
    NSString *filter = [NSString stringWithFormat:@"{\"where\":{\"state\":\"%@\"},\"order\":\"countyName\"}", code];
    NSDictionary *parameter = @{@"filter":filter};
    [self HTTP_GET:[self url:kUrlCounty] parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)findCounty:(NSString*)code success:(APIBlock)success failure:(APIBlock)failure{
    NSString *filter = [NSString stringWithFormat:@"{\"where\":{\"fipsCountyId\":\"%@\"},\"order\":\"countyName\"}", code];
    NSDictionary *parameter = @{@"filter":filter};
    [self HTTP_GET:[self url:kUrlCounty] parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)notify:(APIBlock)success failure:(APIBlock)failure {
    CLLocation *location = [self locationManager].currentLocation;
    NSDictionary *parameter = @{@"lat":[NSNumber numberWithFloat:location.coordinate.latitude], @"lng":[NSNumber numberWithFloat:location.coordinate.longitude]};
    [self HTTP_POST_BODY:[self url:kUrlNotify] parameters:parameter success:^(id object) {
        success(object);
    } failure:^(id object) {
        failure(object);
    } authenticated:YES];
}

- (void)checkForImageNotes:(NSNumber*)projectId success:(APIBlock)success failure:(APIBlock)failure {
        [[DataManager sharedManager] projectUserNotes:projectId success:^(id object) {
            
            NSArray *notes = object;
            NSInteger noteCount = notes.count;
            
            [[DataManager sharedManager] projectUserImages:projectId success:^(id object) {
                NSArray *images = object;
                NSInteger imageCount = images.count;
                success(@{@"projectId":projectId, @"count":[NSNumber numberWithInteger:noteCount + imageCount]});
            } failure:^(id object) {
                if (noteCount>0) {
                    success(@{@"projectId":projectId, @"count":[NSNumber numberWithInteger:noteCount]});
                } else {
                    failure(object);
                }
            }];

        } failure:^(id object) {
            failure(object);
        }];
    
}

@end

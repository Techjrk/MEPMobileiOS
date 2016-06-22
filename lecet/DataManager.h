//
//  DataManager.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BaseManager.h"

#import "LocationManager.h"

#define kKeychainServiceName            @"lecet_api"
#define kKeychainAccessToken            @"access_token"
#define kKeychainUserId                 @"userId"

@interface DataManager : BaseManager
//PROPERTIES
@property (strong, nonatomic) LocationManager *locationManager;

// DATE
- (NSDateComponents*)getDateComponents:(NSDate*)date;
- (NSDate*)getDateFirstDay:(NSDate*) date;
- (NSDate*)getDateLastDay:(NSDate*)date;
// API USER
- (void)userLogin:(NSString*)email password:(NSString*)password success:(APIBlock)success failure:(APIBlock)failure;

//API BIDS
- (void)bidsRecentlyMade:(NSDate*)dateFilter success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsHappeningSoon:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsRecentlyAddedLimit:(NSDate*)currentDate success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsRecentlyUpdated:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectsNear:(CGFloat)lat lng:(CGFloat)lng distance:(NSNumber*)distance filter:(id)filter success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidCalendarForYear:(NSNumber*)year month:(NSNumber*)month success:(APIBlock)success failure:(APIBlock)failure;

//API DETAIL INFO
- (void)projectDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyProjectBids:(NSNumber*)companyId success:(APIBlock)success failure:(APIBlock)failure;
- (void)userInformation:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;
- (void)contactInformation:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;
- (void)getCompanyInfo:(NSNumber*)firstCompanyId lastCompanyId:(NSNumber*)lastCompanyId success:(APIBlock)success failure:(APIBlock)failure;

//PROJECT TRACK LISTS
- (void)userProjectTrackingList:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectAvailableTrackingList:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectTrackingList:(NSNumber*)trackId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectTrackingListUpdates:(NSNumber*)trackId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectTrackingMoveIds:(NSNumber*)trackId recordIds:(NSDictionary*)track success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectAddTrackingList:(NSNumber*)trackId recordId:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;

//COMPANY TRACK LISTS
- (void)userCompanyTrackingList:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyAvailableTrackingList:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyTrackingList:(NSNumber*)trackId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyTrackingListUpdates:(NSNumber*)trackId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyTrackingMoveIds:(NSNumber*)trackId recordIds:(NSDictionary*)ids success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyAddTrackingList:(NSNumber*)trackId recordId:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;

//MISC
- (void)featureNotAvailable;
- (void)showBusyScreen;
- (void)promptMessage:(NSString*)message;
- (BOOL)isDebugMode;
- (void)dismissPopup;

@end

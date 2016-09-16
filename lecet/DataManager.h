//
//  DataManager.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BaseManager.h"

#import "LocationManager.h"

#define kProduction                         1

#if kProduction

#define kHost                               @"https://mepmobile.lecet.org/"
#define kHockeyID                           @"977079279ce743d6a7d25b89897dbbcc"

#else

#define kHost                               @"http://lecet.dt-staging.com/"
#define kHockeyID                           @"288c4a9d07b54027b04f0966a0f433e3"

#endif

#define kKeychainServiceName            @"lecet_api"
#define kKeychainAccessToken            @"access_token"
#define kKeychainUserId                 @"userId"
#define kKeychainTouchIDToken           @"kKeychainTouchIDToken"
#define kKeychainTouchIDExpiration      @"kKeychainTouchIDExpiration"
#define kKeychainEmail                  @"kKeychainEmail"
#define kUrlProjectDetailShare          @"#/project/%li"
#define kUrlCompanyDetailShare          @"#/company/%li"

@interface DataManager : BaseManager
//PROPERTIES
@property (strong, nonatomic) LocationManager *locationManager;

// DATE
- (NSDateComponents*)getDateComponents:(NSDate*)date;
- (NSDate*)getDateFirstDay:(NSDate*) date;
- (NSDate*)getDateLastDay:(NSDate*)date;
// API USER
- (void)userLogin:(NSString*)email password:(NSString*)password success:(APIBlock)success failure:(APIBlock)failure;
- (void)userActivitiesForRecordId:(NSNumber*)recordId viewType:(NSUInteger)viewType success:(APIBlock) success failure:(APIBlock)failure;
- (void)registerFingerPrintForSuccess:(APIBlock)success failure:(APIBlock)failure;
- (void)loginFingerPrintForSuccess:(APIBlock)success failure:(APIBlock)failure;


//API BIDS
- (void)bidsRecentlyMade:(NSDate*)dateFilter success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsHappeningSoon:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsRecentlyAddedLimit:(NSDate*)currentDate success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsRecentlyUpdated:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectsNear:(CGFloat)lat lng:(CGFloat)lng distance:(NSNumber*)distance filter:(id)filter success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidCalendarForYear:(NSNumber*)year month:(NSNumber*)month success:(APIBlock)success failure:(APIBlock)failure;

//API DETAIL INFO
- (void)projectDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectJurisdiction:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)userInformation:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;
- (void)contactInformation:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;
- (void)getCompanyInfo:(NSNumber*)firstCompanyId lastCompanyId:(NSNumber*)lastCompanyId success:(APIBlock)success failure:(APIBlock)failure;
- (void)contactSearch:(NSMutableDictionary*)filter data:(NSMutableDictionary*)data success:(APIBlock)success failure:(APIBlock)failure;
- (void)savedSearches:(NSMutableDictionary*)data success:(APIBlock)success failure:(APIBlock)failure;
- (void)parentStage:(APIBlock)success failure:(APIBlock)failure;
- (void)jurisdiction:(APIBlock)success failure:(APIBlock)failure;
- (void)recentlyViewed:(APIBlock)success failure:(APIBlock)failure;
- (void)updateUserInformation:(NSNumber*)userId userUpdateData:(id)paramData success:(APIBlock)success failure:(APIBlock)failure;

//PROJECT TRACK LISTS
- (void)userProjectTrackingList:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectAvailableTrackingList:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectTrackingList:(NSNumber*)trackId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectTrackingListUpdates:(NSNumber*)trackId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectTrackingMoveIds:(NSNumber*)trackId recordIds:(NSDictionary*)track success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectAddTrackingList:(NSNumber*)trackId recordId:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectSearch:(NSMutableDictionary*)filter data:(NSMutableDictionary*)data success:(APIBlock)success failure:(APIBlock)failure;
- (void)hideProject:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)unhideProject:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;

//COMPANY TRACK LISTS
- (void)userCompanyTrackingList:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyAvailableTrackingList:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyTrackingList:(NSNumber*)trackId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyTrackingListUpdates:(NSNumber*)trackId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyTrackingMoveIds:(NSNumber*)trackId recordIds:(NSDictionary*)track success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyAddTrackingList:(NSNumber*)trackId recordId:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companySearch:(NSMutableDictionary*)filter data:(NSMutableDictionary*)data success:(APIBlock)success failure:(APIBlock)failure;

//PROJECTS
- (void)projectGroupRequest:(APIBlock)success failure:(APIBlock)failure;
- (void)projectCategoryList:(APIBlock)success failure:(APIBlock)failure;
- (void)projectCategoryLisByGroupID:(NSNumber*)projectGroupID success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectTypes:(APIBlock)success failure:(APIBlock)failure;
- (void)hiddentProjects:(APIBlock)success failure:(APIBlock)failure;

//WORK TYPES
- (void)workTypes:(APIBlock)success failure:(APIBlock)failure;

//MISC
- (void)featureNotAvailable;
- (void)showBusyScreen;
- (void)promptMessage:(NSString*)message;
- (void)dismissPopup;
- (void)setNotification:(BOOL)enabled;
- (BOOL)isNotificationEnabled;
- (void)sendEmail:(NSString*)textEmail;
- (void)copyTextToPasteBoard:(NSString*)text withMessage:(NSString*)message;
- (NSString*)url:(NSString*)url;
- (BOOL)shouldLoginUsingTouchId;

//SaveSearches

- (void)projectSaveSearch:(NSMutableDictionary *)filter data:(NSMutableDictionary *)data updateOldData:(BOOL)update success:(APIBlock)success failure:(APIBlock)failure;
- (void)companySaveSearch:(NSMutableDictionary *)filter data:(NSMutableDictionary *)data updateOldData:(BOOL)update success:(APIBlock)success failure:(APIBlock)failure;

//Change Password
- (void)changePassword:(NSMutableDictionary *)parameter success:(APIBlock)success failure:(APIBlock)failure;

@end

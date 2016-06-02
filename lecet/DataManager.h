//
//  DataManager.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BaseManager.h"

#define kKeychainServiceName            @"lecet_api"
#define kKeychainAccessToken            @"access_token"
#define kKeychainUserId                 @"userId"

@interface DataManager : BaseManager
// DATE
- (NSDateComponents*)getDateComponents:(NSDate*)date;
- (NSDate*)getDateFirstDay:(NSDate*) date;
- (NSDate*)getDateLastDay:(NSDate*)date;
// API USER
- (void)userLogin:(NSString*)email password:(NSString*)password success:(APIBlock)success failure:(APIBlock)failure;

//API BIDS
- (void)bidsRecentlyMade:(NSDate*)dateFilter success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsHappeningSoon:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsRecentlyAddedLimit:(NSNumber*)limit success:(APIBlock)success failure:(APIBlock)failure;
- (void)bidsRecentlyUpdated:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;
- (void)companyProjectBids:(NSNumber*)companyId success:(APIBlock)success failure:(APIBlock)failure;
- (void)userInformation:(NSNumber*)userId success:(APIBlock)success failure:(APIBlock)failure;

//MISC
- (void)featureNotAvailable;
- (void)showBusyScreen;
- (void)promptMessage:(NSString*)message;

@end

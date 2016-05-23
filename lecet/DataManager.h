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

@interface DataManager : BaseManager
// DATE
- (NSDateComponents*)getDateComponents:(NSDate*)date;
- (NSDate*)getDateFirstDay:(NSDate*) date;
- (NSDate*)getDateLastDay:(NSDate*)date;
// API USER
- (void)userLogin:(NSString*)email password:(NSString*)password success:(APIBlock)success failure:(APIBlock)failure;

//API BIDS
- (void)bids:(NSDate*)dateFilter success:(APIBlock)success failure:(APIBlock)failure;
- (void)projectDetail:(NSNumber*)recordId success:(APIBlock)success failure:(APIBlock)failure;

//API PROJECTS
- (void)happeningSoon:(NSInteger)numberOfDays success:(APIBlock)success failure:(APIBlock)failure;

@end

//
//  HTTPManager.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AFNetworking.h"

typedef void(^APIBlock)(id object);

@interface BaseManager : NSObject

// Manager Functions
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (id)sharedManager;
- (void)saveContext;
- (void)saveContext:(BOOL)logTime;

//KEYCHAIN
- (void)storeKeyChainValue:(NSString*)userName password:(NSString*)password serviceName:(NSString*)serviceName;
- (NSString*)getKeyChainValue:(NSString*)userName serviceName:(NSString*)serviceName;
- (NSDictionary*)clientIdentity;

//OVERLOAD
- (void)changeHTTPHeader:(AFHTTPSessionManager*)manager;
- (void)setHTTPHeaderBody:(AFHTTPSessionManager*)manager withData:(id)data;
- (void)authenticate:(AFHTTPSessionManager*)manager;

//MISC
- (void)startMonitoring;
- (BOOL)connected;
- (UIViewController*)getActiveViewController;
- (void)cancellAllRequests;
- (BOOL)isDebugMode;

//HTTP
- (void)HTTP_GET:(NSString*)url parameters:(id)paramters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated;
- (void)HTTP_POST:(NSString*)url parameters:(id)paramters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated;
- (void)HTTP_POST_BODY:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated;
- (void)HTTP_PUT:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated;
- (void)HTTP_PUT_BODY:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated;
- (void)HTTP_DELETE:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated;
@end

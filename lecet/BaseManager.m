//
//  HTTPManager.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BaseManager.h"

#import "SFHFKeychainUtils.h"
#import "AFNetworking.h"

@implementation BaseManager
@synthesize managedObjectContext;

#pragma mark - MANAGER FUNCTIONS

+ (id)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)printDictionaryObjectClasses:(NSDictionary *)dictionary
{
    for (NSString *key in dictionary) {
        NSLog(@"key %@ class %@",key,[[dictionary valueForKey:key] class]);
    }
}

- (void)saveContext
{
    [self saveContext:NO];
}

- (void)saveContext:(BOOL)logTime
{
    NSDate *methodStart = [NSDate date];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = self.managedObjectContext;
    if (moc != nil)
    {
        if ([moc hasChanges] && ![moc save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    if (logTime) NSLog(@"executionTime = %f", executionTime);
}

#pragma mark - KEYCHAIN METHODS

- (void)storeKeyChainValue:(NSString*)userName password:(NSString*)password serviceName:(NSString*)serviceName {
    
    [SFHFKeychainUtils storeUsername:userName
                         andPassword:password
                      forServiceName:serviceName
                      updateExisting:YES error:nil];
    
}

- (NSString*)getKeyChainValue:(NSString*)userName serviceName:(NSString*)serviceName {
    
    NSError *error = nil;
    NSString *pwd = [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:serviceName error:&error];
    
    return error == nil? pwd: @"";
    
}

#pragma mark - HTTP METHODS AND PARAMETERS


- (void)HTTP_GET:(NSString*)url parameters:(id)paramters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self changeHTTPHeader:manager];
    
    if (authenticated) {
        [self authenticate:manager];
    }
    
    [manager GET:url parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)HTTP_POST:(NSString*)url parameters:(id)paramters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self changeHTTPHeader:manager];
    
    if (authenticated) {
        [self authenticate:manager];
    }
    
    [manager POST:url parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (void)HTTP_PUT:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self changeHTTPHeader:manager];
    
    if (authenticated) {
        [self authenticate:manager];
    }
    
    [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)HTTP_DELETE:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self changeHTTPHeader:manager];
    
    if (authenticated) {
        [self authenticate:manager];
    }
    
    [manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

#pragma mark FOR OVERLOAD
- (void)changeHTTPHeader:(AFHTTPSessionManager*)manager {}
- (NSDictionary*)clientIdentity { return nil; }
- (void)authenticate:(AFHTTPSessionManager*)manager {}

@end

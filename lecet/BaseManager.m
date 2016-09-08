//
//  HTTPManager.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BaseManager.h"

#import "SFHFKeychainUtils.h"
#import "AppDelegate.h"
#import <Foundation/NSKeyedArchiver.h>

@interface BaseManager(){
    BOOL isNoInternetShown;
}
@end
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

- (void)logURLRequest:(AFHTTPSessionManager*)manager url:(NSString*)url parameters:(NSDictionary*)parameters {
    
    if ([self isDebugMode]) {
        
        NSString *params = parameters!=nil?[[parameters description] stringByReplacingOccurrencesOfString:@"\\" withString:@""]:@"";
        
        NSLog(@"URL: %@ \nHEADERS : %@\nPARAM %@: ", url,[manager.requestSerializer.HTTPRequestHeaders description], params);
    }

}


- (void)HTTP_GET:(NSString*)url parameters:(id)paramters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated{
    
    if ([self connected]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self changeHTTPHeader:manager];
        
        if (authenticated) {
            [self authenticate:manager];
        }
        
        [self enableUserTouch:NO];
        
        [manager GET:url parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self enableUserTouch:YES];
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self enableUserTouch:YES];
            [self connectionError:error];
            
            [self logURLRequest:manager url:url parameters:paramters];

            failure(error);
        }];
    }
}

- (void)HTTP_POST:(NSString*)url parameters:(id)paramters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated {
    if ([self connected]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [self changeHTTPHeader:manager];
        
        if (authenticated) {
            [self authenticate:manager];
        }
        
        [self enableUserTouch:NO];
        
        [manager POST:url parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self enableUserTouch:YES];
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self enableUserTouch:YES];
            if (![NSStringFromClass([[self getActiveViewController]  class]) isEqualToString:@"LoginViewController"]) {
                [self connectionError:error];
            }
            
            [self logURLRequest:manager url:url parameters:paramters];

            failure(error);
        }];
    }
}

- (void)HTTP_POST_BODY:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated{
    
    if ([self connected]) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
        
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = parameters;
            
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            
            [req setHTTPBody:data];
        }
        
        if (authenticated) {
            
            NSString *accessToken = [self getKeyChainValue:kKeychainAccessToken serviceName:kKeychainServiceName];
            
            
            
            [req setValue:accessToken forHTTPHeaderField:@"Authorization"];
            
        }
        
        [self enableUserTouch:NO];
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if (error == nil) {
                [self enableUserTouch:YES];
                success(responseObject);
            } else {
                [self enableUserTouch:YES];
                [self connectionError:error];
                
                failure(responseObject);
            }
        }] resume];
        
    }
}


- (void)HTTP_PUT:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated{
    
    if ([self connected]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self changeHTTPHeader:manager];
        
        if (authenticated) {
            [self authenticate:manager];
        }
        
        [self enableUserTouch:NO];
        
        [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self enableUserTouch:YES];
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self enableUserTouch:YES];
            [self connectionError:error];
            
            [self logURLRequest:manager url:url parameters:parameters];

            failure(error);
        }];
    }
}

- (void)HTTP_PUT_BODY:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated{
    
    if ([self connected]) {
     
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:url parameters:nil error:nil];
        
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = parameters;
            
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            
            [req setHTTPBody:data];
        }
     
        if (authenticated) {
  
            NSString *accessToken = [self getKeyChainValue:kKeychainAccessToken serviceName:kKeychainServiceName];
            
            [req setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
        }
     
        [self enableUserTouch:NO];
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if (error == nil) {
                [self enableUserTouch:YES];
                success(responseObject);
            } else {
                [self enableUserTouch:YES];
                [self connectionError:error];
                
                failure(responseObject);
            }
        }] resume];
        
    }
}


- (void)HTTP_DELETE:(NSString*)url parameters:(id)parameters success:(APIBlock)success failure:(APIBlock)failure authenticated:(BOOL)authenticated{
    
    if ([self connected]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self changeHTTPHeader:manager];
        
        if (authenticated) {
            [self authenticate:manager];
        }
        
        [self enableUserTouch:NO];
        
        [manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self enableUserTouch:YES];
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self enableUserTouch:YES];
            [self connectionError:error];
            
            [self logURLRequest:manager url:url parameters:parameters];
    
            failure(error);
        }];
    }
    
}

#pragma mark FOR OVERLOAD
- (void)changeHTTPHeader:(AFHTTPSessionManager*)manager {}
- (void)setHTTPHeaderBody:(AFHTTPSessionManager*)manager withData:(id)data {}

- (NSDictionary*)clientIdentity { return nil; }
- (void)authenticate:(AFHTTPSessionManager*)manager {}

#pragma mark - MISC
- (void)startMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (BOOL)connected {
    
    BOOL isConnected = [AFNetworkReachabilityManager sharedManager].reachable;
    
    if (!isConnected) {
        [self noInternet];
    }
    return isConnected ;
}

- (UIViewController*)getActiveViewController {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    UIViewController *controller = app.navController.presentedViewController;
    if (controller == nil) {
        controller = app.navController.topViewController;
    }
    
    return controller;
}

- (void)enableUserTouch:(BOOL)enabled {
    UIViewController *controller = [self getActiveViewController];

    UIView *view = [controller.view performSelector:@selector(firstResponder)];
    
    if (view) {
        
        if ([view isKindOfClass:[UITextField class]]) {
            controller.view.userInteractionEnabled = YES;
            
        } else {
            controller.view.userInteractionEnabled = YES;
        }
    
    } else {
        controller.view.userInteractionEnabled = YES;
    }
}

-(void)cancellAllRequests {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
    
}

- (BOOL)isDebugMode {
    
    NSArray *processInfo = [[NSProcessInfo processInfo] arguments];
    return [processInfo containsObject:@"IS_DEBUG"];
    
}

- (void)noInternet {
        
    if (!isNoInternetShown) {
        isNoInternetShown = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedLanguage(@"ERROR") message:NSLocalizedLanguage(@"INTERNET_DISCONNECTED") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"BUTTON_CLOSE")
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction *action) {
                                                                isNoInternetShown = NO;
                                                            }];
        
        [alert addAction:closeAction];
        
        [[self getActiveViewController] presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)connectionError:(NSError*)error {
    
    NSHTTPURLResponse *response = [[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
    BOOL disableAutoLogout = NO;
    NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString* ErrorResponse = @"";
    NSDictionary  *dict = @{};
    
    if (data) {
        ErrorResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    
    if ([self isDebugMode]) {
        NSLog(@"%@",ErrorResponse);
    } else {
        ErrorResponse = @"";
    }

    NSDictionary *errorDict;
    
    NSInteger errorCode = response.statusCode;
    NSString *url = response.URL.absoluteString;
    NSString *responseMessage;
    
    switch (errorCode) {
        case 401: {
            
            errorDict = [DerivedNSManagedObject objectOrNil:dict[@"error"]];
            
            if (errorDict) {
                if ([DerivedNSManagedObject objectOrNil:errorDict[@"message"]]) {
                    responseMessage = [DerivedNSManagedObject objectOrNil:errorDict[@"message"]];
                    
                    if (responseMessage == nil) {
                        responseMessage = @"";
                    }

                    if (![[responseMessage uppercaseString] isEqualToString:@"AUTHORIZATION REQUIRED"]) {
                        disableAutoLogout = YES;
                    }
                } else {
                    responseMessage = [NSString stringWithFormat:@"Error Code : %li\n%@", (long)errorCode, url];
                }
            }
            
            break;
        }
        default: {
            
            errorDict = [DerivedNSManagedObject objectOrNil:dict[@"error"]];
            
            if (errorDict) {
                if ([DerivedNSManagedObject objectOrNil:errorDict[@"message"]]) {
                    responseMessage = [DerivedNSManagedObject objectOrNil:errorDict[@"message"]];

                    if (responseMessage == nil) {
                        responseMessage = @"";
                    }
                    
                } else {
                    responseMessage = [NSString stringWithFormat:@"Error Code : %li\n%@", (long)errorCode, url];
                }
            } else {
                responseMessage = [NSString stringWithFormat:@"Error Code : %li\n%@", (long)errorCode, url];
            }
            
            break;
        
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action) {
                                                            if (errorCode == 401) {
                                                                if (!disableAutoLogout) {
                                                                    
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UNAUTHORIZED object:nil];
                                                                    
                                                                }
                                                                
                                                            }
                                                        }];
    
    [alert addAction:closeAction];
    
    
    [[self getActiveViewController] presentViewController:alert animated:YES completion:nil];
    
}


@end

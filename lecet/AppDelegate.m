//
//  AppDelegate.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LandingViewController.h"
#import "GoogleAnalytics/Library/GAI.h"
#import <DataManagerSDK/DataManager.h>

@import HockeySDK;

@interface AppDelegate (){
    BOOL isCheckingNotification;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[DataManager sharedManager] setIsLogged:NO];
    [[DataManager sharedManager] setApplication:[UIApplication sharedApplication]];
    
    isCheckingNotification = NO;
 
    [[DataManager sharedManager] managedObjectContext];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationGPSLocation:) name:NOTIFICATION_GPS_LOCATION object:nil];

    [[GAManager sharedManager] initializeTacker];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyID];
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] setDisableUpdateManager:YES];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator
     authenticateInstallation];

    [[DataManager sharedManager] startMonitoring];

    // Handle Push Configuration
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    id vc = [LandingViewController new];
    
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navigationViewController setNavigationBarHidden:YES];
    navigationViewController.navigationBar.translucent = NO;
    
    self.window.rootViewController = navigationViewController;
    self.navController = navigationViewController;
    [self.window makeKeyAndVisible];
  
    NSString *accessToken = [[DataManager sharedManager] getKeyChainValue:kKeychainAccessToken serviceName:kKeychainServiceName];
    
    if (accessToken == nil) {
        accessToken = @"";
    }

    if (accessToken.length>0) {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notification) {
            NSDictionary *body = notification[@"body"];
            if (body) {
                NSNumber *recordId = body[@"projectId"];
                if (recordId) {
                    self.notificationPayloadRecordID = recordId;
                }
            }
        }
    }
    
    NSDictionary *activityDic = [launchOptions objectForKey:UIApplicationLaunchOptionsUserActivityDictionaryKey];
    if (activityDic) {
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName:STOP_SHUTTER object:nil];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_BECOME_ACTIVE object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RESTART_SHUTTER object:nil];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //completionHandler(UIBackgroundFetchResultNewData);
    [self checkForNotifications:completionHandler];
}

- (void)NotificationGPSLocation:(NSNotification*)notification {
    if ([[DataManager sharedManager] isLogged]) {
        [self checkForNotifications:nil];
    }
}

- (UINavigationController*)navigationController {
    return self.navController;
}

- (void)checkForNotifications:(void (^)(UIBackgroundFetchResult))completionHandler {
    if([[DataManager sharedManager] locationManager].currentStatus == kCLAuthorizationStatusAuthorizedAlways) {

        BOOL isLogin = NO;
        NSString *isLoginPersisted = [[DataManager sharedManager] getKeyChainValue:kKeychainAccessToken serviceName:kKeychainServiceName];
        if (isLoginPersisted != nil & isLoginPersisted.length>0) {
            
            isLogin = YES;
            
        }

        if (isLogin) {
            if ([[DataManager sharedManager] hasInternet]) {
                if (!isCheckingNotification) {
                    isCheckingNotification = YES;
                    
                    [[DataManager sharedManager] notify:^(id object) {
                        
                        isCheckingNotification = NO;
                        
                        if (completionHandler) {
                            completionHandler(UIBackgroundFetchResultNewData);
                        }
                    } failure:^(id object) {
                        isCheckingNotification = NO;
                        if (completionHandler) {
                            completionHandler(UIBackgroundFetchResultNewData);
                        }
                    }];
                }
            }
        }
        
        
    }
}

#pragma mark - Push Notification

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    self.pushToken = [NSString stringWithFormat:@"%@", deviceToken];
    
    self.pushToken = [self.pushToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.pushToken = [self.pushToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    self.pushToken = [self.pushToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
}

- (NSString*)addComma:(NSString*)string {
    
    if (string != nil) {
        return @", ";
    }

    return @"";
}

// Handle your remote RemoteNotification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    if ([[DataManager sharedManager] isLogged]) {
        NSDictionary *aps = userInfo[@"aps"];
        if (application.applicationState == UIApplicationStateActive ) {
            id payLoad = aps[@"alert"];
            
            NSString *message = @"";
            if ([payLoad isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *alert = aps[@"alert"];
                NSDictionary *body = alert[@"body"];
                
                NSString *type = body[@"type"];
                
                NSString *title = alert[@"title"];
                NSString *detail = @"";
                
                if (![type isEqualToString:@"updatedProject"]) {
                    detail = body[@"text"];
                }
                
                NSString *address = @"";
                
                NSString *address1 = [DerivedNSManagedObject objectOrNil:body[@"address1"]];
                NSString *address2 = [DerivedNSManagedObject objectOrNil:body[@"address2"]];
                NSString *city = [DerivedNSManagedObject objectOrNil:body[@"city"]];
                NSString *state = [DerivedNSManagedObject objectOrNil:body[@"state"]];
                NSString *zip = [DerivedNSManagedObject objectOrNil:body[@"zip5"]];
                
                if ( address1!= nil) {
                    
                    address = [[address stringByAppendingString:address1] stringByAppendingString:@" "];
                    address = [address stringByAppendingString:[self addComma:address2]];
                }
                
                
                if (address2 != nil) {
                    address = [[address stringByAppendingString:address2] stringByAppendingString:@" "];
                    address = [address stringByAppendingString:[self addComma:city]];
                }
                
                if (city != nil) {
                    address = [[address stringByAppendingString:city] stringByAppendingString:@" "];
                    address = [address stringByAppendingString:[self addComma:state]];
                }
                
                if (state != nil) {
                    address = [[address stringByAppendingString:state] stringByAppendingString:@" "];
                    address = [address stringByAppendingString:[self addComma:zip]];
                    
                }
                
                if (zip != nil) {
                    address = [address stringByAppendingString:zip];
                }
                
                if (detail.length>0) {
                    title = [[title stringByAppendingString:@"\n"] stringByAppendingString:detail];
                }
                
                message = [NSString stringWithFormat:@"%@\n%@", title, address];
                
            } else {
                message = payLoad;
            }
            [[DataManager sharedManager] promptMessageUpdatedProject:message notificationPayload:userInfo];
        } else {
            
            NSDictionary *body = userInfo[@"body"];
            if (body) {
                NSNumber *recordId = body[@"projectId"];
                if (recordId) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_PROJECT object:recordId];
                }
            }
            
        }
    }
   
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    //[self updateUserActivityState:userActivity];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    return YES;
}

@end

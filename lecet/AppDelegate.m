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
@import HockeySDK;

@interface AppDelegate (){
    BOOL isCheckingNotification;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.isLogged = NO;
    isCheckingNotification = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationGPSLocation:) name:NOTIFICATION_GPS_LOCATION object:nil];

    [[GAManager sharedManager] initializeTacker];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyID];
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] setDisableUpdateManager:YES];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator
     authenticateInstallation];

    [[DataManager sharedManager] startMonitoring];

    [[DataManager sharedManager] setManagedObjectContext:self.managedObjectContext];
    
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
  
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
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
    if (self.isLogged) {
        [self checkForNotifications:nil];
    }
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.domandtom.BCG" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)modelURL {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LECET" withExtension:@"momd"];
    return modelURL;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [self modelURL];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BCG.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
#if !(TARGET_OS_EMBEDDED)  // This will work for Mac or Simulator but excludes physical iOS devices
    // @(1) is NSSQLiteStoreType
    NSURL *modelURL = [self modelURL];
    [self createCoreDataDebugProjectWithType:@(1) storeUrl:[storeURL absoluteString] modelFilePath:[modelURL absoluteString]];
#endif
    
    return _persistentStoreCoordinator;
}

#if !(TARGET_OS_EMBEDDED)  // This will work for Mac or Simulator but excludes physical iOS devices
- (void) createCoreDataDebugProjectWithType: (NSNumber*) storeFormat storeUrl:(NSString*) storeURL modelFilePath:(NSString*) modelFilePath {
    NSDictionary* project = @{
                              @"storeFilePath": storeURL,
                              @"storeFormat" : storeFormat,
                              @"modelFilePath": modelFilePath,
                              @"v" : @(1)
                              };
    
    NSString* projectFile = [NSString stringWithFormat:@"/tmp/%@.cdp", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]];
    
    [project writeToFile:projectFile atomically:YES];
    
    //    NSLog(@"project file: %@",projectFile);
    
}
#endif

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
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
   
    if (self.isLogged) {
        if (application.applicationState == UIApplicationStateActive ) {
            NSDictionary *aps = userInfo[@"aps"];
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
            [[DataManager sharedManager] showProjectDetail:[NSNumber numberWithInt:263793]];
        }
    }
   
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

@end

//
//  IntentHandler.m
//  ProjectNearMe
//
//  Created by Harry Herrys Camigla on 7/25/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "IntentHandler.h"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

#import <DataManagerSDK/DataManager.h>

@interface IntentHandler () <INSearchForMessagesIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.

    [[DataManager sharedManager] setForceConnect:YES];
    
    return self;
}

#pragma mark - INSearchForMessagesIntentHandling

- (void)handleSearchForMessages:(INSearchForMessagesIntent *)intent completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {

    [self projectNearMe:intent completion:completion];
    
}


#pragma mark - Siri MEP 


- (void)projectNearMe:(INSearchForMessagesIntent *)intenet completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSearchForMessagesIntent class])];
    INSearchForMessagesIntentResponse *response = [[INSearchForMessagesIntentResponse alloc] initWithCode:INSearchForMessagesIntentResponseCodeSuccess userActivity:userActivity];

    NSString *lat = [[DataManager sharedManager] getKeyChainValue:kKeychainLocationLat serviceName:kKeychainServiceName];
    
    NSString *lng = [[DataManager sharedManager] getKeyChainValue:kKeychainLocationLng serviceName:kKeychainServiceName];
    
    float floatLat = 0;
    float floatLng = 0;
    
    if (lat) {
        floatLat = [lat floatValue];
    }
    
    if (lng) {
        floatLng = [lng floatValue];
    }
    
    [[DataManager sharedManager] projectsNear:floatLat lng:floatLng distance:@(5) filter:nil success:^(id object) {
        
        
        response.messages = @[[[INMessage alloc]
                               initWithIdentifier:@"identifier"
                               content:@"I am so excited about SiriKit Lecet!"
                               dateSent:[NSDate date]
                               sender:[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"sarah@example.com" type:INPersonHandleTypeEmailAddress] nameComponents:nil displayName:@"Sarah" image:nil contactIdentifier:nil customIdentifier:nil]
                               recipients:@[[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"+1-415-555-5555" type:INPersonHandleTypePhoneNumber] nameComponents:nil displayName:@"John" image:nil contactIdentifier:nil customIdentifier:nil]]
                               ]];
        
        completion(response);
        
    } failure:^(id object) {
        
        response.messages = @[[[INMessage alloc]
                               initWithIdentifier:@"identifier"
                               content:@"Error!"
                               dateSent:[NSDate date]
                               sender:[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"sarah@example.com" type:INPersonHandleTypeEmailAddress] nameComponents:nil displayName:@"Sarah" image:nil contactIdentifier:nil customIdentifier:nil]
                               recipients:@[[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"+1-415-555-5555" type:INPersonHandleTypePhoneNumber] nameComponents:nil displayName:@"John" image:nil contactIdentifier:nil customIdentifier:nil]]
                               ]];
        
        completion(response);
        
    }];

}

- (void)projectTrackingList:(INSearchForMessagesIntent *)intenet completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {
    
    NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    
    [[DataManager sharedManager] userProjectTrackingList:[NSNumber numberWithInteger:(long)userId.integerValue] success:^(id object) {
        
    } failure:^(id object) {
        
    }];
}


- (void)companyTrackingList:(INSearchForMessagesIntent *)intenet completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {
    
    NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    
    [[DataManager sharedManager] userCompanyTrackingList:[NSNumber numberWithInteger:(long)userId.integerValue] success:^(id object) {
        
    } failure:^(id object) {
        
    }];
}


- (void)projectsRecentlyUpdated:(INSearchForMessagesIntent *)intenet completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {
    
    [[DataManager sharedManager] bidsRecentlyUpdated:30 success:^(id object) {
        
    } failure:^(id object) {
        
    }];
}

@end

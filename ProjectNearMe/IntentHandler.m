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
   
    return self;
}

#pragma mark - INSearchForMessagesIntentHandling

- (void)handleSearchForMessages:(INSearchForMessagesIntent *)intent completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {

    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSearchForMessagesIntent class])];
    INSearchForMessagesIntentResponse *response = [[INSearchForMessagesIntentResponse alloc] initWithCode:INSearchForMessagesIntentResponseCodeSuccess userActivity:userActivity];

    [[DataManager sharedManager] setForceConnect:YES];
    [[DataManager sharedManager] projectsNear:38.9015923 lng:-77.0382126 distance:@(5) filter:nil success:^(id object) {

        NSArray *array = object;
        
        
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


@end

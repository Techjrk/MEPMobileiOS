//
//  IntentHandler.m
//  SearchMessage
//
//  Created by Harry Herrys Camigla on 8/2/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "IntentHandler.h"

#import <DataManagerSDK/DataManager.h>

@interface IntentHandler () <INSearchForMessagesIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}


#pragma mark - Generic

- (NSUserActivity *)messageUserActivity {
    
    return [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSearchForMessagesIntent class])];
}


- (INSearchForMessagesIntentResponse *)messageResponseWithCode:(INSearchForMessagesIntentResponseCode)responseCode {
    
    return [[INSearchForMessagesIntentResponse alloc] initWithCode:responseCode userActivity:[self messageUserActivity]];
}

#pragma mark - INSearchForMessagesIntentHandling

- (void)confirmSearchForMessages:(INSearchForMessagesIntent *)intent completion:(void (^)(INSearchForMessagesIntentResponse * _Nonnull))completion {
    
    completion( [self messageResponseWithCode:INSearchForMessagesIntentResponseCodeReady] );
}


- (void)handleSearchForMessages:(INSearchForMessagesIntent *)intent completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {
    
    
    INSearchForMessagesIntentResponse *response = [self messageResponseWithCode:INSearchForMessagesIntentResponseCodeSuccess];
   
    
    
    response.userActivity.userInfo = @{@"te":@"test"} ;
    
    response.messages = @[[[INMessage alloc]
                           initWithIdentifier:[[NSDate date] description]
        content:@"I am so excited about SiriKit!"
        dateSent:[NSDate date]
        sender:[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"sarah@example.com" type:INPersonHandleTypeEmailAddress] nameComponents:nil displayName:@"Sarah" image:nil contactIdentifier:nil customIdentifier:nil]
        recipients:@[[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"+1-415-555-5555" type:INPersonHandleTypePhoneNumber] nameComponents:nil displayName:@"John" image:nil contactIdentifier:nil customIdentifier:nil]]
    ]];
    
    
    
    completion(response);
}

/*
- (void)confirmSetMessageAttribute:(INSetMessageAttributeIntent *)intent completion:(void (^)(INSetMessageAttributeIntentResponse * _Nonnull))completion {
    
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSetMessageAttributeIntent class])];
    
    INSetMessageAttributeIntentResponse *response = [[INSetMessageAttributeIntentResponse alloc] initWithCode:INSetMessageAttributeIntentResponseCodeReady userActivity:activity];
    
    completion(response);
}


- (void)handleSetMessageAttribute:(INSetMessageAttributeIntent *)intent completion:(void (^)(INSetMessageAttributeIntentResponse * _Nonnull))completion {
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSetMessageAttributeIntent class])];
    
    INSetMessageAttributeIntentResponse *response = [[INSetMessageAttributeIntentResponse alloc] initWithCode:INSetMessageAttributeIntentResponseCodeSuccess userActivity:activity];

    completion(response);
    
}


- (void)handleSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse * _Nonnull))completion {
    
}
*/

- (NSUserActivity *)workOutUserActivity {
    
    return [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INStartWorkoutIntent class])];
}


- (INStartWorkoutIntentResponse *)workOutResponseWithCode:(INStartWorkoutIntentResponseCode)responseCode {
    
    return [[INStartWorkoutIntentResponse alloc] initWithCode:responseCode userActivity:[self workOutUserActivity]];
}


- (void)confirmStartWorkout:(INStartWorkoutIntent *)intent completion:(void (^)(INStartWorkoutIntentResponse * _Nonnull))completion {
    
    INStartWorkoutIntentResponse *response = [self workOutResponseWithCode:INStartWorkoutIntentResponseCodeReady];
    completion(response);
    
}

- (void)handleStartWorkout:(INStartWorkoutIntent *)intent completion:(void (^)(INStartWorkoutIntentResponse * _Nonnull))completion {
    
    INStartWorkoutIntentResponse *response = [self workOutResponseWithCode:INStartWorkoutIntentResponseCodeContinueInApp];
    response.userActivity.userInfo = @{@"intent_paramater": intent.workoutName};
   
    if (intent.workoutName) {
        [[DataManager sharedManager] storeKeyChainValue:kIntentType password:intent.workoutName.spokenPhrase serviceName:kKeychainServiceName];
    } else {
        [[DataManager sharedManager] storeKeyChainValue:kIntentType password:@"none" serviceName:kKeychainServiceName];
        
    }
    
    completion(response);
    
}



@end


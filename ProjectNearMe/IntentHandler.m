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
#import <DataManagerSDK/DerivedNSManagedObject.h>
#import <DataManagerSDK/constants.h>
#import <DataManagerSDK/DB_Project.h>


@interface IntentHandler () <INSearchForNotebookItemsIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.

    [[DataManager sharedManager] setForceConnect:YES];
    NSLog(@"%@", [intent description]);
    return self;
}

#pragma mark - INSearchForNotebookItemsIntentHandling

- (void)handleSearchForNotebookItems:(INSearchForNotebookItemsIntent *)intent completion:(void (^)(INSearchForNotebookItemsIntentResponse * _Nonnull))completion {
    
    NSString *content = intent.content;
    
    if (content) {
        
        content = [content uppercaseString];
        
        if ([content containsString:@"PROJECT NEAR"] || [content containsString:@"PROJECTS NEAR"]) {
            
            [self projectNearMe:intent completion:completion];
            
        } else if([content containsString:@"RECENTLY UPDATED"]){
        
            [self projectsRecentlyUpdated:intent completion:completion];
            
        } else if([content containsString:@"PROJECT TRACK"]) {
            
            [self projectTrackingList:intent completion:completion];
            
        } else if([content containsString:@"COMPANY TRACK"]) {
        
            [self companyTrackingList:intent completion:completion];
        
        }
    }
    
    
}


- (void)confirmSearchForNotebookItems:(INSearchForNotebookItemsIntent *)intent completion:(void (^)(INSearchForNotebookItemsIntentResponse * _Nonnull))completion {
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSearchForNotebookItemsIntent class])];
    INSearchForNotebookItemsIntentResponse *response = [[INSearchForNotebookItemsIntentResponse alloc] initWithCode:INSearchForNotebookItemsIntentResponseCodeReady userActivity:userActivity];
    
    completion(response);

}

- (void)resolveContentForSearchForNotebookItems:(INSearchForNotebookItemsIntent *)intent withCompletion:(void (^)(INStringResolutionResult * _Nonnull))completion {
    
    if (intent.content == nil) {
        INStringResolutionResult *resolution = [INStringResolutionResult confirmationRequiredWithStringToConfirm:intent.content];
        completion(resolution);
    } else {
        INStringResolutionResult *resolution = [INStringResolutionResult confirmationRequiredWithStringToConfirm:intent.content];
        completion(resolution);
    }
    
    
}

#pragma mark - Generic

- (NSUserActivity*)userActivitySearchNote {
    
    return [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSearchForNotebookItemsIntent class])];
}


- (void)responseSearchNoteCompletionError:(void (^)(INSearchForNotebookItemsIntentResponse *response))completion {
    
    INSearchForNotebookItemsIntentResponse *response = [[INSearchForNotebookItemsIntentResponse alloc] initWithCode:INSearchForNotebookItemsIntentResponseCodeFailure userActivity:[self userActivitySearchNote]];
    
    completion(response);
}


- (INSearchForNotebookItemsIntentResponse*)responseSearchNoteSuccess{
    
    return [[INSearchForNotebookItemsIntentResponse alloc] initWithCode:INSearchForNotebookItemsIntentResponseCodeSuccess userActivity:[self userActivitySearchNote]];
}

#pragma mark - Project Near Me


- (void)projectNearMe:(INSearchForNotebookItemsIntent *)intent completion:(void (^)(INSearchForNotebookItemsIntentResponse *response))completion {
    
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

        NSArray *array = [DerivedNSManagedObject objectOrNil:object[@"results"]];
        
        if (array.count>0) {
            
            NSMutableArray *taskArray = [NSMutableArray new];
            
            INSearchForNotebookItemsIntentResponse *response = [self responseSearchNoteSuccess];
            
            for (NSDictionary *item in array) {
                
                NSString *title = item[@"title"];
                INSpeakableString *str = [[INSpeakableString alloc] initWithSpokenPhrase:title];
                INTask *task = [[INTask alloc] initWithTitle:str status:INTaskStatusNotCompleted taskType:INTaskTypeCompletable spatialEventTrigger:nil temporalEventTrigger:nil createdDateComponents:nil modifiedDateComponents:nil identifier:[item[@"id"] stringValue]];
                
                [taskArray addObject:task];
            }
            
            INSpeakableString *projectNearMe = [[INSpeakableString alloc] initWithSpokenPhrase:@"Project Near Me"];
            INTaskList *taskList = [[INTaskList alloc] initWithTitle:projectNearMe tasks:taskArray groupName:nil createdDateComponents:nil modifiedDateComponents:nil identifier:nil];
            
            response.taskLists = @[taskList];
            
            completion(response);

        } else {
            [self responseSearchNoteCompletionError:completion];
        }
        
    } failure:^(id object) {
        [self responseSearchNoteCompletionError:completion];
    }];

}


- (void)projectTrackingList:(INSearchForNotebookItemsIntent *)intenet completion:(void (^)(INSearchForNotebookItemsIntentResponse *response))completion {
    
    NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    
    [[DataManager sharedManager] userProjectTrackingList:[NSNumber numberWithInteger:(long)userId.integerValue] success:^(id object) {
        
        INSearchForNotebookItemsIntentResponse *response = [self responseSearchNoteSuccess];
        
        NSArray *items = object;
        
        if (items.count>0) {
      
            NSMutableArray *taskListArray = [NSMutableArray new];
            
            for (NSDictionary *item in items) {
                
                NSMutableArray *projectArray = [NSMutableArray new];
                
                NSArray *projects = item[@"projects"];
                
                for (NSDictionary *project in projects) {
                    
                    NSString *title = project[@"title"];
                    INSpeakableString *str = [[INSpeakableString alloc] initWithSpokenPhrase:title];
                    INTask *task = [[INTask alloc] initWithTitle:str status:INTaskStatusNotCompleted taskType:INTaskTypeCompletable spatialEventTrigger:nil temporalEventTrigger:nil createdDateComponents:nil modifiedDateComponents:nil identifier:[project[@"id"] stringValue]];
                    
                    [projectArray addObject:task];
                    
                }
                
                INSpeakableString *track = [[INSpeakableString alloc] initWithSpokenPhrase:item[@"name"]];
                INTaskList *taskList = [[INTaskList alloc] initWithTitle:track tasks:projectArray groupName:nil createdDateComponents:nil modifiedDateComponents:nil identifier:[item[@"id"] stringValue]];
                
                [taskListArray addObject:taskList];
            }
            
            response.taskLists = taskListArray;
            
            completion(response);
            
        } else {
            [self responseSearchNoteCompletionError:completion];
        }
        
        
    } failure:^(id object) {
        [self responseSearchNoteCompletionError:completion];
        
    }];
}


- (void)companyTrackingList:(INSearchForNotebookItemsIntent *)intenet completion:(void (^)(INSearchForNotebookItemsIntentResponse *response))completion {
    
    NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    
    [[DataManager sharedManager] userCompanyTrackingList:[NSNumber numberWithInteger:(long)userId.integerValue] success:^(id object) {
        
        INSearchForNotebookItemsIntentResponse *response = [self responseSearchNoteSuccess];
        
        NSArray *items = object;
        
        if (items.count>0) {
            
            NSMutableArray *taskListArray = [NSMutableArray new];
            
            for (NSDictionary *item in items) {
                
                NSMutableArray *projectArray = [NSMutableArray new];
                
                NSArray *companies = item[@"companies"];
                
                for (NSDictionary *company in companies) {
                    
                    NSString *title = company[@"name"];
                    INSpeakableString *str = [[INSpeakableString alloc] initWithSpokenPhrase:title];
                    INTask *task = [[INTask alloc] initWithTitle:str status:INTaskStatusNotCompleted taskType:INTaskTypeCompletable spatialEventTrigger:nil temporalEventTrigger:nil createdDateComponents:nil modifiedDateComponents:nil identifier:[company[@"id"] stringValue]];
                    
                    [projectArray addObject:task];
                    
                }
                
                INSpeakableString *track = [[INSpeakableString alloc] initWithSpokenPhrase:item[@"name"]];
                INTaskList *taskList = [[INTaskList alloc] initWithTitle:track tasks:projectArray groupName:nil createdDateComponents:nil modifiedDateComponents:nil identifier:[item[@"id"] stringValue]];
                
                [taskListArray addObject:taskList];
            }
            
            response.taskLists = taskListArray;
            
            completion(response);
            
            
        } else {
            [self responseSearchNoteCompletionError:completion];
        }
        
    } failure:^(id object) {
        
        [self responseSearchNoteCompletionError:completion];
    }];
}


#pragma mark - Project Recently Updated

- (void)projectsRecentlyUpdated:(INSearchForNotebookItemsIntent *)intenet completion:(void (^)(INSearchForNotebookItemsIntentResponse *response))completion {
    
    [[DataManager sharedManager] bidsRecentlyUpdated:30 success:^(id object) {
        
        NSMutableArray *taskArray = [NSMutableArray new];

        INSearchForNotebookItemsIntentResponse *response = [self responseSearchNoteSuccess];

        NSArray *items = [self loadBidsRecentlyUpdated];
        
        for (DB_Project *project in items) {
            
            NSString *title = project.title;
            INSpeakableString *str = [[INSpeakableString alloc] initWithSpokenPhrase:title];
            INTask *task = [[INTask alloc] initWithTitle:str status:INTaskStatusNotCompleted taskType:INTaskTypeNotCompletable spatialEventTrigger:nil temporalEventTrigger:nil createdDateComponents:nil modifiedDateComponents:nil identifier:[project.recordId stringValue]];
            
            [taskArray addObject:task];

        }
        
        INSpeakableString *projectRecentlyUpdated = [[INSpeakableString alloc] initWithSpokenPhrase:@"Project Recently Updated"];
        INTaskList *taskList = [[INTaskList alloc] initWithTitle:projectRecentlyUpdated tasks:taskArray groupName:nil createdDateComponents:nil modifiedDateComponents:nil identifier:nil];
        
        response.taskLists = @[taskList];
        completion(response);
        
    } failure:^(id object) {
        [self responseSearchNoteCompletionError:completion];
    }];
}

- (NSArray*)loadBidsRecentlyUpdated {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRecentUpdate == YES AND isHidden == NO AND projectGroupId IN %@", kCategory];
    NSArray *bidItemsRecentlyUpdated = [[DB_Project fetchObjectsForPredicate:predicate key:@[@"lastPublishDate", @"title"] ascending:NO] mutableCopy];
    
    for (DB_Project *item in bidItemsRecentlyUpdated) {
        
        NSString *tag = [NSString stringWithFormat:@"%li", (long)item.projectGroupId.integerValue];
        
        if ([tag isEqualToString:@"103"]) {
            tag = @"102";
        }
        
        if ([tag isEqualToString:@"105"]) {
            NSString *bh = item.primaryProjectTypeBuildingOrHighway;
            if ([bh isEqualToString:@"H"]) {
                tag = @"101";
            } else {
                tag = @"102";
            }
        }
        
        item.projectGroupId = [NSNumber numberWithInteger:[tag integerValue]];
    }
    [[DataManager sharedManager] saveContext];
    
    return bidItemsRecentlyUpdated;
}

@end

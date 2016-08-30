//
//  GoogleAnalytics.m
//  lecet
//
//  Created by Harry Herrys Camigla on 8/30/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "GoogleAnalytics.h"

#import "GoogleAnalytics/Library/GAI.h"
#import "GoogleAnalytics/Library/GAIFields.h"
#import "GoogleAnalytics/Library/GAIDictionaryBuilder.h"

@interface GAManager()
@end

@implementation GAManager

+ (GAManager*)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)initializeTacker {

     [GAI sharedInstance].optOut = NO;
     [GAI sharedInstance].trackUncaughtExceptions = YES;
     [[GAI sharedInstance].logger setLogLevel:kGAILogLevelInfo];
     [GAI sharedInstance].dispatchInterval = -1;
     [[GAI sharedInstance] trackerWithTrackingId:kGAI_TRACKER_ID];
 
}

- (void)trackEventItem:(NSString*)category event:(NSString *)event action:(NSString*)action label:(NSString*)label value:(NSString*)value {
    
    NSString *screenName = [NSString stringWithFormat:@"%@ - %@", category, event];
    NSString *eventLabel = [NSString stringWithFormat:@"%@ - %@", event, label];
    
    id<GAITracker>tracker = [[GAI sharedInstance] defaultTracker];
    GAIDictionaryBuilder *gaiCategory = [GAIDictionaryBuilder createEventWithCategory:eventLabel action:action label:label value:@1];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[gaiCategory build]];
    [[GAI sharedInstance] dispatchWithCompletionHandler:^(GAIDispatchResult result) {
        
    }];
}

-(void)trackCompanyCard {
    [self trackEventItem:@"ALL PAGES" event:@"COMPANY CARD" action:@"TOUCHED" label:@"" value:nil];
}

- (void)trackProjectCard {
    [self trackEventItem:@"ALL PAGES" event:@"PROJECT CARD" action:@"TOUCHED" label:@"" value:nil];
}

- (void)trackTrackingListIcon {
    [self trackEventItem:@"MAIN MENU" event:@"TRACKING LIST ICON" action:@"TOUCHED" label:@"" value:nil];
}

- (void)trackProjectTrackingList {
    [self trackEventItem:@"MAIN MENU" event:@"TRACKING LIST ICON" action:@"TOUCHED" label:@"PROJECT LIST" value:nil];
}

- (void)trackCompanyTrackingList {
    [self trackEventItem:@"MAIN MENU" event:@"TRACKING LIST ICON" action:@"TOUCHED" label:@"COMPANY LIST" value:nil];
}

- (void)trackSearch {
    [self trackEventItem:@"MAIN MENU" event:@"SEARCH ICON" action:@"TOUCHED" label:@"" value:nil];
    
}

- (void)trackSearchBar {
    [self trackEventItem:@"MAIN MENU" event:@"SEARCH ICON" action:@"TOUCHED" label:@"SMART SEARCH BAR" value:nil];

}

- (void)trackSaveSearchBar {
    [self trackEventItem:@"MAIN MENU" event:@"SEARCH ICON" action:@"TOUCHED" label:@"THREE BAR FILTER SEARCH" value:nil];
}

- (void)trackProjectsNearMe {
    [self trackEventItem:@"MAIN MENU" event:@"PROJECTS NEAR ME" action:@"TOUCHED" label:@"" value:nil];
}

- (void)trackBidsRecentlyMadeGraph {
    [self trackEventItem:@"BIDS" event:@"PROJECTS RECENTLY BID" action:@"TOUCHED" label:@"GRAPH" value:nil];
    
}

- (void)trackBidsRecentlyMadeButton {
    [self trackEventItem:@"BIDS" event:@"PROJECTS RECENTLY BID" action:@"TOUCHED" label:@"BLDG/HVY-HWY BUTTONS" value:nil];
}

- (void)trackBidsRecentlyUpdatedGraph {
    [self trackEventItem:@"BIDS" event:@"PROJECTS RECENTLY UPDATED" action:@"TOUCHED" label:@"GRAPH" value:nil];
    
}

- (void)trackBidsRecentlyUpdatedButton {
    [self trackEventItem:@"BIDS" event:@"PROJECTS RECENTLY UPDATED" action:@"TOUCHED" label:@"BLDG/HVY-HWY BUTTONS" value:nil];
}

- (void)trackBidsRecentlyAddedGraph {
    [self trackEventItem:@"BIDS" event:@"PROJECTS RECENTLY UPDATED" action:@"TOUCHED" label:@"GRAPH" value:nil];
    
}

- (void)trackBidsRecentlyAddedButton {
    [self trackEventItem:@"BIDS" event:@"PROJECTS RECENTLY UPDATED" action:@"TOUCHED" label:@"BLDG/HVY-HWY BUTTONS" value:nil];
}

- (void)trackProjectsHappeningSoon {
    [self trackEventItem:@"BID CALENDAR" event:@"PROJECTS BIDDING SOON" action:@"TOUCHED" label:@"SELECTING CALENDAR" value:nil];
}

@end

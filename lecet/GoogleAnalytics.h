//
//  GoogleAnalytics.h
//  lecet
//
//  Created by Harry Herrys Camigla on 8/30/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGAI_TRACKER_ID              @"UA-83364723-1"

@interface GAManager : NSObject

+ (GAManager*)sharedManager;

- (void)initializeTacker;
- (void)trackEventItem:(NSString*)category event:(NSString *)event action:(NSString*)action label:(NSString*)label value:(NSString*)value;

- (void)trackCompanyCard;
- (void)trackProjectCard;
- (void)trackTrackingListIcon;
- (void)trackProjectTrackingList;
- (void)trackCompanyTrackingList;
- (void)trackSearch;
- (void)trackSearchBar;
- (void)trackSaveSearchBar;
- (void)trackProjectsNearMe;
- (void)trackBidsRecentlyMadeGraph;
- (void)trackBidsRecentlyMadeButton;
- (void)trackBidsRecentlyUpdatedGraph;
- (void)trackBidsRecentlyUpdatedButton;
- (void)trackBidsRecentlyAddedGraph;
- (void)trackBidsRecentlyAddedButton;
- (void)trackProjectsHappeningSoon;
@end

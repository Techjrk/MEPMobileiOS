//
//  LocationManager.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationManager
@synthesize currentStatus;
@synthesize currentLocation;

- (instancetype)init {
    self = [super init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    return self;
}

+ (void)isLocationServiceCanBeEnabled:(StatusBlock)block {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL canBeEnabled = (status != kCLAuthorizationStatusRestricted) & (status !=  kCLAuthorizationStatusDenied);

    block(canBeEnabled, status);
}

- (void)requestAlways {
    [self.locationManager requestAlwaysAuthorization];
}

- (void)requestWhenInUse {
    [self.locationManager requestWhenInUseAuthorization];
}

- (BOOL)locationServiceEnabled {
    return [[self.locationManager class] locationServicesEnabled];
}

-(void)startUpdatingLocation {
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    currentStatus = status;
    
    if (status == kCLAuthorizationStatusDenied) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_DENIED object:nil];
    } else if (status == kCLAuthorizationStatusAuthorizedAlways){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_ALLOWED object:nil];
    }
}

@end

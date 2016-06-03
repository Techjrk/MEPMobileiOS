//
//  LocationManager.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

+ (void)isLocationServiceCanBeEnabled:(StatusBlock)block {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL canBeEnabled = (status != kCLAuthorizationStatusRestricted) & (status !=  kCLAuthorizationStatusDenied);

    block(canBeEnabled, status);
}

@end

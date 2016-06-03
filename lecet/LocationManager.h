//
//  LocationManager.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

typedef void(^StatusBlock)(BOOL canBeEnabled, CLAuthorizationStatus status);

@interface LocationManager : NSObject
+ (void)isLocationServiceCanBeEnabled:(StatusBlock)block;
@end

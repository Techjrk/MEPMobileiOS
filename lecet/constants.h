//
//  constants.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#ifndef constants_h
#define constants_h

//***** COLOR FUNCTIONS *****
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/100.0]

//***** DIMENSIONS *****
#define kDeviceWidth    [[UIScreen mainScreen] bounds].size.width
#define kDeviceHeight   [[UIScreen mainScreen] bounds].size.height
#define kDeviceScale    [UIScreen mainScreen].scale
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

//***** DEVICE FUNCTIONS *****
#define isiPhone4 (kDeviceHeight == 480)?TRUE:FALSE
#define isiPhone5  (kDeviceHeight == 568)?TRUE:FALSE
#define isiPhone6  (kDeviceHeight == 667)?TRUE:FALSE
#define isiPhone6Plus  (kDeviceHeight == 736)?TRUE:FALSE

//***** FONT XPLIER *****
#define FONT_XPLIER                                                      fontXplier()

CG_INLINE CGFloat
fontXplier() {
    CGFloat returnValue      = 1.0;
    if (isiPhone4) {
        returnValue              = 1.0;
    } else if (isiPhone5){
        returnValue              = 1.0;
    } else if (isiPhone6) {
        returnValue              = 1.25;
    } else if (isiPhone6Plus){
        returnValue              = 1.4;
    }
    return returnValue;
}

CG_INLINE UIFont *fontNameWithSize(NSString *fontName, CGFloat fontSize){
    return [UIFont fontWithName:fontName size:fontSize * fontXplier()];
}

CG_INLINE NSString *
NSLocalizedLanguage(NSString *key){
    NSString *table          = @"en";
    return NSLocalizedStringFromTable(key, table, nil);
};

#define FONT_NAME_LATO_REGULAR                   @"Lato-Regular"
#define FONT_NAME_LATO_SEMIBOLD                  @"Lato-Semibold"
#define FONT_NAME_LATO_BOLD                      @"Lato-Bold"
#define FONT_NAME_LATO_BLACK                     @"Lato-Black"
#define FONT_NAME_LATO_HEAVY                     @"Lato-Heavy"
#define FONT_NAME_AWESOME                        @"FontAwesome"

#define NOTIFICATION_APP_BECOME_ACTIVE           @"NOTIFICATION_APP_BECOME_ACTIVE"
#define NOTIFICATION_LOCATION_DENIED             @"NOTIFICATION_LOCATION_DENIED"
#define NOTIFICATION_LOCATION_ALLOWED            @"NOTIFICATION_LOCATION_ALLOWED"
#define NOTIFICATION_UNAUTHORIZED                @"NOTIFICATION_UNAUTHORIZED"
#define NOTIFICATION_GPS_LOCATION                @"NOTIFICATION_GPS_LOCATION"
#define NOTIFICATION_CELL_SIZE_CHANGE            @"NOTIFICATION_CELL_SIZE_CHANGE"

#endif /* constants_h */

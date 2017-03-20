//
//  ProjectHeaderView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/12/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#define PROJECT_GEOCODE_LAT                         @"GEO_CODE_LAT"
#define PROJECT_GEOCODE_LNG                         @"GEO_CODE_LNG"
#define PROJECT_TITLE                               @"PROJECT_TITLE"
#define PROJECT_LOCATION                            @"PROJECT_LOCATION"

typedef enum : NSUInteger {
    pinTypeOrange,
    pinTypeOrageUpdate,
    pinTypeUser,
    pinTypeUserUpdate
} PinType;

@protocol ProjectHeaderDelegate <NSObject>
- (void)tappedProjectMapViewLat:(CGFloat)lat lng:(CGFloat)lng;
@end

@interface ProjectHeaderView : BaseViewClass
@property (strong, nonatomic) id<ProjectHeaderDelegate>projectHeaderDelegate;
@property (nonatomic) PinType pinType;
- (void)setHeaderInfo:(id)headerInfo;
- (CGRect)mapFrame;
@end

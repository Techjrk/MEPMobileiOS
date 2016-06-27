//
//  ProjectBidView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

#define PROJECT_BID_NAME                            @"PROJECT_BID_NAME"
#define PROJECT_BID_LOCATION                        @"PROJECT_BID_LOCATION"
#define PROJECT_BID_AMOUNT                          @"PROJECT_BID_AMOUNT"
#define PROJECT_BID_DATE                            @"PROJECT_BID_DATE"
#define PROJECT_BID_GEOCODE_LAT                     @"PROJECT_BID_GEOCODE_LAT"
#define PROJECT_BID_GEOCODE_LNG                     @"PROJECT_BID_GEOCODE_LNG"

@interface ProjectBidView : BaseViewClass
- (void)setInfo:(id)info;
@end

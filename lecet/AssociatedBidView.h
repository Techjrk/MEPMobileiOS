//
//  AssociatedBidView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

#define ASSOCIATED_BID_ID                               @"ASSOCIATED_BID_ID"
#define ASSOCIATED_BID_NAME                             @"ASSOCIATED_BID_NAME"
#define ASSOCIATED_BID_LOCATION                         @"ASSOCIATED_BID_LOCATION"
#define ASSOCIATED_BID_DESIGNATION                      @"ASSOCIATED_BID_DESIGNATION"
#define ASSOCIATED_BID_GEOCODE_LAT                      @"ASSOCIATED_BID_GEOCODE_LAT"
#define ASSOCIATED_BID_GEOCODE_LNG                      @"ASSOCIATED_BID_GEOCODE_LNG"
#define ASSOCIATED_BID_HAS_NOTESIMAGES                       @"ASSOCIATED_BID_HAS_NOTESIMAGES"

@interface AssociatedBidView : BaseViewClass
- (void)setInfo:(id)info;
@end

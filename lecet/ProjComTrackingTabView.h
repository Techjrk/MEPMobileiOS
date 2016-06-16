//
//  ProjComTrackingTabView.h
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ProjComTrackingTabViewDelegate <NSObject>
- (void)switchTabButtonStateChange:(BOOL)isOn;
- (void)editTabButtonTapped;
@end

@interface ProjComTrackingTabView : BaseViewClass
@property (nonatomic,assign) id <ProjComTrackingTabViewDelegate> projComTrackingTabViewDelegate;

@end

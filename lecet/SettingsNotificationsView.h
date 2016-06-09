//
//  SettingsNotificationsView.h
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol SettingsNotificationsViewDelegate <NSObject>
- (void)switchButtonStateChange:(BOOL)isOn;
@end

@interface SettingsNotificationsView : BaseViewClass
@property (nonatomic,assign) id<SettingsNotificationsViewDelegate> settingsNotificationsViewDelegate;
@end

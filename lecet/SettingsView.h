//
//  SettingsView.h
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum {
    SettingItemsChangePassword = 0,
    SettingItemsSignOut = 1,
} SettingItems;

@protocol SettingViewDelegate <NSObject>
- (void)switchButtonStateChange:(BOOL)isOn;
- (void)selectedSettings:(SettingItems)items;
@end
@interface SettingsView : BaseViewClass
@property (nonatomic,assign) id<SettingViewDelegate> settingViewDelegate;
@end

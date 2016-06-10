//
//  SettingsViewController.h
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol SettingsViewControllerDelegate <NSObject>
- (void)tappedLogout;
@end
@interface SettingsViewController : BaseViewController
@property (strong, nonatomic) id<SettingsViewControllerDelegate>settingsViewControllerDelegate;
@end

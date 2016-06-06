//
//  GoToSettingsViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@protocol GoToSettingsDelegate <NSObject>
- (void)tappedButtonGotoSettings:(id)object;
- (void)tappedButtonGotoSettingsCancel:(id)object;
@end

@interface GoToSettingsViewController : BaseViewController
@property (strong, nonatomic) id<GoToSettingsDelegate>goToSettingsDelegate;
@end

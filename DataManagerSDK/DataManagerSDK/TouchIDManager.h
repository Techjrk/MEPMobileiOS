//
//  TouchIDManager.h
//  BCG
//
//  Created by Ryan Jake Castro on 2/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TouchIDManager : NSObject

+ (instancetype)sharedTouchIDManager;
- (void)setReason:(NSString*)reason;
- (NSString *)canAuthenticate;
- (void)authenticateWithSuccessHandler:(dispatch_block_t)successHandler
                                 error:(dispatch_block_t)errorHandler
                        viewController:(UIViewController *)viewController;

@end

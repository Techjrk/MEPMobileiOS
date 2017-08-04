//
//  AppDelegate.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * _Nonnull window;
@property (strong, nonatomic) UINavigationController * _Nonnull navController;

@property (strong, nonnull) NSString *pushToken;
@property (nonatomic,strong) NSNumber * _Nullable notificationPayloadRecordID;

- (UINavigationController*_Nullable)navigationController;

@end


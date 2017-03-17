//
//  CustomCamera.h
//  lecet
//
//  Created by Michael San Minay on 16/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomCamera : NSObject
+ (instancetype)sharedInstance;
@property (strong,nonatomic) UIViewController *controller;
- (void)showCamera;

@end

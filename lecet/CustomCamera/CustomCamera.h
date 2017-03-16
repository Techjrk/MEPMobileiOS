//
//  CustomCamera.h
//  lecet
//
//  Created by Michael San Minay on 15/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
@interface CustomCamera : BaseViewClass
+ (instancetype)sharedInstance;
@property (strong,nonatomic) UIViewController *controller;
- (void)captureCamera;
@end

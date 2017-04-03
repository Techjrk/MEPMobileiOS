//
//  UserLocationPinViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 3/29/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol CreateProjectPinDelegate <NSObject>
- (void)createProjectUsingLocation:(CLLocation*)location;
@end

@interface UserLocationPinViewController : BaseViewController
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) id<CreateProjectPinDelegate>createProjectPinDelegate;
@end

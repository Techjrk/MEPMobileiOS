//
//  NewPinViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/4/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLocationPinViewController.h"

@interface NewPinViewController : UIViewController
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) id<CreateProjectPinDelegate>createProjectPinDelegate;
@end

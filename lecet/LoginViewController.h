//
//  LoginViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol LoginDelegate <NSObject>
- (void)login;
@end

@interface LoginViewController : BaseViewController
@property (strong, nonatomic) id<LoginDelegate>loginDelegate;
@end

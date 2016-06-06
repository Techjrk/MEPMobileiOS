//
//  ShareLocationViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@protocol ShareLocationDelegate <NSObject>
- (void)tappedButtonShareLocation:(id)object;
- (void)tappedButtonShareCancel:(id)object;
@end

@interface ShareLocationViewController : BaseViewController
@property (strong, nonatomic) id<ShareLocationDelegate>shareLocationDelegate;
@end

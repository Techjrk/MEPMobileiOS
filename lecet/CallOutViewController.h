//
//  CallOutViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/8/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@interface CallOutViewController : BaseViewController
@property (strong, nonatomic) id projectPin;
@property (strong, nonatomic) UIView *sourceView;
- (void)setInfo:(id)info;
@end

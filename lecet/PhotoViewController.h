//
//  PhotoViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 3/15/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PhotoViewController : BaseViewController
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) NSString *text;
@end

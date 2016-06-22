//
//  ProjectTrackingViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface ProjectTrackingViewController : BaseViewController
@property (strong ,nonatomic) NSMutableDictionary *cargo;
@property (strong, nonatomic) NSMutableArray *collectionItems;
@end

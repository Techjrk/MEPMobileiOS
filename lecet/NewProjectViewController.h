//
//  NewProjectViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 3/21/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ProjectHeaderView.h"

@protocol NewProjectViewControllerDelegate <NSObject>
- (void)tappedSavedNewProject:(id)object;
@end

@interface NewProjectViewController : BaseViewController
@property (strong, nonatomic) id<NewProjectViewControllerDelegate>projectViewControllerDelegate;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) PinType pinType;
@end

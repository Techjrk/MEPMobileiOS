//
//  SaveNewProjectViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/5/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@protocol SaveNewProjectViewControllerDelegate <NSObject>
- (void)tappedSaveNewProject;
@end

@interface SaveNewProjectViewController : BaseViewController
@property (strong, nonatomic) id<SaveNewProjectViewControllerDelegate>saveNewProjectViewControllerDelegate;
@end

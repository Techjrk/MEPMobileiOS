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
- (void)tappedSavedNewProject:(id)object isAdded:(BOOL)isAdded;
@end

@interface NewProjectViewController : BaseViewController
@property (strong, nonatomic) id<NewProjectViewControllerDelegate>projectViewControllerDelegate;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) PinType pinType;
@property (nonatomic) BOOL updateProject;
@property (strong, nonatomic) NSNumber *projectId;

- (void)setProjectTitle:(NSString*)projectTitleParam;
- (void)setType:(NSNumber*)typeIdParam;
- (void)setStage:(NSNumber*)stageIdParam;
- (void)setDate:(NSString*)dateParam;
- (void)setCounty:(NSString*)countyParam code:(NSString*)code;
@end

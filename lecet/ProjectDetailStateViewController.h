//
//  ProjectDetailStateViewController.h
//  lecet
//
//  Created by Michael San Minay on 27/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>







@protocol ProjectDetailStateViewControllerDelegate <NSObject>
@required
- (void)tappedDismissed;

@end
@interface ProjectDetailStateViewController : UIViewController


@property (nonatomic,assign) id<ProjectDetailStateViewControllerDelegate> projectDetailStateViewControllerDelegate;

@end

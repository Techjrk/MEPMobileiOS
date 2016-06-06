//
//  ProjectSortViewController.h
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectSortConstant.h"



@protocol ProjectSortViewControllerDelegate <NSObject>
@required
-(void)selectedProjectSort:(ProjectSortItems)projectSortItem;
@end

@interface ProjectSortViewController : UIViewController
@property (nonatomic,assign) id<ProjectSortViewControllerDelegate> projectSortViewControllerDelegate;

@end

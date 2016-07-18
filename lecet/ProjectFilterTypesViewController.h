//
//  ProjectFilterTypesViewController.h
//  lecet
//
//  Created by Michael San Minay on 28/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol ProjectFilterTypesViewControllerDelegate <NSObject>
- (void)tappedTypesApplyButton:(id)items;
@end

@interface ProjectFilterTypesViewController : BaseViewController
@property (nonatomic, assign) id <ProjectFilterTypesViewControllerDelegate> projectFilterTypesViewControllerDelegate;
- (void)setDataInfo:(id)info;
@end

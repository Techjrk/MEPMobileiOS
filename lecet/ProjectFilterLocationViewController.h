//
//  ProjectFilterLocationViewController.h
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol ProjectFilterLocationViewControllerDelegate <NSObject>
- (void)tappedLocationApplyButton:(id)items;
@end

@interface ProjectFilterLocationViewController : BaseViewController
@property (nonatomic,assign) id <ProjectFilterLocationViewControllerDelegate> projectFilterLocationViewControllerDelegate;
@property (nonatomic,strong) NSArray *dataSelected;
- (void)setInfo:(id)info;
@end

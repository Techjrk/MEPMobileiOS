//
//  ProjectShareViewController.h
//  lecet
//
//  Created by Michael San Minay on 01/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProjectShareListViewControllerDelegate <NSObject>
@required
- (void)tappedDismissedProjectShareList;
@end

@interface ProjectShareViewController : UIViewController
@property (nonatomic,assign) id<ProjectShareListViewControllerDelegate> projectShareListViewControllerDelegate;
-(void)setProjectState:(UIView *)stateView;





@end

//
//  ProjectListViewController.h
//  lecet
//
//  Created by Michael San Minay on 27/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProjectTrackListViewControllerDelegate <NSObject>
@required
- (void)tappedDismissedProjectTrackList;
@end

@interface ProjectListViewController : UIViewController
@property (nonatomic,assign) id<ProjectTrackListViewControllerDelegate> projectTrackListViewControllerDelegate;
-(void)setProjectStateViewFrame:(UIView *)stateView;
@end

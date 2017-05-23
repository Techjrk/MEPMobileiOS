//
//  WorkOwnerTypesViewController.h
//  lecet
//
//  Created by Michael San Minay on 30/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkOwnerTypesViewControllerDelegate <NSObject>
@required
- (void)tappedApplyWorkOwnerButton:(id)item;
@end

@interface WorkOwnerTypesViewController : UIViewController
@property (nonatomic,assign) id <WorkOwnerTypesViewControllerDelegate> workOwnerTypesViewControllerDelegate;
- (void)setInfo:(id)info selectedItem:(NSString*)selectedItem;
- (void)setNavTitle:(NSString *)text;
@end

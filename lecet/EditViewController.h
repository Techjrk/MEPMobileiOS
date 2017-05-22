//
//  EditViewController.h
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewControllerDelegate <NSObject>
- (void)tappedCancelDoneButton:(id)items;
- (void)tappedBackButton;
@end

@interface EditViewController : UIViewController
@property(nonatomic,assign) id <EditViewControllerDelegate> editViewControllerDelegate;
- (void)setInfo:(id)items;
- (void)setTrackingInfo:(id)item;
@end

//
//  MoreMenuViewController.h
//  lecet
//
//  Created by Michael San Minay on 01/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dropDownMenuConstants.h"

@protocol MoreMenuViewControllerDelegate <NSObject>
@required
- (void)tappedDropDownMenu:(DropDownMenuItem)menuDropDownItem;
@end

@interface MoreMenuViewController : UIViewController
@property (nonatomic,assign) id<MoreMenuViewControllerDelegate> moreMenuViewControllerDelegate;
- (void)setInfo:(id)info;
@end

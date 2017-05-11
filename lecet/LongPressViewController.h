//
//  LongPressViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/10/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LongPressViewControllerDelegate <NSObject>
- (void)tappedHome;
@end

@interface LongPressViewController : UIViewController
@property (strong, nonatomic) id<LongPressViewControllerDelegate>longPressViewControllerDelegate;
@end

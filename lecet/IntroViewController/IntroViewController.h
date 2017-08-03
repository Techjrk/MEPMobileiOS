//
//  IntroViewController.h
//  lecet
//
//  Created by Michael San Minay on 03/08/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroViewControllerDelegate <NSObject>
- (void)tappedIntroCloseButton;
@end

@interface IntroViewController : UIViewController
@property (strong,nonatomic) id <IntroViewControllerDelegate> introViewControllerDelegate;
@end

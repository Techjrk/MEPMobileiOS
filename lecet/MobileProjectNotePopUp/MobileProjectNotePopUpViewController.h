//
//  MobileProjectNotePopUpViewController.h
//  lecet
//
//  Created by Michael San Minay on 11/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MobileProjectNotePopUpViewControllerDelegate <NSObject>
@required
- (void)tappedDismissedPostNote;
- (void)tappedPostNoteButton;
@end


@interface MobileProjectNotePopUpViewController : UIViewController
@property (nonatomic,assign) BOOL isAddImage;
@property (nonatomic,assign) id<MobileProjectNotePopUpViewControllerDelegate> mobileProjectNotePopUpViewControllerDelegate;
@end

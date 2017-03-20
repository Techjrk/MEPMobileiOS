//
//  MobileProjectAddNoteViewController.h
//  lecet
//
//  Created by Michael San Minay on 09/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MobileProjectAddNoteViewControllerDelegate <NSObject>
- (void) tappedUpdateUserNotes;
@end

@interface MobileProjectAddNoteViewController : UIViewController
@property id<MobileProjectAddNoteViewControllerDelegate>mobileProjectAddNoteViewControllerDelegate;
@property (strong,nonatomic) NSNumber *projectID;
@end

//
//  CustomPhotoLibraryViewController.h
//  lecet
//
//  Created by Michael San Minay on 23/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPhotoLibraryViewControllerDelegate <NSObject>
- (void)customCameraPhotoLibDidSelect:(UIImage *)image;
- (void)customCameraControlListDidSelect:(id)info ;
@end

@interface CustomPhotoLibraryViewController : UIViewController
@property(strong,nonatomic) id<CustomPhotoLibraryViewControllerDelegate> customPhotoLibraryViewControllerDelegate;


@end

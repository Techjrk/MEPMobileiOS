//
//  PhotoShutterViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/11/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoShutterViewControllerDelegate <NSObject>
@optional
- (void)photoTaken:(UIImage *)image;
@end

@interface PhotoShutterViewController : UIViewController
@property (nonatomic,assign) id<PhotoShutterViewControllerDelegate> photoShutterViewControllerDelegate;
- (void)tappedTakePanoramaPhoto;
- (void)startShutter;
- (void)stopShutter;
- (void)setIs360Selected:(BOOL)selected;
@end

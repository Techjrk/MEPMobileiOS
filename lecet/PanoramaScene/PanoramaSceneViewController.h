//
//  PanoramaViewerViewController.h
//  lecet
//
//  Created by Michael San Minay on 27/04/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMD_LITE.h"

@protocol PanoramaSceneViewControllerDelegate <NSObject>

- (void)tappedDoneButtonPanoramaViewer;

@end

@interface PanoramaSceneViewController : UIViewController {
}
@property (strong, nonatomic) PanoViewer *panoViewer;
@property (strong, nonatomic) id<PanoramaSceneViewControllerDelegate> panoramaViewerViewControllerDelegate;
@property (strong, nonatomic) id image;
@end

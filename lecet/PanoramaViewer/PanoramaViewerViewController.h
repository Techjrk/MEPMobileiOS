//
//  PanoramaViewerViewController.h
//  lecet
//
//  Created by Michael San Minay on 27/04/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMD_LITE.h"

@protocol PanoramaViewerViewControllerDelegate <NSObject>

- (void)tappedDoneButtonPanoramaViewer;

@end

@interface PanoramaViewerViewController : UIViewController {
}
@property (strong, nonatomic) PanoViewer *panoViewer;
@property (strong, nonatomic) id<PanoramaViewerViewControllerDelegate> panoramaViewerViewControllerDelegate;
@end

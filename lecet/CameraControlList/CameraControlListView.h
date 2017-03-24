//
//  CameraControlListView.h
//  lecet
//
//  Created by Michael San Minay on 17/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
#import "CameraControlListViewItem.h"

@protocol CameraControlListViewDelegate <NSObject>
@required
- (void)cameraControlListDidSelect:(id)info;
@end
@interface CameraControlListView : BaseViewClass
@property (strong,nonatomic) id<CameraControlListViewDelegate> cameraControlListViewDelegate;
@property (nonatomic,assign)  BOOL isImageCaptured;
@property (nonatomic,assign) CameraControlListViewItems focusOnItem;

- (void)setCameraItemsInfo:(NSArray *)cameraItems hideLineView:(BOOL)hide;

@end

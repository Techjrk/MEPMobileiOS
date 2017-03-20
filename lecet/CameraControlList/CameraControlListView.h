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
- (void)setCameraItemsInfo:(NSArray *)cameraItems;

@end

//
//  CustomPhotoLibView.h
//  lecet
//
//  Created by Michael San Minay on 24/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol CustomPhotoLibViewDelegate <NSObject>
- (void)customPhotoLibDidSelect:(UIImage *)image;
@end

@interface CustomPhotoLibView : BaseViewClass
@property (strong,nonatomic) id<CustomPhotoLibViewDelegate> customPhotoLibViewDelegate;

@end

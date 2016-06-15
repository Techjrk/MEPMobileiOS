//
//  PopupViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "CustomCollectionView.h"

typedef enum : NSUInteger {
    PopupPlacementTop = 0,
    PopupPlacementBottom = 1
} PopupPlacement;

@interface PopupViewController : BaseViewController
@property (nonatomic) id<CustomCollectionViewDelegate>customCollectionViewDelegate;
@property (nonatomic) BOOL isGreyedBackground;
@property (nonatomic) CGRect popupRect;
@property (strong, nonatomic) UIColor *popupPlacementColor;
@property (nonatomic) PopupPlacement popupPalcement;
@property (nonatomic) CGFloat popupWidth;
- (CGRect)getViewPositionFromViewController:(UIView*)view controller:(UIViewController*)controller;
@end

//
//  MenuHeaderView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum  {
    MenuHeaderNear = 0,
    MenuHeaderTrack = 1,
    MenuHeaderSearch = 2,
    MenuHeaderMore =3
} MenuHeaderItem;

@protocol MenuHeaderDelegate <NSObject>
- (void)tappedMenu:(MenuHeaderItem)menuHeaderItem forView:(UIView*)view;
@end

@interface MenuHeaderView : BaseViewClass
@property (strong, nonatomic) id<MenuHeaderDelegate>menuHeaderDelegate;
- (void)setTitleFromCount:(NSInteger)count title:(NSString*)title;
@end

//
//  MyProfileHeaderView.h
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#define MYPROFILE_HEADER_LABEL_FONT fontNameWithSize(FONT_NAME_LATO_BOLD, 10)
#define MYPROFILE_HEADER_LABEL_FONT_COLOR RGB(149,149,149)

#define MYPROFILE_TEXTFIELD_FONT fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define MYPROFILE_TEXTFIELD_FONT_COLOR RGB(34,34,34)

#define MYPROFILE_HEADER_BG_COLOR RGB(245,245,245)
#define MYPROFILE_VERTICAL_LINE_BG_COLOR RGB(245,245,245)
#define MYPROFILE_CONTAINERVIEW_BG_COLOR RGB(245,245,245)

#define NOTIFYTODISMISSKEYBOARD @"NOTIFYTODISMISSKEYBOARD"

@protocol MyProfileHeaderViewDelegate <NSObject>
@optional
- (void)tappedHeaderView;

@end

@interface MyProfileHeaderView : BaseViewClass
@property (nonatomic,assign) id<MyProfileHeaderViewDelegate> myProfileHeaderViewDelegate;
- (void)setLeftLabelText:(NSString *)text;
- (void)setRightLabelText:(NSString *)text;
- (void)hideRightLabel:(BOOL)hide;


@end

//
//  ProfileNavView.h
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum  {
    ProfileNavItemBackButton = 0,
    ProfileNavItemSaveButton = 1,
} ProfileNavItem;

@protocol ProfileNavViewDelegate <NSObject>
@required
-(void)tappedProfileNav:(ProfileNavItem)profileNavItem;
@end

@interface ProfileNavView : BaseViewClass
@property (nonatomic,assign) id<ProfileNavViewDelegate> profileNavViewDelegate;
- (void)setNavTitleLabel:(NSString *)name;
- (void)hideSaveButton:(BOOL)hide;
- (void)setNavRightButtonTitle:(NSString *)text;
- (void)setRigthBorder:(int)border;

@end


//
//  SettingCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingCollectionViewCellDelegate <NSObject>

- (void)switchButtonStateChange:(BOOL)isOn;

@end

@interface SettingCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) id<SettingCollectionViewCellDelegate> settingCollectionViewCellDelegate;
- (void)setHideNotificationView:(BOOL)hide;
- (void)setHideChangePassword:(BOOL)hide;

@end

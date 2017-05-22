//
//  CompanyTrackingCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyTrackingCollectionViewCellDelegate <NSObject>
- (void)tappedButtonAtTag:(int)tag;
@end

@interface CompanyTrackingCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) id <CompanyTrackingCollectionViewCellDelegate> companyTrackingCollectionViewCellDelegate;
- (void)setTitleName:(NSString *)text;
- (void)setAddressTop:(NSString *)text;
- (void)setAddressBelow:(NSString *)text;
- (void)setButtonLabelTitle:(NSString *)text;
- (void)setButtontag:(int)tag;
- (void)changeCaretToUp:(BOOL)up;
- (void)setImage:(id)imageName;
- (void)searchLocationGeoCode;
- (void)setUpdateInfo:(id)info;
@end

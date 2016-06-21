//
//  EditViewCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewCollectionViewCellDelegate <NSObject>
- (void)tappedButtonSelectAtTag:(int)tag;
@end

@interface EditViewCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign) id <EditViewCollectionViewCellDelegate> editViewCollectionViewCellDelegate;
- (BOOL)isButtonSelected;
- (void)setButtonTag:(int)tag;
- (void)setAddressOneText:(NSString *)text;
- (void)setAddressTwoTex:(NSString *)text;
- (void)setButtonSelected:(BOOL)select;
@end

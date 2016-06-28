//
//  ProjectFilterCollapsibleCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectFilterCollapsibleDataInfo.h"


@protocol ProjectFilterCollapsibleCollectionViewCellDelegate <NSObject>
- (void)tappedSelectionButton:(id)tag;
- (void)tappedDropDownButton:(id)tag;
- (void)tappedSecondSubCatSelectionButton:(id)tag;

@end

@interface ProjectFilterCollapsibleCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) id <ProjectFilterCollapsibleCollectionViewCellDelegate> projectFilterCollapsibleCollectionViewCellDelegate;
- (void)setTextLabel:(NSString *)text;
- (void)setButtonTag:(int)tag;
- (void)setSelectionButtonSelected:(BOOL)selected;
- (void)setDropDownSelected:(BOOL)selected;
- (void)setLeftLineSpacingForLineView:(CGFloat)value;
- (void)setCollapsibleViewLetfSpacing:(CGFloat)value;
- (void)setIndePathForCollapsible:(NSIndexPath *)index;
- (void)setCollapsibleRightButtonHidden:(BOOL)hide;
- (void)setLineViewHidden:(BOOL)hide;


//Second Sub
- (void)setSecSubCatInfo:(id)info;
- (void)setSecSubCatLeftSpacing:(CGFloat)val;
- (void)setSecSubCatBounce:(BOOL)bounce;
- (void)setHideLineViewBOOL:(BOOL)hide;

@end

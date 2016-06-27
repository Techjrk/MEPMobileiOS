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

- (void)tappedSelectionButton:(int)tag;
- (void)tappedDropDownButton:(int)tag;

@end

@interface ProjectFilterCollapsibleCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) id <ProjectFilterCollapsibleCollectionViewCellDelegate> projectFilterCollapsibleCollectionViewCellDelegate;
- (void)setTextLabel:(NSString *)text;
- (void)setButtonTag:(int)tag;
- (void)setSelectionButtonSelected:(BOOL)selected;
- (void)setDropDownSelected:(BOOL)selected;
@end

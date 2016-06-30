//
//  WorkOwnerTypesCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 30/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkOwnerTypesCollectionViewCellDelegate <NSObject>
- (void)tappedSelectionButton:(id)tag;
@end

@interface WorkOwnerTypesCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) id <WorkOwnerTypesCollectionViewCellDelegate> workOwnerTypesCollectionViewCellDelegate;
- (void)setTextLabel:(NSString *)text;
- (void)setIndexPath:(NSIndexPath *)index;
- (void)setSelectionButtonSelected:(BOOL)selected;
@end

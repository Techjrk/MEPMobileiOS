//
//  FilterEntryCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 04/08/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterEntryCollectionViewCellDelegate <NSObject>
- (void)tappedRemovedButtonAtIndex:(int)index;
@end
@interface FilterEntryCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) id <FilterEntryCollectionViewCellDelegate> filterEntryCollectionViewCellDelegate;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (void)setLabelAttributedText:(id)attriText;
@end

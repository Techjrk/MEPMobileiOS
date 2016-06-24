//
//  ProjectFilterSelectionCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProjectFilterSelectionCollectionViewCellDelegate <NSObject>
- (void)tappedCheckButtonAtTag:(int)tag;
@end

@interface ProjectFilterSelectionCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign)id <ProjectFilterSelectionCollectionViewCellDelegate> projectFilterSelectionCollectionViewCellDelegate;
- (void)setLabelText:(NSString *)text;
- (void)setButtonSelected:(BOOL)selected;
- (void)setButtonTag:(int)tag;
@end

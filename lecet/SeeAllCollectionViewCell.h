//
//  SeeAllCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeeAllCollectionViewCellDelegate <NSObject>
- (void)tappedSectionFooter:(id)object;
@end

@interface SeeAllCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id<SeeAllCollectionViewCellDelegate>seeAllCollectionViewCellDelegate;
@property (weak, nonatomic) NSIndexPath *indexPath;
- (void)setTitle:(NSString*)title;
@end

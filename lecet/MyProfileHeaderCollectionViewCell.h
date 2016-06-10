//
//  MyProfileHeaderCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileHeaderCollectionViewCell : UICollectionViewCell

- (void)setHeaderLeftTitle:(NSString *)title;
- (void)setHeaderRightTitle:(NSString *)title;
- (void)hideRightLabel:(BOOL)hide;

@end

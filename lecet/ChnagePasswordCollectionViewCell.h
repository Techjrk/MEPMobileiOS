//
//  ChnagePasswordCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChnagePasswordCollectionViewCell : UICollectionViewCell
- (NSString *)getText;
- (void)setTitle:(NSString *)title;
- (void)setPlaceHolderForTextField:(NSString *)placeHolderText;
- (void)setSecureTextField:(BOOL)secure;
@end

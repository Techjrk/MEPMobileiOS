//
//  ShareItemCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/21/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ShareItemEmail,
    ShareItemLink
} ShareItem;

@interface ShareItemCollectionViewCell : UICollectionViewCell
@property (nonatomic) ShareItem shareItem;

@end

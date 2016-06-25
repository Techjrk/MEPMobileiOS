//
//  ShareItemCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/21/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DROPDOWN_SHARELIST_BUTTON_SENDBYEMAIL_FONT          fontNameWithSize(FONT_NAME_LATO_REGULAR, 14)
#define DROPDOWN_SHARELIST_BUTTON_COPYLINK_FONT             fontNameWithSize(FONT_NAME_LATO_REGULAR, 14)

#define DROPDOWN_SHARELIST_BUTTON_FONT                      fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define DROPDOWN_SHARELIST_BUTTON_COLOR                     RGB(72, 72, 72)

typedef enum : NSUInteger {
    ShareItemEmail,
    ShareItemLink
} ShareItem;

@interface ShareItemCollectionViewCell : UICollectionViewCell
@property (nonatomic) ShareItem shareItem;

@end

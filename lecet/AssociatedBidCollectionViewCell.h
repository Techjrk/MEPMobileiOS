//
//  AssociatedBidCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionView.h"

@interface AssociatedBidCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<ActionViewDelegate> actionViewDelegate;
- (void)setInfo:(id)info;
@end

//
//  ProjectBidItemCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActionView.h"

@interface ProjectBidItemCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<ActionViewDelegate> actionViewDelegate;
@property (weak, nonatomic) IBOutlet ActionView *actionView;
- (void)setInfo:(id)info;
@end

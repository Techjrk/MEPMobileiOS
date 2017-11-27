//
//  ProjectBiddersCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionView.h"

@interface ProjectBiddersCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<ActionViewDelegate> actionViewDelegate;
@property (weak, nonatomic) IBOutlet ActionView *actionView;
- (void)setItem:(NSString*)title line1:(NSString*)line1 line2:(NSString*)line2;
@end

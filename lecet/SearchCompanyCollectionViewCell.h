//
//  SearchCompanyCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActionView.h"
@interface SearchCompanyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<ActionViewDelegate> actionViewDelegate;
@property (weak, nonatomic) IBOutlet ActionView *actionView;
- (void)setInfo:(id)info;
@end

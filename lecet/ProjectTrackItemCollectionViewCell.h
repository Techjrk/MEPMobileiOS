//
//  ProjectTrackItemCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectTrackItemView.h"

@interface ProjectTrackItemCollectionViewCell : UICollectionViewCell<ProjectTrackItemViewDelegate>
@property (strong, nonatomic) id<ProjectTrackItemViewDelegate>projectTrackItemViewDelegate;
- (void)setInfo:(id)info;
@end

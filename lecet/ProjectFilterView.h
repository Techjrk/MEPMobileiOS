//
//  ProjectFilterView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@interface ProjectFilterView : BaseViewClass
@property (weak, nonatomic) UIScrollView *scrollView;
- (void) setConstraint:(NSLayoutConstraint*)constraint;
@end

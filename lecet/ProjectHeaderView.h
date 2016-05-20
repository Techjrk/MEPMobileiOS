//
//  ProjectHeaderView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/12/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ProjectHeaderDelegate <NSObject>
- (void)tappedProjectMapViewLat:(CGFloat)lat lng:(CGFloat)lng;
@end

@interface ProjectHeaderView : BaseViewClass
@property (strong, nonatomic) id<ProjectHeaderDelegate>projectHeaderDelegate;
- (void)setHeaderInfo:(id)headerInfo;
- (CGRect)mapFrame;
@end

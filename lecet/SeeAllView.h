//
//  SeeAllView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol SeeAllViewDelegate <NSObject>
- (void)tappedSeeAllView:(id)object;
@end

@interface SeeAllView : BaseViewClass
@property (strong, nonatomic) id<SeeAllViewDelegate>seeAllViewDelegate;
@property (nonatomic) BOOL isExpanded;
@end

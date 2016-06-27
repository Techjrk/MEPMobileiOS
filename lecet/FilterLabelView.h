//
//  FilterLabelView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol FilterLabelViewDelegate <NSObject>
- (void)tappedFilterLabelView:(id)object;
@end

@interface FilterLabelView : BaseViewClass
@property (weak, nonatomic) id<FilterLabelViewDelegate>filterLabelViewDelegate;
- (void)setTitle:(NSString*)title;
- (void)setValue:(NSString*)value;
@end

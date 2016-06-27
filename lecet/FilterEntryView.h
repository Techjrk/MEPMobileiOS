//
//  FilterEntryView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol FilterEntryViewDelegate <NSObject>
- (void)tappedFilterEntryViewDelegate:(id)object;
@end

@interface FilterEntryView : BaseViewClass
@property (weak, nonatomic) id<FilterEntryViewDelegate>filterEntryViewDelegate;
- (void)setTitle:(NSString*)title;
@end

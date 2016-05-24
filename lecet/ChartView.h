//
//  ChartView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 4/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ChartViewDelegate <NSObject>
- (void)selectedItemChart:(NSString*)itemTag chart:(id)chart hasfocus:(BOOL)hasFocus;
@end

@interface ChartView : BaseViewClass
@property (strong, nonatomic) id<ChartViewDelegate>chartViewDelegate;
- (void)setSegmentItems:(NSMutableDictionary*)items;
@end

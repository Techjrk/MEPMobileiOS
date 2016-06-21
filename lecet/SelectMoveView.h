//
//  SelectMoveView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol SelectMoveViewDelegate <NSObject>
- (void)tappedMoveItem:(id)object shouldMove:(BOOL)shouldMove;
@end

@interface SelectMoveView : BaseViewClass
@property (strong, nonatomic) id<SelectMoveViewDelegate>selectMoveViewDelegate;
@end

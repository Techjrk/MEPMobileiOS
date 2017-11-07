//
//  ProjectAllBidsView.h
//  lecet
//
//  Created by Michael San Minay on 03/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#import "ActionView.h"

@protocol ProjectAllBidsViewDelegate <NSObject>
- (void)selectedProjectAllBidItem:(id)object;
- (UIViewController*)parentController;
@end

@interface ProjectAllBidsView : BaseViewClass
@property (strong, nonatomic) id<ProjectAllBidsViewDelegate>projectAllBidsViewDelegate;
- (void)setItems:(NSMutableArray*)items;
@end

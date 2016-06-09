//
//  ProjectAllAssociatedProjectView.h
//  lecet
//
//  Created by Michael San Minay on 05/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ProjectAllAssociatedProjectViewDelegate <NSObject>
- (void)selectedAssociatedProjectItem:(id)object;
@end
@interface ProjectAllAssociatedProjectView : BaseViewClass
@property (strong, nonatomic) id<ProjectAllAssociatedProjectViewDelegate>projectAllAssociatedProjectViewDelegate;
- (void)setItems:(NSMutableArray*)items;
@end

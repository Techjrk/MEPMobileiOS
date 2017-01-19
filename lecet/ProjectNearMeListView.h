//
//  ProjectNearMeListMe.h
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@interface ProjectNearMeListView : BaseViewClass
@property (weak, nonatomic) UIViewController *parentCtrl;
- (void)setInfo:(id)info;
@end

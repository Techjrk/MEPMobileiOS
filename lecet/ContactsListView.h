//
//  ContactsListView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@interface ContactsListView : BaseViewClass
- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
- (void)setItems:(NSMutableArray*)items;
@end

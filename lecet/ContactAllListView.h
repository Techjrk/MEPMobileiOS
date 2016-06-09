//
//  ContactAllListView.h
//  lecet
//
//  Created by Michael San Minay on 05/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ContactAllListViewDelegate <NSObject>
- (void)selectedContact:(id)object;
@end

@interface ContactAllListView : BaseViewClass
@property (strong, nonatomic) id<ContactAllListViewDelegate>contactAllListViewDelegate;
- (void)setItems:(NSMutableArray*)items;
@end

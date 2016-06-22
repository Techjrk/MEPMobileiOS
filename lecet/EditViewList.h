//
//  EditViewList.h
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol EditViewListDelegate <NSObject>
- (void)selectedItem:(id)items;
@end

@interface EditViewList : BaseViewClass
@property (nonatomic,assign) id <EditViewListDelegate> editViewListDelegate;
- (void)setInfo:(id)items;
- (id)getData:(id)items;

@end

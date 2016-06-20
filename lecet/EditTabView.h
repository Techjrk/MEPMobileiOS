//
//  EditTabView.h
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"


typedef enum{
    EditTabItemCancel = 0,
    EditTabItemDone = 1,
}EditTabItem;

@protocol EditTabViewDelegate <NSObject>

- (void)selectedEditTabButton:(EditTabItem)item;


@end

@interface EditTabView : BaseViewClass
@property (nonatomic,assign) id <EditTabViewDelegate> editTabViewDelegate;

@end

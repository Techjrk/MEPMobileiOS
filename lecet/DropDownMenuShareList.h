//
//  DropDownMenuShareList.h
//  lecet
//
//  Created by Get Devs on 22/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"



typedef enum  {
    DropDownSendByEmail = 0,
    DropDownCopyLink = 1,
} DropDownShareListItem;




@protocol DropDownShareListDelegate <NSObject>

@required
- (void)tappedDropDownShareList:(DropDownShareListItem)shareListItem;

@end
@interface DropDownMenuShareList : BaseViewClass

@property (nonatomic,assign) id<DropDownShareListDelegate> dropDownShareListDelegate;

@end

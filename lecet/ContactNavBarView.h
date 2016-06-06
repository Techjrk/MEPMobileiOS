//
//  ContactNavBarView.h
//  lecet
//
//  Created by Michael San Minay on 04/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"


@protocol ContactNavViewDelegate <NSObject>

@required
-(void)tappedContactNavBackButton;

@end

@interface ContactNavBarView : BaseViewClass
@property (nonatomic,assign) id<ContactNavViewDelegate> contactNavViewDelegate;

@end

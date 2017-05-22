//
//  ContactDetailView.h
//  lecet
//
//  Created by Michael San Minay on 06/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ContactDetailViewDelegate <NSObject>
@required
- (void)selectedContactDetails:(id)item;
@end

@interface ContactDetailView : BaseViewClass
- (void)setItems:(NSMutableArray*)items;
@property (nonatomic,assign) id<ContactDetailViewDelegate> contactDetailViewDelegate;

@end

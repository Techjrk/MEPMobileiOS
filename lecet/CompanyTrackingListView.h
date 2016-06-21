//
//  CompanyTrackingListView.h
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@interface CompanyTrackingListView : BaseViewClass
- (void)setItems:(id)items;
- (void)switchButtonChange:(BOOL)isOn;
- (id)getdata;
- (void)setItemFrommEditViewController:(id)item ;
@end

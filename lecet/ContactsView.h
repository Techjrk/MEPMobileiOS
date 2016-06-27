//
//  ContactsView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#define CONTACT_NAME                            @"CONTACT_NAME"
#define CONTACT_COMPANY                         @"CONTACT_COMPANY"

#define CONTACTS_LIST_BUTTON_FONT               fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define CONTACTS_LIST_BUTTON_COLOR              RGB(121, 120, 120)

@interface ContactsView : BaseViewClass
- (void)setInfo:(id)info;
@end

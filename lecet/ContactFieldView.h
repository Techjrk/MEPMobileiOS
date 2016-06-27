//
//  ContactFieldView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum {
    ContactFieldTypePhone = 0,
    ContactFieldTypeEmail = 1,
    ContactFieldTypeWeb = 2,
    ContactFieldTypeAccount = 3,
    ContactFieldTypeLocation = 4
} ContactFieldType;

#define CONTACT_FIELD_TYPE                      @"CONTACT_FIELD_TYPE"
#define CONTACT_FIELD_DATA                      @"CONTACT_FIELD_DATA"


@interface ContactFieldView : BaseViewClass
- (void)setInfo:(id)info;
@end

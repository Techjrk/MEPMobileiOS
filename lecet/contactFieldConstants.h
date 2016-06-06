//
//  contactFieldConstants.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#ifndef contactFieldConstants_h
#define contactFieldConstants_h

#import "constants.h"

typedef enum {
    ContactFieldTypePhone = 0,
    ContactFieldTypeEmail = 1,
    ContactFieldTypeWeb = 2,
    ContactFieldTypeAccount = 3,
    ContactFieldTypeLocation = 4
} ContactFieldType;

#define CONTACT_FIELD_TYPE                      @"CONTACT_FIELD_TYPE"
#define CONTACT_FIELD_DATA                      @"CONTACT_FIELD_DATA"

#define CONTACT_FIELD_LABEL_FONT                fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define CONTACT_FIELD_LABEL_COLOR               RGB(34, 34, 34)
#define CONTACT_COMPANY_NAME_FIELD_FONT_COLOR   RGB(76,145,209)

#endif /* contactFieldConstants_h */

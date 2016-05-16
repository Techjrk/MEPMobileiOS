//
//  projectStateConstants.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#ifndef projectStateConstants_h
#define projectStateConstants_h

#import "constants.h"

#define PROJECT_STATE_BUTTON_TEXT_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)
#define PROJECT_STATE_BUTTON_SHADOW_COLOR           RGB(0, 0, 0)

#define PROJECT_STATE_BUTTON_TEXT_COLOR_ACTIVE      RGB(0, 56, 114)
#define PROJECT_STATE_BUTTON_TEXT_COLOR_SELECTED    RGB(255, 255, 255)

#define PROJECT_STATE_BUTTON_BG_COLOR_ACTIVE        RGB(255, 255, 255)
#define PROJECT_STATE_BUTTON_BG_COLOR_SELECTED      RGB(0, 56, 114)

#define PROJECT_STATE_CARET_DOWN_TEXT               [NSString stringWithFormat:@"%C", 0xf0d7]
#define PROJECT_STATE_CARET_DOWN_FONT               fontNameWithSize(FONT_NAME_AWESOME, 11)

#endif /* projectStateConstants_h */

//
//  dropDownMenuConstants.h
//  lecet
//
//  Created by Get Devs on 18/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#ifndef dropDownMenuConstants_h
#define dropDownMenuConstants_h

#define DROPDOWN_MENU_LABEL_USERNAME_FONT                   fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define DROPDOWN_MENU_LABEL_EMAIL_ADDRESS_FONT                  fontNameWithSize(FONT_NAME_LATO_REGULAR, 14)
#define DROPDOWN_MENU_BUTTON_MY_PROFILE_FONT                 fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define DROPDOWN_MENU_BUTTON_HIDDEN_PROJECTS_FONT              fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define DROPDOWN_MENU_BUTTON_SETTINGS_FONT                 fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)

#define DROPDOWN_MENU_LABEL_EMAIL_ADDRESS_FONT_COLOR                  RGB(159, 164, 166)
#define DROPDOWN_MENU_LABEL_USERNAME_FONT_COLOR                    RGB(34, 34, 34)

#define DROPDOWN_MENU_BUTTON_FONT_COLOR                 RGB(72, 72, 72)
#define DROPDOWN_MENU_VIEW_BG_COLOR                 RGB(193, 193, 193)
typedef enum  {
    DropDownMenuMyProfile = 0,
    DropDownMenuHiddenProjects = 1,
    DropDownMenuSettings = 2,
} DropDownMenuItem;
#endif /* dropDownMenuConstants_h */

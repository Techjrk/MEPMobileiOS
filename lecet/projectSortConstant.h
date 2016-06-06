//
//  projectSortConstant.h
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#ifndef projectSortConstant_h
#define projectSortConstant_h


//ProjectSortCell
#define PROJECTSORT_CELL_LABEL_FONT fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define PROJECTSORT_CELL_LABEL_FONT_COLOR RGB(72,72,72)



//ProjectSortView
typedef enum  {
    ProjectSortBidDate = 0,
    ProjectSortLastUpdated = 1,
    ProjectSortDateAdded = 2,
    ProjectSortHightToLow = 3,
    ProjectSortLowToHigh = 4,
    
} ProjectSortItems;

#define PROJECTSORT_SORTTITLE_LABEL_FONT fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define PROJECTSORT_SORTTITLE_LABEL_FONT_COLOR RGB(34,34,34)
#define PROJECTSORT_TITLEVIEW_BG_COLOR RGB(245,245,245)
#define PROJECTSORT_LINE_COLOR RGB(193,193,193)


#endif /* projectSortConstant_h */

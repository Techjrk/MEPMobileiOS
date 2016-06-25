//
//  CompanySortView.h
//  lecet
//
//  Created by Michael San Minay on 18/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum {
    CompanySortItemLastUpdated = 0,
    CompanySortItemLastAlphabetical = 1
    
}CompanySortItem;


#define COMPANYTRACKINGVIEW_LABEL_FONT            fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define COMPANYTRACKINGVIEW_LABEL_FONT_COLOR      RGB(34,34,34)

#define COMPANYTRACKINGVIEW_VIEW_BG_COLOR       RGB(245,245,245)

@protocol CompanySortDelegate <NSObject>
- (void)selectedSort:(CompanySortItem)item;
@end

@interface CompanySortView : BaseViewClass
@property (nonatomic,assign) id <CompanySortDelegate> companySortDelegate;

@end

//
//  EditViewList.h
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

#define COMPANYDATA_NAME                @"name"
#define COMPANYDATA_ADDRESSONE          @"address1"
#define COMPANYDATA_CITY                @"city"
#define COMPANYDATA_COUNTRY             @"country"
#define COMPANYDATA_COUNTY              @"county"
#define COMPANYDATA_STATE               @"state"
#define COMPANYDATA_ZIP5                @"zip5"
#define COMPANYDATA_RECORDID            @"id"
#define COMPANYDATA_BUTTON_STATE        @"button_state"
#define COMPANYDATA_BUTTON_TOSHOW       @"button_to_show"
#define COMPANYDATA_SELECTION_FLAG      @"selctionFlag"

@protocol EditViewListDelegate <NSObject>
- (void)selectedItem:(id)items;
@end

@interface EditViewList : BaseViewClass
@property (nonatomic,assign) id <EditViewListDelegate> editViewListDelegate;
- (void)setInfo:(id)items;
- (void)setInfoToReload:(id)item;
- (id)getData:(id)items;


@end

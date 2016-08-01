//
//  SaveSearchChangeItemView.h
//  lecet
//
//  Created by Michael San Minay on 01/08/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

typedef enum {
    SaveSearchChangeItemCancel = 0,
    SaveSearchChangeItemSave = 1
}SaveSearchChangeItem;


@protocol SaveSearchChangeItemViewDelegate <NSObject>

- (void)tappedButtonSaveSearchesItem:(SaveSearchChangeItem)item;

@end

@interface SaveSearchChangeItemView : BaseViewClass

@property (nonatomic,assign)id <SaveSearchChangeItemViewDelegate> saveSearchChangeItemViewDelegate;

@end

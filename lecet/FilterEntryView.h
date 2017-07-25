//
//  FilterEntryView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"
#import "ProjectFilterView.h"

#define ENTRYTITLE  @"entryTitle"
#define ENTRYID     @"entryID"
#define CELL_FILTER_ORIGINAL_HEIGHT        (kDeviceHeight * 0.035) + ((kDeviceHeight * 0.005) * 2)

typedef enum {
    FilterEntryViewTypeList = 0,
    FilterEntryViewTypeOpenEntry = 1
} FilterEntryViewType;

@protocol FilterEntryViewDelegate <NSObject>
- (void)tappedFilterEntryViewDelegate:(id)object;
- (void)reloadDataBeenComplete:(FilterModel)filterModel;
@end

@interface FilterEntryView : BaseViewClass
@property (weak, nonatomic) id<FilterEntryViewDelegate>filterEntryViewDelegate;
@property (nonatomic) FilterModel filterModel;
@property (nonatomic) FilterEntryViewType entryType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *openEntryFields;
- (void)setTitle:(NSString*)title;
- (void)setInfo:(id)info;
- (void)setHint:(NSString *)text;
- (NSArray *)getCollectionItemsData;
- (void)promptOpenEntryUsingViewController:(UIViewController*)viewController block:(APIBlock)block title:(NSString*)title;
- (BOOL)isEmpty;
@end

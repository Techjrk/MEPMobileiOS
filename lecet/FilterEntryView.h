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

@protocol FilterEntryViewDelegate <NSObject>
- (void)tappedFilterEntryViewDelegate:(id)object;
- (void)reloadDataBeenComplete:(FilterModel)filterModel;
@end

@interface FilterEntryView : BaseViewClass
@property (weak, nonatomic) id<FilterEntryViewDelegate>filterEntryViewDelegate;
@property (nonatomic) FilterModel filterModel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)setTitle:(NSString*)title;
- (void)setInfo:(id)info;
@end

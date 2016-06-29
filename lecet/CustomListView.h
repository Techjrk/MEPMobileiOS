//
//  CustomListView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"
#import "ListItemCollectionViewCell.h"

@protocol CustomListViewDelegate <NSObject>
- (void)listViewItemDidSelected:(ListItemCollectionViewCell*)listViewItem;
@end

@interface CustomListView : BaseViewClass
@property (weak, nonatomic) id<CustomListViewDelegate>customListViewDelegate;
@end

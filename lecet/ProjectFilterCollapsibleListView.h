//
//  ProjectFilterCollapsibleListView.h
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ProjectFilterCollapsibleListViewDelegate <NSObject>
@optional
- (void)tappedSelectionButton:(id)items;
@end

@interface ProjectFilterCollapsibleListView : BaseViewClass
@property(nonatomic,assign) id <ProjectFilterCollapsibleListViewDelegate> projectFilterCollapsibleListViewDelegate;
- (void)setInfo:(NSArray *)item;
- (void)setCollectionViewBounce:(BOOL)bounce;
- (void)setHideLineViewInFirstLayerForSecSubCat:(BOOL)hide;
- (void)replaceInfo:(id)info atSection:(int)section;
- (void)setInfoToReload:(id)info;
@end

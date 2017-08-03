//
//  TrackingListView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol TrackingListViewDelegate <NSObject>
- (void)tappedTrackingListItem:(id)object view:(UIView*)view;
@end

@interface TrackingListView : BaseViewClass
@property (weak, nonatomic) id<TrackingListViewDelegate>trackingListViewDelegate;
@property (strong, nonatomic) NSString *headerTitle;
@property (nonatomic) BOOL isHeaderDisabled;
- (CGFloat)viewHeight;
- (void)setInfo:(id)info;
- (BOOL)isExpandedStatus;
- (void)setExpanded:(BOOL)expanded;
- (BOOL)isExpandedInDefault;
@end

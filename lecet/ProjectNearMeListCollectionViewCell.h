//
//  ProjectNearMeListCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProjectNearMeListCollectionViewCellDelegate
- (void)didSelectItem:(id)sender;
- (void)didTrackItem:(id)sender;
- (void)didShareItem:(id)sender;
- (void)didHideItem:(id)sender;
- (void)didExpand:(id)sender;
- (void)undoHide:(id)sender;
@end

@interface ProjectNearMeListCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<ProjectNearMeListCollectionViewCellDelegate>projectNearMeListCollectionViewCellDelegate;
    @property (strong,nonatomic) NSNumber *projectId;
    @property (strong,nonatomic) NSString *titleNameText;
    @property (strong,nonatomic) NSString *titleAddressText;
    @property (strong,nonatomic) NSString *titleFeetAwayText;
    @property (strong,nonatomic) NSString *titlePriceText;
    @property (strong,nonatomic) NSDictionary *geoCode;
    @property (strong,nonatomic) NSString *unionDesignation;
    @property (strong, nonatomic) NSString *dodgeNumber;
    @property (nonatomic) BOOL hasNoteAndImages;
    - (void)setInitInfo;
    - (void)swipeExpand:(UISwipeGestureRecognizerDirection)direction;
    - (void)resetStatus;
    - (void)projectHidden:(BOOL)hidden;
    - (UIView*)trackButton;
    - (UIView*)shareButton;
@end

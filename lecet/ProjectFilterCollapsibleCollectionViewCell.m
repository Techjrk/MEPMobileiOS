//
//  ProjectFilterCollapsibleCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterCollapsibleCollectionViewCell.h"
#import "ProjectFilterCollapsibleView.h"
#import "ProjectFilterCollapsibleListView.h"

@interface ProjectFilterCollapsibleCollectionViewCell ()<ProjectFilterCollapsibleViewDelegate>
@property (weak, nonatomic) IBOutlet ProjectFilterCollapsibleView *collapsibleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapsibleViewLeftSapcing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collpsibleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seconSubCategoryHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSubCatLeftSpacing;
@property (weak, nonatomic) IBOutlet ProjectFilterCollapsibleListView *secSubCollapsibleListView;

@end

@implementation ProjectFilterCollapsibleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collapsibleView.projectFilterCollapsibleViewDelegate = self;
    _collpsibleHeight.constant = kDeviceHeight * 0.08;
    _seconSubCategoryHeight.constant = kDeviceHeight * 0.08;

}

- (void)setTextLabel:(NSString *)text {
    [_collapsibleView setLabelTitleText:text];
}

- (void)setButtonTag:(int)tag {
    [_collapsibleView setButtonTag:tag];
}

- (void)setSelectionButtonSelected:(BOOL)selected {
    [_collapsibleView setSelectionButtonSelected:selected];
}

- (void)setDropDownSelected:(BOOL)selected {
    [_collapsibleView setDropDonwSelected:selected];
}

- (void)setLeftLineSpacingForLineView:(CGFloat)value {
    [_collapsibleView setLeftSpacingForLineView:value];
}

- (void)setCollapsibleViewLetfSpacing:(CGFloat)value {
    _collapsibleViewLeftSapcing.constant = value;
}
- (void)setIndePathForCollapsible:(NSIndexPath *)index {
    [_collapsibleView setIndexPath:index];
}

- (void)setCollapsibleRightButtonHidden:(BOOL)hide {
    [_collapsibleView setRightButtonHidden:hide];
}

- (void)setLineViewHidden:(BOOL)hide {
    [_collapsibleView setLineViewHidden:hide];
}


#pragma mark - SecSubCat Method 

- (void)setSecSubCatInfo:(id)info {
    [_secSubCollapsibleListView setInfo:info];
}

- (void)setSecSubCatBounce:(BOOL)bounce {
    [_secSubCollapsibleListView setCollectionViewBounce:bounce];
}

- (void)setSecSubCatLeftSpacing:(CGFloat)val {
    _secondSubCatLeftSpacing.constant = val;
}

- (void)setHideLineViewBOOL:(BOOL)hide {
    
    [_secSubCollapsibleListView setHideLineViewInFirstLayerForSecSubCat:hide];
}

#pragma mark - CollapsibleView Delegate

- (void)tappedSelectionButton:(id)tag senderView:(UIView *)senderView{
 
    if (senderView == _collapsibleView) {
       [_projectFilterCollapsibleCollectionViewCellDelegate tappedSelectionButton:tag];
    }
    
    
    
}

- (void)tappedDropDownButton:(id)tag senderView:(UIView *)senderView{
    if (senderView == _collapsibleView) {
        [_projectFilterCollapsibleCollectionViewCellDelegate tappedDropDownButton:tag];
    }
}


@end

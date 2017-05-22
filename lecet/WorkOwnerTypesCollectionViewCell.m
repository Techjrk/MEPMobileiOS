//
//  WorkOwnerTypesCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 30/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "WorkOwnerTypesCollectionViewCell.h"
#import "ProjectFilterCollapsibleView.h"

@interface WorkOwnerTypesCollectionViewCell ()<ProjectFilterCollapsibleViewDelegate>
@property (weak, nonatomic) IBOutlet ProjectFilterCollapsibleView *collapsibleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collpsibleHeight;

@end

@implementation WorkOwnerTypesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collapsibleView.projectFilterCollapsibleViewDelegate = self;
    _collpsibleHeight.constant = kDeviceHeight * 0.08;
    [_collapsibleView setRightButtonHidden:YES];
}

- (void)setTextLabel:(NSString *)text {
    [_collapsibleView setLabelTitleText:text];
}

- (void)setIndexPath:(NSIndexPath *)index {
    [_collapsibleView setIndexPath:index];
}

- (void)setSelectionButtonSelected:(BOOL)selected {
    [_collapsibleView setSelectionButtonSelected:selected];
}

#pragma mark - CollapsibleView Delegate

- (void)tappedSelectionButton:(id)tag senderView:(UIView *)senderView{
    [_workOwnerTypesCollectionViewCellDelegate tappedSelectionButton:tag];
}

- (void)tappedDropDownButton:(id)tag senderView:(UIView *)senderView{
}

@end

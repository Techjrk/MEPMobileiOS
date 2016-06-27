//
//  ProjectFilterCollapsibleCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterCollapsibleCollectionViewCell.h"
#import "ProjectFilterCollapsibleView.h"

@interface ProjectFilterCollapsibleCollectionViewCell ()<ProjectFilterCollapsibleViewDelegate>
@property (weak, nonatomic) IBOutlet ProjectFilterCollapsibleView *collapsibleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapsibleViewLeftSapcing;

@end

@implementation ProjectFilterCollapsibleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collapsibleView.projectFilterCollapsibleViewDelegate = self;
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

#pragma mark - CollapsibleView Delegate

- (void)tappedSelectionButton:(id)tag {
 
    [_projectFilterCollapsibleCollectionViewCellDelegate tappedSelectionButton:tag];
}

- (void)tappedDropDownButton:(id)tag {
    [_projectFilterCollapsibleCollectionViewCellDelegate tappedDropDownButton:tag];
}


@end

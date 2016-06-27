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


#pragma mark - CollapsibleView Delegate

- (void)tappedSelectionButton:(int)tag {
 
    [_projectFilterCollapsibleCollectionViewCellDelegate tappedSelectionButton:tag];
}

- (void)tappedDropDownButton:(int)tag {
    [_projectFilterCollapsibleCollectionViewCellDelegate tappedDropDownButton:tag];
}

@end

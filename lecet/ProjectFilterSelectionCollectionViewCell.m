//
//  ProjectFilterSelectionCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterSelectionCollectionViewCell.h"
#import "ProjectFilterSelectionView.h"

@interface ProjectFilterSelectionCollectionViewCell ()<ProjectFilterSelectionViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet ProjectFilterSelectionView *projectFilterSelectionView;
@end

@implementation ProjectFilterSelectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _projectFilterSelectionView.projectFilterSelectionViewDelegate = self;
}

- (void)setLabelText:(NSString *)text {
    [_projectFilterSelectionView setLabelTitleText:text];
}

- (void)setButtonSelected:(BOOL)selected {
    [_projectFilterSelectionView setCheckButtonSelected:selected];
}

- (void)setButtonTag:(int)tag {
    [_projectFilterSelectionView setButtonTag:tag];
}

- (void)tappedCheckButtonAtTag:(int)tag {
    [_projectFilterSelectionCollectionViewCellDelegate tappedCheckButtonAtTag:tag];
}
@end

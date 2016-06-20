//
//  EditViewCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "EditViewCollectionViewCell.h"
#import "EditView.h"
@interface EditViewCollectionViewCell ()<EditViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet EditView *editTrackingView;

@end
@implementation EditViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _editTrackingView.editViewDelegate = self;
}

- (BOOL)isButtonSelected {
    
    return [_editTrackingView isButtonSelected];
}

- (void)setButtonTag:(int)tag {
    [_editTrackingView setButtonTag:tag];
}

- (void)setAddressOneText:(NSString *)text {
    [_editTrackingView setAddressOneText:text];
}

- (void)setAddressTwoTex:(NSString *)text {
    [_editTrackingView setAddressTwoText:text];
}

- (void)setButtonSelected:(BOOL)select {
    [_editTrackingView setButotnSelected:select];
}

#pragma mark - Edit View Delegate
- (void)tappedButtonSelect {
    [_editViewCollectionViewCellDelegate tappedButtonSelect];
}
- (void)tappedButtonSelectAtTag:(int)tag {
    [_editViewCollectionViewCellDelegate tappedButtonSelectAtTag:tag];
}



@end

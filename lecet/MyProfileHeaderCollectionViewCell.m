//
//  MyProfileHeaderCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileHeaderCollectionViewCell.h"
#import "MyProfileHeaderView.h"


@interface MyProfileHeaderCollectionViewCell ()
@property (weak, nonatomic) IBOutlet MyProfileHeaderView *myProfileHeaderView;

@end

@implementation MyProfileHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setHeaderLeftTitle:(NSString *)title {
    [_myProfileHeaderView setLeftLabelText:title];
}

- (void)setHeaderRightTitle:(NSString *)title {
    [_myProfileHeaderView setRightLabelText:title];
}

- (void)hideRightLabel:(BOOL)hide {
    [_myProfileHeaderView hideRightLabel:hide];
}


@end

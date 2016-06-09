//
//  MyProfileHeaderView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileHeaderView.h"

@interface MyProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation MyProfileHeaderView

- (void)awakeFromNib {
    
}


- (void)setLeftLabelText:(NSString *)text {
    _leftLabel.text = text;
}

- (void)setRightLabelText:(NSString *)text {
    _rightLabel.text = text;
}

- (void)hideLeftLabel:(BOOL)hide {
    [_leftLabel setHidden:hide];
}

- (void)hideRightLabel:(BOOL)hide {
    [_rightLabel setHidden:hide];
    
}

@end

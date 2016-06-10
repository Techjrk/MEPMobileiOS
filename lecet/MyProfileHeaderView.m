//
//  MyProfileHeaderView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileHeaderView.h"
#import "myProfileConstant.h"

@interface MyProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation MyProfileHeaderView

- (void)awakeFromNib {
    
    _leftLabel.font = MYPROFILE_HEADER_LABEL_FONT;
    _leftLabel.textColor = MYPROFILE_HEADER_LABEL_FONT_COLOR;
    
    _rightLabel.font = MYPROFILE_HEADER_LABEL_FONT;
    _rightLabel.textColor = MYPROFILE_HEADER_LABEL_FONT_COLOR;
    
    [self.view setBackgroundColor:MYPROFILE_HEADER_BG_COLOR];
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

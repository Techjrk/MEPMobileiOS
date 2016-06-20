//
//  EditView.m
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "EditView.h"
#import "editViewConstant.h"
@interface EditView (){
    
    BOOL isSelected;
}
@property (weak, nonatomic) IBOutlet UIButton *selctedButton;
@property (weak, nonatomic) IBOutlet UILabel *addressOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTwoLabel;

@end

@implementation EditView

- (void)awakeFromNib {
    
    _addressOneLabel.font = EDITVIEW_TOP_LABEL_FONT;
    _addressOneLabel.textColor = EDITVIEW_TOP_LABEL_FONT_COLOR;
    
    _addressTwoLabel.font = EDITVIEW_BELOW_LABEL_FONT;
    _addressTwoLabel.textColor = EDITVIEW_BELOW_LABEL_FONT_COLOR;
}


- (BOOL)isButtonSelected {
    return [_selctedButton isSelected];
}

- (IBAction)tappedSelectedButton:(id)sender {
    UIButton *button = sender;
    /*
    if (isSelected) {
        isSelected = NO;
        [_selctedButton setSelected:NO];
    }else {
        isSelected = YES;
        [_selctedButton setSelected:YES];
        
    }*/
    
    [_editViewDelegate tappedButtonSelectAtTag:(int)button.tag];
   //[_editViewDelegate tappedButtonSelect];
    
}

- (void)setButtonTag:(int)tag {
    [_selctedButton setTag:tag];
}


- (void)setAddressOneText:(NSString *)text {
    _addressOneLabel.text = text;
}

- (void)setAddressTwoText:(NSString *)text {
    _addressTwoLabel.text = text;
}


- (void)setButotnSelected:(BOOL)selected {
    [_selctedButton setSelected:selected];
}

@end

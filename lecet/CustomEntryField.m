//
//  CustonEntryField.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomEntryField.h"

#import "customEntryFieldConstants.h"

@interface CustomEntryField(){
    NSLayoutConstraint *heightConstraint;
}
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelLine1;
@property (weak, nonatomic) IBOutlet UILabel *labelLine2;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSpace;
@end

@implementation CustomEntryField

- (void)awakeFromNib {
    _labelName.font = CUSTOM_ENTRYFIELD_LABEL_FONT;
    _labelName.textColor = CUSTOM_ENTRYFIELD_LABEL_COLOR;
    
    _labelLine1.font = CUSTOM_ENTRYFIELD_LINE1_FONT;
    _labelLine1.textColor = CUSTOM_ENTRYFIELD_LINE1_COLOR;
    
    _labelLine2.font = CUSTOM_ENTRYFIELD_LINE2_FONT;
    _labelLine2.textColor = CUSTOM_ENTRYFIELD_LINE2_COLOR;
    
    _labelName.text = @"County";
    _labelLine1.text = @"El Dorado";
    _labelLine2.text = nil;
    
    _lineView.backgroundColor = [CUSTOM_ENTRYFIELD_BOTTOM_LINE_COLOR colorWithAlphaComponent:0.5];
    
    _constraintTopSpace.constant = kDeviceHeight * 0.015;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setTitle:(NSString *)title line1Text:(NSString *)line1Text line2Text:(NSString *)line2Text {
    _labelName.text = title;
    _labelLine1.text = line1Text;
    _labelLine2.text = line2Text;
}

-(void)changeConstraintHeight:(NSLayoutConstraint *)constraint {
    heightConstraint = constraint;
}

- (void)layoutSubviews {
    UILabel *label = _labelLine2.text != nil | _labelLine2.text.length == 0? _labelLine2:_labelLine1;
    heightConstraint.constant = label.frame.origin.y+ label.frame.size.height + (kDeviceHeight * 0.008);
}

@end

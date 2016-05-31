//
//  ContactFieldView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactFieldView.h"

#import "contactFieldConstants.h"

@interface ContactFieldView(){
    ContactFieldType fieldType;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageHeight;
@end

@implementation ContactFieldView

- (void)awakeFromNib {
    _label.font = CONTACT_FIELD_LABEL_FONT;
    _label.textColor = CONTACT_FIELD_LABEL_COLOR;
}

- (void)setInfo:(id)info{
    NSDictionary *infoDict = info;
    
    fieldType = (ContactFieldType)[infoDict[CONTACT_FIELD_TYPE] integerValue];
    
    UIImage *image = nil;
    switch (fieldType) {
        case ContactFieldTypePhone:{
            image = [UIImage imageNamed:@"icon_phone"];
            break;
        }
        case ContactFieldTypeEmail:{
            image = [UIImage imageNamed:@"icon_email"];
            _constraintImageHeight.constant = (kDeviceHeight * -0.005);
            break;
        }
        case ContactFieldTypeWeb:{
            image = [UIImage imageNamed:@"icon_web"];
            _constraintImageHeight.constant = (kDeviceHeight * 0.005);
            break;
        }
    }
    _label.attributedText = [[NSAttributedString alloc] initWithString:infoDict[CONTACT_FIELD_DATA] attributes:@{NSFontAttributeName:CONTACT_FIELD_LABEL_FONT, NSForegroundColorAttributeName:CONTACT_FIELD_LABEL_COLOR, NSUnderlineStyleAttributeName:[NSNumber numberWithBool:YES]}];
    _imageView.image = image;
}

@end

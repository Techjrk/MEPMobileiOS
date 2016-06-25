//
//  ContactFieldView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactFieldView.h"

#define CONTACT_FIELD_LABEL_FONT                fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define CONTACT_FIELD_LABEL_COLOR               RGB(34, 34, 34)
#define CONTACT_COMPANY_NAME_FIELD_FONT_COLOR   RGB(76,145,209)

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

- (void)setInfo:(id)info {
    NSDictionary *infoDict = info;
    
    fieldType = (ContactFieldType)[infoDict[CONTACT_FIELD_TYPE] integerValue];
    NSMutableAttributedString *attributedText;
    
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
        case ContactFieldTypeAccount:{
            image = [UIImage imageNamed:@"Shape"];
            _constraintImageHeight.constant = (kDeviceHeight * 0.01);
            break;
        }
        case ContactFieldTypeLocation:{
            image = [UIImage imageNamed:@"icon_pin"];
            _constraintImageHeight.constant = (kDeviceHeight * 0.005);
            break;
        }
    }
    
    
    if (fieldType == ContactFieldTypeAccount) {
        
        NSString *separatorString = @" at ";
        NSArray *components = [infoDict[CONTACT_FIELD_DATA] componentsSeparatedByString:separatorString];
        NSString *title = components[0];
        NSString *compnayName = components[1];
        
        attributedText = [[NSMutableAttributedString alloc] initWithString:infoDict[CONTACT_FIELD_DATA] attributes:@{NSFontAttributeName:CONTACT_FIELD_LABEL_FONT, NSForegroundColorAttributeName:CONTACT_FIELD_LABEL_COLOR}];
        [attributedText addAttribute:NSForegroundColorAttributeName value:CONTACT_COMPANY_NAME_FIELD_FONT_COLOR range:NSMakeRange(title.length + separatorString.length, compnayName.length)];
        _label.numberOfLines = 0;
        _label.adjustsFontSizeToFitWidth = YES;
        
    
    }else if (fieldType == ContactFieldTypeLocation) {
        
        attributedText = [[NSMutableAttributedString alloc] initWithString:infoDict[CONTACT_FIELD_DATA] attributes:@{NSFontAttributeName:CONTACT_FIELD_LABEL_FONT, NSForegroundColorAttributeName:CONTACT_FIELD_LABEL_COLOR}];
        _label.numberOfLines = 0;
        _label.adjustsFontSizeToFitWidth = YES;
    }
    
    else{

        attributedText = [[NSMutableAttributedString alloc] initWithString:infoDict[CONTACT_FIELD_DATA] attributes:@{NSFontAttributeName:CONTACT_FIELD_LABEL_FONT, NSForegroundColorAttributeName:CONTACT_FIELD_LABEL_COLOR, NSUnderlineStyleAttributeName:[NSNumber numberWithBool:YES]}];
        
    }
    
    _label.attributedText = attributedText;
    _imageView.image = image;
}


@end

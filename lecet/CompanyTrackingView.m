//
//  CompanyTrackingView.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyTrackingView.h"
#import <MapKit/MapKit.h>
#import "companyTrackingViewConstant.h"

@interface CompanyTrackingView ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *address2Label;

@property (weak, nonatomic) IBOutlet UIView *mapAndLabelInfoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapLabelContainerConstraintHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonBelow;
@property (weak, nonatomic) IBOutlet UIView *containerButtonView;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

@end

@implementation CompanyTrackingView

- (void)awakeFromNib {
    
    _nameLabel.font = COMPANYTRACKINGVIEW_LABEL_NAME_FONT;
    _nameLabel.textColor = COMPANYTRACKINGVIEW_LABEL_NAME_FONT_COLOR;
    
    _addressLabel.font = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT;
    _addressLabel.textColor = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT_COLOR;
    _address2Label.font = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT;
    _address2Label.textColor = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT_COLOR;
    
    [_buttonBelow setBackgroundColor:COMPANYTRACKINGVIEW_BUTTON_BG_COLOR];
    _buttonLabel.textColor = COMPANYTRACKINGVIEW_BUTTON_LABEL_FONT_COLOR;
    _buttonLabel.font = COMPANYTRACKINGVIEW_BUTTON_LABEL_FONT;
    [_containerButtonView.layer setCornerRadius:4.0f];
    _containerButtonView.layer.masksToBounds = YES;
    
    
    [self setName:@"ERS Industrial Services Inc"];
    [self setAddress:@"38881 Schoolcraft Rd"];
    [self setAddressTwo:@"Livonia, MI 48150-1033"];
    
}


- (void)setName:(NSString *)name {
    _nameLabel.text = name;
}

- (void)setAddress:(NSString *)address {
    /*
    NSString * addressWithSpace = [NSString stringWithFormat:@" %@",address];
    NSTextAttachment *attachment = [NSTextAttachment new];
    attachment.image = [UIImage imageNamed:@"icon_bidLocation"];
    
    NSMutableAttributedString *stringWithAttachment = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:addressWithSpace attributes:@{NSFontAttributeName:COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT, NSForegroundColorAttributeName:COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT_COLOR}];
    [stringWithAttachment appendAttributedString:attributed];
     _addressLabel.attributedText = stringWithAttachment;
    */
    
     _addressLabel.text = address;
    
    
}

- (void)setAddressTwo:(NSString *)address {
    _address2Label.text = address;
}


- (void)setButtonLabelTitle:(NSString *)text {
    _buttonLabel.text = text;
    
}

- (IBAction)tappedButton:(id)sender {
 
    UIButton *button = sender;
    int tag = (int)button.tag;
    [_companyTrackingViewDelegate tappedButtonAtTag:tag];
    
}

- (void)setButtonTag:(int)tag {

    [_buttonBelow setTag:tag];
}


@end

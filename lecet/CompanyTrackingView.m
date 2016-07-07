//
//  CompanyTrackingView.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyTrackingView.h"
#import <MapKit/MapKit.h>

#define COMPANYTRACKINGVIEW_LABEL_NAME_FONT             fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define COMPANYTRACKINGVIEW_LABEL_NAME_FONT_COLOR       RGB(34,34,34)

#define COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT          fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT_COLOR    RGB(159,164,166)

#define COMPANYTRACKINGVIEW_BUTTON_LABEL_FONT           fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define COMPANYTRACKINGVIEW_BUTTON_LABEL_FONT_COLOR     RGB(255,255,255)
#define COMPANYTRACKINGVIEW_BUTTON_BG_COLOR             RGB(76,145,209)


#define COMPANYTRACKINGVIEW_TEXTVIEW_BG_COLOR           RGB(76,145,209)
#define COMPANYTRACKINGVIEW_TEXTVIEW_FONT               fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)

#define COMPANYTRACKINGVIEW_TEXTVIEW_FONT_COLOR         RGB(255,255,255)

@interface CompanyTrackingView () {
    BOOL dataIsShown;
}
@property (weak, nonatomic) IBOutlet UIView *belowContainerView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *address2Label;

@property (weak, nonatomic) IBOutlet UIView *mapAndLabelInfoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapLabelContainerConstraintHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonBelow;
@property (weak, nonatomic) IBOutlet UIView *containerButtonView;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *containerTextView;
@property (weak, nonatomic) IBOutlet UILabel *labelUpdateDescription;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;

@property (weak, nonatomic) IBOutlet UIImageView *caretImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerButtonAndTextHeight;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageIcon;

@end

@implementation CompanyTrackingView

- (void)awakeFromNib {
    
    
    _mapLabelContainerConstraintHeight.constant = kDeviceHeight * 0.132f;
    _constraintContainerButtonAndTextHeight.constant = kDeviceHeight * 0.175f;

    _nameLabel.font = COMPANYTRACKINGVIEW_LABEL_NAME_FONT;
    _nameLabel.textColor = COMPANYTRACKINGVIEW_LABEL_NAME_FONT_COLOR;
    
    _addressLabel.font = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT;
    _addressLabel.textColor = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT_COLOR;
    _address2Label.font = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT;
    _address2Label.textColor = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT_COLOR;
    
    [_buttonBelow setBackgroundColor:COMPANYTRACKINGVIEW_BUTTON_BG_COLOR];
    _buttonLabel.textColor = COMPANYTRACKINGVIEW_BUTTON_LABEL_FONT_COLOR;
    _buttonLabel.font = COMPANYTRACKINGVIEW_BUTTON_LABEL_FONT;
    
    CGFloat corderRadius = kDeviceWidth * 0.015;
    [_containerButtonView.layer setCornerRadius:corderRadius];
    _containerButtonView.layer.masksToBounds = YES;
    
    
    _textView.textColor = COMPANYTRACKINGVIEW_TEXTVIEW_FONT_COLOR;
    _textView.font =    COMPANYTRACKINGVIEW_TEXTVIEW_FONT;
    
    _labelUpdateDescription.font = COMPANYTRACKINGVIEW_TEXTVIEW_FONT;
    _labelUpdateDescription.textColor = COMPANYTRACKINGVIEW_TEXTVIEW_FONT_COLOR;
    [_labelContainer.layer setCornerRadius:corderRadius];
    _labelContainer.layer.masksToBounds = YES;
    
    
    [_containerTextView.layer setCornerRadius:corderRadius];
    _containerTextView.layer.masksToBounds = YES;
    [_textView.layer setCornerRadius:corderRadius];
    _textView.layer.masksToBounds = YES;
    
    [_containerTextView setBackgroundColor:COMPANYTRACKINGVIEW_TEXTVIEW_BG_COLOR];

    _caretImageView.image = [UIImage imageNamed:@"caretDown_icon"];
    
}


- (void)setName:(NSString *)name {
    _nameLabel.text = name;
}

- (void)setAddress:(NSString *)address {
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

- (void)setTextViewHidden:(BOOL)hide {
    [_textView setHidden:hide];
}

- (void)changeCaretToUp:(BOOL)up {
    
    if (up) {
        _caretImageView.image = [UIImage imageNamed:@"caretUp_icon"];
        [_containerTextView setHidden:NO];
        
    } else {
        _caretImageView.image = [UIImage imageNamed:@"caretDown_icon"];
        [_containerTextView setHidden:YES];
    }
}

- (void)setImage:(id)info {

    NSString *summary =  info;
    if (summary.length > 0) {
        _rightImageIcon.image = [UIImage imageNamed:@"icon_trackUpdateTypeBid"];
    }
    
}

- (void)setLabelDescription:(NSString *)text {
    _labelUpdateDescription.text = text;
}


@end

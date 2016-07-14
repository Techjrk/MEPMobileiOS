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

@property (weak, nonatomic) IBOutlet UIView *containerTextView;
@property (weak, nonatomic) IBOutlet UILabel *labelUpdateDescription;
@property (weak, nonatomic) IBOutlet UILabel *leftLabelPriceDesc;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;

@property (weak, nonatomic) IBOutlet UIImageView *caretImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerButtonAndTextHeight;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageIcon;

@end

@implementation CompanyTrackingView

- (void)awakeFromNib {
    
    
    _mapLabelContainerConstraintHeight.constant = kDeviceHeight * 0.132f;
    _constraintContainerButtonAndTextHeight.constant = kDeviceHeight * 0.17f;

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
    
    _labelUpdateDescription.font = COMPANYTRACKINGVIEW_TEXTVIEW_FONT;
    _labelUpdateDescription.textColor = COMPANYTRACKINGVIEW_TEXTVIEW_FONT_COLOR;
    _leftLabelPriceDesc
    .font = COMPANYTRACKINGVIEW_TEXTVIEW_FONT;
    _leftLabelPriceDesc.textColor = COMPANYTRACKINGVIEW_TEXTVIEW_FONT_COLOR;
    
    [_labelContainer.layer setCornerRadius:corderRadius];
    _labelContainer.layer.masksToBounds = YES;
    
    
    [_containerTextView.layer setCornerRadius:corderRadius];
    _containerTextView.layer.masksToBounds = YES;

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

    NSString *modelType =  info;
    
    if ([modelType isEqual:@"ProjectContact"]) {
        _rightImageIcon.image = [UIImage imageNamed:@"addAcct_icon"];
        [_labelUpdateDescription setTextAlignment:NSTextAlignmentLeft];
    
    }
    
    if ([modelType isEqual:@"Bid"]) {
        _rightImageIcon.image = [UIImage imageNamed:@"icon_trackUpdateTypeBid"];
        [_labelUpdateDescription setTextAlignment:NSTextAlignmentLeft];
        
    }
    
}

- (void)setLabelDescription:(NSString *)text {
    _labelUpdateDescription.text = text;
}

- (void)searchForLocationGeocode {
    [self searchRecursiveLocationGeocode:NO];
}

- (void)searchRecursiveLocationGeocode:(BOOL)failSearchZip {
    
    NSString *address;
    NSArray *addressTwoArray = [_address2Label.text componentsSeparatedByString:@" "];
    NSString *zip = [DerivedNSManagedObject objectOrNil:[addressTwoArray objectAtIndex:2]];
    NSString *city = [DerivedNSManagedObject objectOrNil:[addressTwoArray objectAtIndex:0]];
    NSString *state = [DerivedNSManagedObject objectOrNil:[addressTwoArray objectAtIndex:1]];
    
    if (failSearchZip) {
        address = [NSString stringWithFormat:@"%@, %@",city,state];
    }else {
        if ([zip isEqual:@"<null>"] || zip == nil) {
            address = [NSString stringWithFormat:@"%@ %@",_addressLabel.text,_address2Label.text];
        } else {
            address = [addressTwoArray objectAtIndex:2];
        }
    }
    
    NSString *location = address;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     if (placemarks && placemarks.count > 0) {
                         
                         CLPlacemark *result = [placemarks objectAtIndex:0];
                         [self setMapInfoLatitude:result];
                         
                     } else if (error != nil) {
                        
                         [self searchRecursiveLocationGeocode:YES];
                     }
                 }
     ];
    
}

- (void)setMapInfoLatitude:(CLPlacemark *)coord {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(coord.location.coordinate.latitude, coord.location.coordinate.longitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView setRegion:region];
    [_mapView addAnnotation:annotation];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *userAnnotationView = nil;
    if (![annotation isKindOfClass:MKUserLocation.class])
    {
        userAnnotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"UserLocation"];
        if (userAnnotationView == nil)  {
            userAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];
        }
        else
            userAnnotationView.annotation = annotation;
        
        userAnnotationView.enabled = NO;
        
        userAnnotationView.canShowCallout = NO;
        userAnnotationView.image = [UIImage imageNamed:@"icon_pin"];
        
    }
    
    return userAnnotationView;
    
}

@end

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

@property (weak, nonatomic) IBOutlet UIView *mapAndLabelInfoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapLabelContainerConstraintHeight;

@end

@implementation CompanyTrackingView

- (void)awakeFromNib {
    
    _nameLabel.font = COMPANYTRACKINGVIEW_LABEL_NAME_FONT;
    _nameLabel.textColor = COMPANYTRACKINGVIEW_LABEL_NAME_FONT_COLOR;
    
    _addressLabel.font = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT;
    _addressLabel.textColor = COMPANYTRACKINGVIEW_LABEL_ADDRESS_FONT_COLOR;
    
}

@end

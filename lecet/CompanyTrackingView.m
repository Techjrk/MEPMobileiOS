//
//  CompanyTrackingView.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyTrackingView.h"
#import <MapKit/MapKit.h>

@interface CompanyTrackingView ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *mapAndLabelInfoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapLabelContainerConstraintHeight;

@end

@implementation CompanyTrackingView


@end

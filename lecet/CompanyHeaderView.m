//
//  CompanyHeaderView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyHeaderView.h"
#import <MapKit/MapKit.h>
#import "companyHeaderConstants.h"

@interface CompanyHeaderView()<MKMapViewDelegate>{
    CGFloat geoCodeLat;
    CGFloat geoCodeLng;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
- (IBAction)tappedButton:(id)sender;
@end

@implementation CompanyHeaderView

- (void)awakeFromNib {
 
    self.view.backgroundColor = COMPANY_HEADER_BG_COLOR;
    _viewInfo.backgroundColor = COMPANY_HEADER_INFO_BG_COLOR;
    
    _labelTitle.font = COMPANY_HEADER_TITLE_TEXT_FONT;
    _labelTitle.textColor = COMPANY_HEADER_TITLE_TEXT_COLOR;
}

- (void)setHeaderInfo:(id)headerInfo {
    
    NSDictionary *info = headerInfo;
    
    _labelTitle.text = info[COMPANY_TITLE];
    geoCodeLat = [info[COMPANY_GEOCODE_LAT] floatValue];
    geoCodeLng = [info[COMPANY_GEOCODE_LNG] floatValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoCodeLat, geoCodeLng);
    
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
        userAnnotationView.image = [UIImage imageNamed:@"icon_pinOrange"];
        
    }
    
    return userAnnotationView;
    
}

- (IBAction)tappedButton:(id)sender {
    [self.companyCampanyHeaderDelegate tappedCompanyMapViewLat:geoCodeLat lng:geoCodeLng];
}

- (CGRect)mapFrame {
    return _mapView.frame;
}

@end

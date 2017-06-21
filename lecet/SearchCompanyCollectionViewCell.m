//
//  SearchCompanyCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchCompanyCollectionViewCell.h"
#import <MapKit/MapKit.h>

#define LABEL_TITLE_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_TITLE_COLOR                   RGB(34, 34, 34)

#define LABEL_LOCATION_FONT                 fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_LOCATION_COLOR                RGB(159, 164, 166)

@interface SearchCompanyCollectionViewCell()<MKMapViewDelegate>{
    CGFloat geoCodeLat;
    CGFloat geoCodeLng;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation SearchCompanyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelTitle.font = LABEL_TITLE_FONT;
    _labelTitle.textColor = LABEL_TITLE_COLOR;
    _labelTitle.text = @"Sims Bayou Line Work";
    
    _labelLocation.font = LABEL_LOCATION_FONT;
    _labelLocation.textColor = LABEL_LOCATION_COLOR;
    _labelLocation.text = @"Houston, TX";
    
    _lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];

}

- (void)setInfo:(id)info {

    NSDictionary *item = info;
    
    _labelTitle.text = item[@"name"];
    
    NSString *addr = @"";

    NSString *address = [DerivedNSManagedObject objectOrNil:item[@"address1"]];
    NSString *county = [DerivedNSManagedObject objectOrNil:item[@"county"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:item[@"state"]];
    NSString *zip = [DerivedNSManagedObject objectOrNil:item[@"zip5"]];
    
    if (address != nil) {
        addr = [addr stringByAppendingString:address];
        
        if (county != nil) {
            addr = [addr stringByAppendingString:@"\n"];
            
        }
    }
    
    if (county != nil) {
        addr = [addr stringByAppendingString:county];
        
        if (state != nil) {
            addr = [addr stringByAppendingString:@", "];
        }
    }
    
    if (state != nil) {
        addr = [addr stringByAppendingString:state];
        if (zip != nil) {
            [addr stringByAppendingString:@" "];
        }
    }
    
    if (zip != nil) {
        addr = [addr stringByAppendingString:[@" " stringByAppendingString:zip]];

    }
    _labelLocation.text = addr;

    [self searchRecursiveLocationGeocode];
}

- (void)searchRecursiveLocationGeocode {
    
    NSString *location = _labelLocation.text;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     if (placemarks && placemarks.count > 0) {
                         
                         CLPlacemark *result = [placemarks objectAtIndex:0];
                         [self setMapInfoLatitude:result];
                         
                     } else if (error != nil) {
                         
                         //[self searchRecursiveLocationGeocode:YES];
                     }
                 }
     ];
    
}

- (void)setMapInfoLatitude:(CLPlacemark *)coord {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(coord.location.coordinate.latitude, coord.location.coordinate.longitude);
    
    geoCodeLat = coord.location.coordinate.latitude;
    geoCodeLng = coord.location.coordinate.longitude;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    
    _mapView.delegate = nil;
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView setRegion:region];
    _mapView.delegate = self;
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

@end

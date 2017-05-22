//
//  ProjectHeaderView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/12/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectHeaderView.h"

#import <MapKit/MapKit.h>

#define PROJECT_HEADER_BG_COLOR                     RGB(19, 86, 141)
#define PROJECT_HEADER_INFO_BG_COLOR                RGB(248, 153, 0)

#define PROJECT_HEADER_TITLE_TEXT_COLOR             RGB(255, 255, 255)
#define PROJECT_HEADER_TITLE_TEXT_FONT              fontNameWithSize(FONT_NAME_LATO_BLACK, 17)

#define PROJECT_LOCATION_TEXT_COLOR                 RGB(255, 255, 255)
#define PROJECT_LOCATION_TEXT_FONT                  fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)

@interface ProjectHeaderView()<MKMapViewDelegate>{
    CGFloat geoCodeLat;
    CGFloat geoCodeLng;
}
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)tappedButton:(id)sender;
@end

@implementation ProjectHeaderView
@synthesize projectHeaderDelegate;
@synthesize pinType;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.view.backgroundColor = PROJECT_HEADER_BG_COLOR;
    _viewInfo.backgroundColor = PROJECT_HEADER_INFO_BG_COLOR;
    
    _labelTitle.font = PROJECT_HEADER_TITLE_TEXT_FONT;
    _labelTitle.textColor = PROJECT_HEADER_TITLE_TEXT_COLOR;
    _labelTitle.text = @"Metro Youth Service Center (Improvements)";
    
    _labelLocation.textColor = PROJECT_LOCATION_TEXT_COLOR;
    _labelLocation.font = PROJECT_LOCATION_TEXT_FONT;
}

- (void)setHeaderInfo:(id)headerInfo {
    NSDictionary *info = headerInfo;
    
    _labelTitle.text = info[PROJECT_TITLE];
    _labelLocation.text = info[PROJECT_LOCATION];
    geoCodeLat = [info[PROJECT_GEOCODE_LAT] floatValue];
    geoCodeLng = [info[PROJECT_GEOCODE_LNG] floatValue];
    

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
        switch (self.pinType) {
            case pinTypeOrange:
                userAnnotationView.image = [UIImage imageNamed:@"icon_pinOrange"];
                break;
                
            case pinTypeOrageUpdate:
                userAnnotationView.image = [UIImage imageNamed:@"icon_dodgeProjectUpdates"];
                break;
                
            case pinTypeUser:
                userAnnotationView.image = [UIImage imageNamed:@"icon_userProject"];
                break;
           
            default:
                userAnnotationView.image = [UIImage imageNamed:@"icon_userProjectUpdates"];
                break;
        }
        
    }
    
    return userAnnotationView;
    
}

- (IBAction)tappedButton:(id)sender {
    [self.projectHeaderDelegate tappedProjectMapViewLat:geoCodeLat lng:geoCodeLng];
}

- (CGRect)mapFrame {
    return _mapView.frame;
}

- (CLLocation *)location {
    MKPointAnnotation *annotation = _mapView.annotations[0];
    return [[CLLocation new] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
}
@end

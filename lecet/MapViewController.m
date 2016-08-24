//
//  MapViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/19/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>

#define COMPANY_DIRECTION                           fontNameWithSize(FONT_NAME_LATO_BLACK, 12)

@interface MapViewController ()<MKMapViewDelegate>{
    CGFloat geoLat;
    CGFloat geoLng;
    BOOL isMapLoaded;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *buttonDirection;
- (IBAction)tappedButton:(id)sender;
- (IBAction)tappedButtonDirection:(id)sender;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UpdateLocation];
    [_buttonDirection setTitle:NSLocalizedLanguage(@"COMPANY_HEADER_DIRECTION") forState:UIControlStateNormal];
    _buttonDirection.titleLabel.font = COMPANY_DIRECTION;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)UpdateLocation {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoLat, geoLng);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coordinate, span};
    [_mapView setRegion:region];
}

- (void)addAnnotation {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoLat, geoLng);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:annotation];
}

- (void)setLocationLat:(CGFloat)lat lng:(CGFloat)lng {
    geoLat = lat;
    geoLng = lng;
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (IBAction)tappedButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedButtonDirection:(id)sender {
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake(geoLat, geoLng);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isMapLoaded) {
        isMapLoaded = YES;
        _button.hidden = NO;
        [self addAnnotation];
    }
}
@end

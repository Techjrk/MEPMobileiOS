//
//  RecentSearchItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "RecentSearchItemCollectionViewCell.h"

#import <MapKit/MapKit.h>

#define TITLE_FONT                  fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)
#define TITLE_COLOR                 RGB(16, 16, 15)

@interface RecentSearchItemCollectionViewCell()<MKMapViewDelegate>{
    NSNumber *recordId;
    BOOL isProject;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation RecentSearchItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelTitle.font = TITLE_FONT;
    _labelTitle.textColor = TITLE_COLOR;
}

- (void)setInfo:(id)info {
    
    recordId = [DerivedNSManagedObject objectOrNil:info[@"projectId"]];
    isProject = YES;

    if (recordId == nil) {
    
        recordId = [DerivedNSManagedObject objectOrNil:info[@"companyId"]];
        isProject = NO;
        
    }
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    if (isProject) {
        
        NSDictionary *project = info[@"project"];
        _labelTitle.text = project[@"title"];
        
        NSDictionary *geocode = [DerivedNSManagedObject objectOrNil:project[@"geocode"]];
        
        if (geocode != nil) {
            
            _mapView.hidden = NO;
            
            CGFloat geocodeLat = [geocode[@"lat"] floatValue];
            CGFloat geocodeLng = [geocode[@"lng"] floatValue];
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geocodeLat, geocodeLng);
            
            MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
            MKCoordinateRegion region = {coordinate, span};
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:coordinate];
            
            [_mapView removeAnnotations:_mapView.annotations];
            
            [_mapView setRegion:region];
            [_mapView addAnnotation:annotation];
            
        }
        
    } else {
 
        NSDictionary *company = info[@"company"];
        _labelTitle.text = company[@"name"];
        
    }
    
}

#pragma mark - Map Delegate

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

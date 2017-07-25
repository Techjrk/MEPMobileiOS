//
//  SearchProjectCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchProjectCollectionViewCell.h"

#import <MapKit/MapKit.h>

#define LABEL_TITLE_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_TITLE_COLOR                   RGB(34, 34, 34)

#define LABEL_LOCATION_FONT                 fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_LOCATION_COLOR                RGB(159, 164, 166)

@interface SearchProjectCollectionViewCell()<MKMapViewDelegate>{
    BOOL isUserProject;
}
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *iconUpdateMarker;
@property (strong, nonatomic) NSNumber *projectId;

@end

@implementation SearchProjectCollectionViewCell

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
    
    self.iconUpdateMarker.hidden = YES;
    _labelTitle.text = item[@"title"];
   
    isUserProject = [DerivedNSManagedObject objectOrNil:item[@"dodgeNumber"]] == nil;
    
    NSString *addr = @"";
    
    NSString *county = [DerivedNSManagedObject objectOrNil:item[@"county"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:item[@"state"]];
    if (county != nil) {
        addr = [addr stringByAppendingString:county];
        
        if (state != nil) {
            addr = [addr stringByAppendingString:@", "];
        }
    }
    
    if (state != nil) {
        addr = [addr stringByAppendingString:state];
    }
    
    _labelLocation.text = addr;

    NSDictionary *geocode = [DerivedNSManagedObject objectOrNil:item[@"geocode"]];
    _mapView.delegate = nil;
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
        _mapView.delegate = self;
        [_mapView addAnnotation:annotation];
        
    } else {
        
        [_mapView removeAnnotations:_mapView.annotations];
        _mapView.hidden = YES;
    }

    self.projectId = item[@"id"];
    
    NSArray *userImages = item[@"images"];
    NSArray *userNotes = item[@"userNotes"];

    self.iconUpdateMarker.hidden = !((userImages.count>0)&&(userNotes.count>0));

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
     
        if (isUserProject) {
            userAnnotationView.image = [UIImage imageNamed:@"icon_userPinNew"];
        } else {
            userAnnotationView.image = [UIImage imageNamed:@"icon_pin"];
        }

    }
    
    return userAnnotationView;
    
}

@end

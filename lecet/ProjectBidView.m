//
//  ProjectBidView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBidView.h"

#import <MapKit/MapKit.h>
#import "projectBidConstants.h"

@interface ProjectBidView()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelBidName;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@end

@implementation ProjectBidView

- (void)awakeFromNib {
    self.layer.shadowColor = [PROJECT_BID_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 4.0;

    _labelBidName.font = PROJECT_BID_LABEL_NAME_FONT;
    _labelBidName.textColor = PROJECT_BID_LABEL_NAME_COLOR;
    
    _labelLocation.font =PROJECT_BID_LABEL_LOCATION_FONT;
    _labelLocation.textColor = PROJECT_BID_LABEL_LOCATION_COLOR;
        
}

- (void)setInfo:(id)info {
    NSDictionary *infoDict = info;
    
    _labelBidName.text = infoDict[PROJECT_BID_NAME];
    _labelLocation.text = infoDict[PROJECT_BID_LOCATION];
    
    NSMutableAttributedString *amount = [[NSMutableAttributedString alloc] initWithString:infoDict[PROJECT_BID_AMOUNT] attributes:@{NSFontAttributeName:PROJECT_BID_LABEL_AMOUNT_FONT, NSForegroundColorAttributeName:PROJECT_BID_LABEL_AMOUNT_COLOR}];
    
    [amount appendAttributedString:[[NSAttributedString alloc] initWithString:@" | " attributes:@{NSFontAttributeName:PROJECT_BID_LABEL_AMOUNT_FONT, NSForegroundColorAttributeName:PROJECT_BID_LABEL_DATE_COLOR} ]];
 
    [amount appendAttributedString:[[NSAttributedString alloc] initWithString:infoDict[PROJECT_BID_DATE] attributes:@{NSFontAttributeName:PROJECT_BID_LABEL_DATE_FONT, NSForegroundColorAttributeName:PROJECT_BID_LABEL_DATE_COLOR} ]];
    
    _labelAmount.attributedText = amount;
    
    NSNumber *geoCodeLat = infoDict[PROJECT_BID_GEOCODE_LAT];
    NSNumber *geoCodeLng = infoDict[PROJECT_BID_GEOCODE_LNG];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([geoCodeLat floatValue], [geoCodeLng floatValue]);
    
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

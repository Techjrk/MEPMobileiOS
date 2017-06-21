//
//  AssociatedBidView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "AssociatedBidView.h"

#import <MapKit/MapKit.h>

#define ASSOCIATED_BID_LABEL_PROJECT_FONT               fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define ASSOCIATED_BID_LABEL_PROJECT_COLOR              RGB(34, 34, 34)

#define ASSOCIATED_BID_LABEL_LOCATION_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define ASSOCIATED_BID_LABEL_LOCATION_COLOR             RGB(159, 164, 166)

#define ASSOCIATED_BID_LABEL_TAG_FONT                   fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define ASSOCIATED_BID_LABEL_TAG_COLOR                  RGB(255, 255, 255)
#define ASSOCIATED_BID_LABEL_TAG_BG_COLOR               RGB(0, 63, 114)

#define ASSOCIATED_BID_SHADOW_COLOR                     RGB(0, 0, 0)

@interface AssociatedBidView()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelProject;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelTag;
@property (weak, nonatomic) IBOutlet UIImageView *iconUpdateMarker;
@property (strong, nonatomic) NSNumber *projectId;
@end

@implementation AssociatedBidView

- (void)awakeFromNib {
    [super awakeFromNib];
    _labelProject.text = @"";
    _labelProject.font = ASSOCIATED_BID_LABEL_PROJECT_FONT;
    _labelProject.textColor = ASSOCIATED_BID_LABEL_PROJECT_COLOR;
    
    _labelLocation.text = @"";
    _labelLocation.font = ASSOCIATED_BID_LABEL_LOCATION_FONT;
    _labelLocation.textColor = ASSOCIATED_BID_LABEL_LOCATION_COLOR;
    
    _labelTag.font = ASSOCIATED_BID_LABEL_TAG_FONT;
    _labelTag.textColor = ASSOCIATED_BID_LABEL_TAG_COLOR;
    _labelTag.backgroundColor = ASSOCIATED_BID_LABEL_TAG_BG_COLOR;
    _labelTag.layer.cornerRadius = 4.0;
    _labelTag.layer.masksToBounds = YES;
    
    self.layer.shadowColor = [ASSOCIATED_BID_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 4.0;

}

- (void)setInfo:(id)info {
    NSDictionary *infoDict = info;
    
    self.iconUpdateMarker.hidden = YES;
    _labelProject.text = infoDict[ASSOCIATED_BID_NAME];
    _labelLocation.text = infoDict[ASSOCIATED_BID_LOCATION];
    
    NSString *designation = infoDict[ASSOCIATED_BID_DESIGNATION];
    _labelTag.hidden = YES;
    if (designation != nil & designation.length>0) {
        _labelTag.text = designation;
        _labelTag.hidden = NO;
    }
    
    NSNumber *geoCodeLat = infoDict[ASSOCIATED_BID_GEOCODE_LAT];
    NSNumber *geoCodeLng = infoDict[ASSOCIATED_BID_GEOCODE_LNG];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([geoCodeLat floatValue], [geoCodeLng floatValue]);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    
    _mapView.delegate = nil;
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView setRegion:region];
    
    _mapView.delegate = self;
    [_mapView addAnnotation:annotation];

    self.projectId = infoDict[ASSOCIATED_BID_ID];
    [[DataManager sharedManager] checkForImageNotes:self.projectId success:^(id object) {
        
        NSDictionary *dict = object;
        
        NSNumber *prjId = dict[@"projectId"];
        if (prjId.integerValue == self.projectId.integerValue) {
            NSNumber *count = dict[@"count"];
            self.iconUpdateMarker.hidden = count.integerValue == 0;
        } else {
            self.iconUpdateMarker.hidden = YES;
        }
        
    } failure:^(id object) {
        
        self.iconUpdateMarker.hidden = YES;
    }];

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

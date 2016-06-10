//
//  BidItemRecent.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidItemRecent.h"

#import <MapKit/MapKit.h>
#import "bidItemRecentConstants.h"
#import "DB_Project.h"

@interface BidItemRecent()<MKMapViewDelegate>{
    NSNumber *recordId;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
- (IBAction)tappedButtonItem:(id)sender;
@end

@implementation BidItemRecent
@synthesize bitItemRecentDelegate;

-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    _labelTitle.font = BID_ITEM_RECENT_LABEL_TITLE_FONT;
    _labelTitle.textColor = BID_ITEM_RECENT_LABEL_TITLE_COLOR;
    
    _labelLocation.font = BID_ITEM_RECENT_LABEL_LOCATION_FONT;
    _labelLocation.textColor = BID_ITEM_RECENT_LABEL_LOCATION_COLOR;
    
    _labelType.font = BID_ITEM_RECENT_LABEL_TYPE_FONT;
    _labelType.textColor = BID_ITEM_RECENT_LABEL_TYPE_COLOR;
}

- (void)setInfo:(id)info {
    DB_Project *item = info;
    
    recordId = item.recordId;
    
    _labelTitle.text = item.title;
    _labelLocation.text = [item address];
    
    _labelType.text = [item getProjectType];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([item.geocodeLat floatValue], [item.geocodeLng floatValue]);
    
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

- (NSNumber *)getRecordId {
    return recordId;
}

- (IBAction)tappedButtonItem:(id)sender {
    
    [self.bitItemRecentDelegate tappedBitItemRecent:self];
}

@end

//
//  BidItemRecent.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidItemRecent.h"

#import <MapKit/MapKit.h>
#import "DB_Project.h"

#define BID_ITEM_RECENT_LABEL_TITLE_COLOR                   RGB(34, 34, 34)
#define BID_ITEM_RECENT_LABEL_TITLE_FONT                    fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)

#define BID_ITEM_RECENT_LABEL_LOCATION_COLOR                RGB(159, 164, 166)
#define BID_ITEM_RECENT_LABEL_LOCATION_FONT                 fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)

#define BID_ITEM_RECENT_LABEL_TYPE_COLOR                    RGB(159, 164, 166)
#define BID_ITEM_RECENT_LABEL_TYPE_FONT                     fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *unionDesignation = item.unionDesignation;
    
    if ((unionDesignation != nil) & (unionDesignation.length>0)) {
        
        if ([[unionDesignation uppercaseString] isEqualToString:UNION_DESIGNATION_CODE]) {
            
            //self.view.backgroundColor = LIUNA_ORANGE_COLOR;
            
        }
    }

    
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

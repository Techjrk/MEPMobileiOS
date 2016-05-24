//
//  BidSoonItem.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/5/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidSoonItem.h"

#import <MapKit/MapKit.h>

#import "bidSoonItemConstants.h"
#import "DB_Project.h"

@interface BidSoonItem()<MKMapViewDelegate>{
    NSNumber *recordId;
}
@property (weak, nonatomic) IBOutlet UIView *groupDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelBidName;
@property (weak, nonatomic) IBOutlet UILabel *labelBidService;
@property (weak, nonatomic) IBOutlet UILabel *labelBidType;
@property (weak, nonatomic) IBOutlet UILabel *labelBidLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)tappedButton:(id)sender;
@end

@implementation BidSoonItem

@synthesize bidSoonCollectionItemDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    self.view.backgroundColor = BID_SOON_ITEMVIEW_BG_COLOR;
    _groupDate.backgroundColor = BID_SOON_ITEMVIEW_GROUP_DATE_BG_COLOR;
    
    _labelDate.text = @"April 1";
    _labelDate.textColor = BID_SOON_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelDate.font = BID_SOON_ITEMVIEW_LABEL_DATE_FONT;
    
    _labelTime.text = @"11:30 AM";
    _labelTime.textColor = BID_SOON_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelTime.font = BID_SOON_ITEMVIEW_LABEL_TIME_FONT;
    
    _labelBidName.text = @"Northern Contracting Services";
    _labelBidName.textColor = BID_SOON_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelBidName.font = BID_SOON_ITEMVIEW_LABEL_BIDNAME_FONT;
    
    _labelBidService.text = @"Metro Youth Services";
    _labelBidService.textColor = BID_SOON_ITEMVIEW_LABEL_BIDSERVICE_COLOR;
    _labelBidService.font = BID_SOON_ITEMVIEW_LABEL_BIDSERVICE_FONT;
    
    _labelBidLocation.text = @"Boston, MA";
    _labelBidLocation.textColor = BID_SOON_ITEMVIEW_LABEL_BIDINFO_COLOR;
    _labelBidLocation.font = BID_SOON_ITEMVIEW_LABEL_BIDINFO_FONT;
    
    _labelBidType.text = @"Recreational, Alternative Living";
    _labelBidType.textColor = BID_SOON_ITEMVIEW_LABEL_BIDINFO_COLOR;
    _labelBidType.font = BID_SOON_ITEMVIEW_LABEL_BIDINFO_FONT;
    
    _mapView.delegate = self;
    
}

- (void)setItemInfo:(id)info {

    DB_Project *item = info;
    
    recordId = item.recordId;
    
    NSDate *date =[DerivedNSManagedObject dateFromDateAndTimeString:item.bidDate];
    _labelDate.text = [DerivedNSManagedObject monthDayStringFromDate:date];
    _labelTime.text = [DerivedNSManagedObject timeStringDate:date];
    
    _labelBidService.text = item.title;
    _labelBidLocation.text = [NSString stringWithFormat:@"%@, %@", item.county, item.state];
    
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


- (IBAction)tappedButton:(id)sender {
    if (self.bidSoonCollectionItemDelegate != nil) {
        [self.bidSoonCollectionItemDelegate tappedBidSoonCollectionItem:self];
    }
}

- (NSNumber*)getRecordId {
    return recordId;
}

@end

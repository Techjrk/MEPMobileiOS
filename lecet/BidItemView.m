//
//  BidItemView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BidItemView.h"

#import <MapKit/MapKit.h>
#import <DataManagerSDK/DB_Bid.h>
#import <DataManagerSDK/DB_Project.h>
#import <DataManagerSDK/DB_Company.h>

#define BID_ITEMVIEW_BG_COLOR                           RGB(14, 75, 132)
#define BID_ITEMVIEW_GROUP_DATE_BG_COLOR                RGB(4, 41, 90)
#define BID_ITEMVIEW_LABEL_TEXT_COLOR                   RGB(255, 255, 255)
#define BID_ITEMVIEW_LABEL_BIDSERVICE_COLOR             RGB(34, 34, 34)
#define BID_ITEMVIEW_LABEL_BIDINFO_COLOR                RGB(159, 164, 166)

#define BID_ITEMVIEW_LABEL_DATE_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)
#define BID_ITEMVIEW_LABEL_AMOUNT_FONT                  fontNameWithSize(FONT_NAME_LATO_BLACK, 15)
#define BID_ITEMVIEW_LABEL_BIDNAME_FONT                 fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BID_ITEMVIEW_LABEL_BIDSERVICE_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define BID_ITEMVIEW_LABEL_BIDINFO_FONT                 fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)

@interface BidItemView()<MKMapViewDelegate>{
    NSNumber *recordId;
    NSNumber *projectId;
}
@property (weak, nonatomic) IBOutlet UIView *groupDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelBidName;
@property (weak, nonatomic) IBOutlet UILabel *labelBidService;
@property (weak, nonatomic) IBOutlet UILabel *labelBidType;
@property (weak, nonatomic) IBOutlet UILabel *labelBidLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)tappedButton:(id)sender;
@end

@implementation BidItemView

@synthesize bidItemDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;

    self.view.backgroundColor = BID_ITEMVIEW_BG_COLOR;
    _groupDate.backgroundColor = BID_ITEMVIEW_GROUP_DATE_BG_COLOR;
    
    _labelDate.text = @"April 15";
    _labelDate.textColor = BID_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelDate.font = BID_ITEMVIEW_LABEL_DATE_FONT;
    
    _labelAmount.text = @"$1,082,100";
    _labelAmount.textColor = BID_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelAmount.font = BID_ITEMVIEW_LABEL_AMOUNT_FONT;

    _labelBidName.text = @"Northern Contracting Services";
    _labelBidName.textColor = BID_ITEMVIEW_LABEL_TEXT_COLOR;
    _labelBidName.font = BID_ITEMVIEW_LABEL_BIDNAME_FONT;

    _labelBidService.text = @"Metro Youth Services";
    _labelBidService.textColor = BID_ITEMVIEW_LABEL_BIDSERVICE_COLOR;
    _labelBidService.font = BID_ITEMVIEW_LABEL_BIDSERVICE_FONT;
    
    _labelBidLocation.text = @"Boston, MA";
    _labelBidLocation.textColor = BID_ITEMVIEW_LABEL_BIDINFO_COLOR;
    _labelBidLocation.font = BID_ITEMVIEW_LABEL_BIDINFO_FONT;

    _labelBidType.text = @"Recreational, Alternative Living";
    _labelBidType.textColor = BID_ITEMVIEW_LABEL_BIDINFO_COLOR;
    _labelBidType.font = BID_ITEMVIEW_LABEL_BIDINFO_FONT;

}

- (void)setInfo:(id)info {
    DB_Bid *item = info;
    
    self.view.backgroundColor = BID_ITEMVIEW_BG_COLOR;

    NSString *unionDesignation = item.relationshipProject.unionDesignation;
    
    if ((unionDesignation != nil) & (unionDesignation.length>0)) {
     
        if ([[unionDesignation uppercaseString] isEqualToString:UNION_DESIGNATION_CODE]) {

            self.view.backgroundColor = LIUNA_ORANGE_COLOR;
            
        }
    }
    recordId = item.recordId;
    NSDate *date =[DerivedNSManagedObject dateFromDateAndTimeString:item.createDate];
    _labelDate.text = [DerivedNSManagedObject monthDayStringFromDate:date];
    
    DB_Project *project = item.relationshipProject;
    projectId = project.recordId;
    
    CGFloat estlow = 0;
    if (item.amount != nil) {
        estlow = item.amount.integerValue;
    }
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *estLow = [formatter stringFromNumber:[NSNumber numberWithFloat:estlow]];
    _labelAmount.text = [NSString stringWithFormat:@"$ %@", estLow ];
    
    DB_Company *company = item.relationshipCompany;
    
    NSString *companyName = company.name;
    _labelBidName.text = companyName;
    
    _labelBidService.text = item.relationshipProject.title;
    _labelBidLocation.text = [NSString stringWithFormat:@"%@, %@", project.city, project.state];
    _labelBidType.text = [project getProjectType];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([project.geocodeLat floatValue], [project.geocodeLng floatValue]);
    
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
        userAnnotationView.image = [UIImage imageNamed:@"icon_pin"];
        
    }
    
    return userAnnotationView;
    
}

- (IBAction)tappedButton:(id)sender {
    if (self.bidItemDelegate != nil) {
        [self.bidItemDelegate tappedBidCollectionItem:self];
    }
}

- (NSNumber *)getRecordId {
    return recordId;
}

- (NSNumber *)getProjectRecordId {
    return projectId;
}

@end

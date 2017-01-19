//
//  ProjectNearMeListCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearMeListCollectionViewCell.h"
#import <MapKit/MapKit.h>

#define fontTitleName                       fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define fontTitleAddress                    fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define fontTitleFeetAway                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 9)
#define fontTitlePrice                      fontNameWithSize(FONT_NAME_LATO_BOLD, 11)
#define fontUnionLabel                      fontNameWithSize(FONT_NAME_LATO_BOLD, 12)

#define colorFontTitleName                  RGB(34,34,34)
#define colorFontTitleAddress               RGB(159,164,166)
#define colorFontTitleFeetAway              RGB(159,164,166)
#define colorFontTitlePrice                 RGB(34,34,34)
#define colorFontUnionLabel                 RGB(255,255,255)
#define colorBackgroundView                 RGB(255,255,255)
#define colorBackgroundContainerUnionView   RGB(0,63,114)
@interface ProjectNearMeListCollectionViewCell ()
    @property (weak, nonatomic) IBOutlet MKMapView *mapView;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *unionLabel;
    @property (weak, nonatomic) IBOutlet UIView *containerUnionView;
    @property (weak, nonatomic) IBOutlet UILabel *titleAddressLabel;
    @property (weak, nonatomic) IBOutlet UILabel *titleFeetAwayLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *addressIconImageView;

@end

@implementation ProjectNearMeListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5;

    self.unionLabel.textColor = colorFontUnionLabel;
    self.unionLabel.font = fontUnionLabel;
    
    self.containerUnionView.backgroundColor = colorBackgroundContainerUnionView;
    self.containerUnionView.layer.cornerRadius = 5;
    
    self.titleLabel.font = fontTitleName;
    self.titleLabel.textColor = colorFontTitleName;
    
    self.titleAddressLabel.font = fontTitleAddress;
    self.titleAddressLabel.textColor = colorFontTitleAddress;
    
    self.titleFeetAwayLabel.font = fontTitleFeetAway;
    self.titleFeetAwayLabel.textColor = colorFontTitleFeetAway;
}

#pragma mark - Misc Methods

- (void)setInitInfo {
    self.titleLabel.text = self.titleNameText;
    self.titleAddressLabel.text = self.titleAddressText;
    self.titleFeetAwayLabel.attributedText = [self convertToAttributedTextFeetAway:self.titleFeetAwayText priceDetails:self.titlePriceText];
}

- (NSAttributedString *)convertToAttributedTextFeetAway:(NSString *)feetAway priceDetails:(NSString *)priceDetailText {
    feetAway = [NSString stringWithFormat:@"%@ | ",feetAway];
    NSMutableAttributedString *feetAwayAttri = [[NSMutableAttributedString alloc] initWithString:feetAway attributes:@{NSFontAttributeName:fontTitleFeetAway, NSForegroundColorAttributeName:colorFontTitleFeetAway}];
    
    NSMutableAttributedString *priceAttri = [[NSMutableAttributedString alloc] initWithString:priceDetailText attributes:@{NSFontAttributeName:fontTitlePrice, NSForegroundColorAttributeName:colorFontTitlePrice}];
    
    [feetAwayAttri appendAttributedString:priceAttri];
    return [feetAwayAttri copy];
}


#pragma mark - MapView Delegate and Methods
- (void)setMapInfoLatitude:(CLPlacemark *)coord {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(coord.location.coordinate.latitude, coord.location.coordinate.longitude);
    
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

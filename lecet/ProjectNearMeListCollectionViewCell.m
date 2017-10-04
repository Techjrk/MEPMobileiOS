//
//  ProjectNearMeListCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearMeListCollectionViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define fontTitleName                       fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define fontTitleAddress                    fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define fontTitleFeetAway                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 9)
#define fontTitlePrice                      fontNameWithSize(FONT_NAME_LATO_BOLD, 11)
#define fontUnionLabel                      fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define fontButton                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)

#define colorFontTitleName                  RGB(34,34,34)
#define colorFontTitleAddress               RGB(159,164,166)
#define colorFontTitleFeetAway              RGB(159,164,166)
#define colorFontTitlePrice                 RGB(34,34,34)
#define colorFontUnionLabel                 RGB(255,255,255)
#define colorBackgroundView                 RGB(255,255,255)
#define colorBackgroundContainerUnionView   RGB(0,63,114)

#define colorButtonNormal                   RGB(8, 36, 75)
#define colorButtonTapped                   RGB(248, 153, 0)
#define colorButtonTitle                   RGB(248, 153, 0)

#define distanceToFeet                      3.280
#define distanceToMile                      0.000621371

@interface ProjectNearMeListCollectionViewCell ()<MKMapViewDelegate> {
    CGFloat lat, lng;
}
    @property (weak, nonatomic) IBOutlet MKMapView *mapView;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *unionLabel;
    @property (weak, nonatomic) IBOutlet UIView *containerUnionView;
    @property (weak, nonatomic) IBOutlet UILabel *titleAddressLabel;
    @property (weak, nonatomic) IBOutlet UILabel *titleFeetAwayLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *addressIconImageView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintUnionWidth;
    @property (weak, nonatomic) IBOutlet UIImageView *iconMarker;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHorizontal;
    @property (weak, nonatomic) IBOutlet UIView *viewContainer;
    @property (weak, nonatomic) IBOutlet UIView *viewAction;
    @property (weak, nonatomic) IBOutlet UIButton *buttonTrack;
    @property (weak, nonatomic) IBOutlet UILabel *labelTrack;
    @property (weak, nonatomic) IBOutlet UIButton *buttonShare;
    @property (weak, nonatomic) IBOutlet UILabel *labelShare;
    @property (weak, nonatomic) IBOutlet UIButton *buttonHide;
    @property (weak, nonatomic) IBOutlet UILabel *labelHide;
    @property (weak, nonatomic) IBOutlet UIView *viewHide;
    @property (weak, nonatomic) IBOutlet UILabel *labelTextHide;

@end

@implementation ProjectNearMeListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewContainer.layer.cornerRadius = 5;
    
    self.constraintHorizontal.constant = 0;
    
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
    self.mapView.delegate = self;

    self.buttonTrack.backgroundColor = colorButtonNormal;
    self.buttonTrack.layer.cornerRadius = 5;
    self.labelTrack.textColor = [UIColor whiteColor];
    self.labelTrack.font = fontButton;
    self.labelTrack.text = NSLocalizedLanguage(@"PLC_TRACK");

    self.buttonShare.backgroundColor = colorButtonNormal;
    self.buttonShare.layer.cornerRadius = 5;
    self.labelShare.textColor = [UIColor whiteColor];
    self.labelShare.font = fontButton;
    self.labelShare.text = NSLocalizedLanguage(@"PLC_SHARE");

    self.buttonHide.backgroundColor = colorButtonNormal;
    self.buttonHide.layer.cornerRadius = 5;
    self.labelHide.textColor = [UIColor whiteColor];
    self.labelHide.font = fontButton;
    self.labelHide.text = NSLocalizedLanguage(@"PLC_HIDE");
  
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedLanguage(@"PLC_PROJECT_HIDDEN") attributes:@{NSFontAttributeName: fontButton, NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    NSAttributedString *undo = [[NSAttributedString alloc] initWithString:NSLocalizedLanguage(@"PLC_UNDO") attributes:@{NSFontAttributeName: fontButton, NSForegroundColorAttributeName: [UIColor whiteColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    
    [attributedString appendAttributedString:undo];
    
    self.labelTextHide.attributedText = attributedString;
    [self projectHidden:YES];

}

#pragma mark - Misc Methods

- (void)setInitInfo {
    self.iconMarker.hidden = YES;
    self.titleLabel.text = self.titleNameText;
    self.titleAddressLabel.text = self.titleAddressText;
     [self setDistance];
    self.titleFeetAwayLabel.attributedText = [self convertToAttributedTextFeetAway:self.titleFeetAwayText priceDetails:self.titlePriceText];
    
    if (self.geoCode != nil) {
        lat = [self.geoCode[@"lat"] floatValue];
        lng = [self.geoCode[@"lng"] floatValue];
        [self setMapInfoLatitudeAndLongtitude];
    }
    
    if (!self.unionDesignation.length) {
        self.contraintUnionWidth.constant = 0;
        self.containerUnionView.hidden = YES;
    } else {
        self.contraintUnionWidth.constant  = self.frame.size.width * 0.095;
        self.containerUnionView.hidden = NO;
    }
   
    self.iconMarker.hidden = !self.hasNoteAndImages;
}

- (NSAttributedString *)convertToAttributedTextFeetAway:(NSString *)feetAway priceDetails:(NSString *)priceDetailText {
    feetAway = [NSString stringWithFormat:@"%@ | ",feetAway];
    NSMutableAttributedString *feetAwayAttri = [[NSMutableAttributedString alloc] initWithString:feetAway attributes:@{NSFontAttributeName:fontTitleFeetAway, NSForegroundColorAttributeName:colorFontTitleFeetAway}];
    
    priceDetailText = !priceDetailText.length ? @"0": priceDetailText;
    NSMutableAttributedString *priceAttri = [[NSMutableAttributedString alloc] initWithString:priceDetailText attributes:@{NSFontAttributeName:fontTitlePrice, NSForegroundColorAttributeName:colorFontTitlePrice}];
    
    [feetAwayAttri appendAttributedString:priceAttri];
    return [feetAwayAttri copy];
}

- (void)setDistance {
    CGFloat currentLat = [[DataManager sharedManager] locationManager].currentLocation.coordinate.latitude;
    CGFloat currentLng = [[DataManager sharedManager] locationManager].currentLocation.coordinate.longitude;
    
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:currentLat longitude:currentLng];
    
    CLLocation *projLoc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    CLLocationDistance distance = [currentLoc distanceFromLocation:projLoc];
    int feet = distance * distanceToFeet;
    float miles = distance * distanceToMile;
    
    NSString *distanceAway = @"Away";
    NSString *mileAway =  NSLocalizedLanguage(@"PLC_MILE");
    NSString *milesAway = NSLocalizedLanguage(@"PLC_MILES");
    NSString *feetAway = NSLocalizedLanguage(@"PLC_FEET");

    if (feet < 5280) {
        distanceAway = [NSString stringWithFormat:feetAway,feet];
    } else {
        if ((int)miles == 1) {
            distanceAway = [NSString stringWithFormat:mileAway,(int)miles];
        } else if((int)miles > 1) {
            distanceAway = [NSString stringWithFormat:milesAway,miles];
        }
    }

    self.titleFeetAwayText = distanceAway;
}

#pragma mark - MapView Delegate and Methods
- (void)setMapInfoLatitudeAndLongtitude {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
    
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
        
        if (self.dodgeNumber == nil) {
            userAnnotationView.image = [UIImage imageNamed:@"icon_userPinNew"];
        } else {
            userAnnotationView.image = [UIImage imageNamed:@"icon_pin"];
        }
        
    }
    return userAnnotationView;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
}

- (void)dealloc {
    //[super dealloc];
}

- (void)swipeExpand:(UISwipeGestureRecognizerDirection)direction {

    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        self.constraintHorizontal.constant = -(self.frame.size.width * 0.75);
    } else {
        self.constraintHorizontal.constant = 0;
    }
    
    [self setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            if (self.constraintHorizontal.constant < 0) {
                if (self.projectNearMeListCollectionViewCellDelegate) {
                    [self.projectNearMeListCollectionViewCellDelegate didExpand:self];
                }
            }
        }
    }];
    
}

- (void)resetStatus {
    self.buttonTrack.backgroundColor = colorButtonNormal;
    self.buttonShare.backgroundColor = colorButtonNormal;
    self.buttonHide.backgroundColor = colorButtonNormal;
}

- (void)projectHidden:(BOOL)hidden {
    self.viewHide.hidden = !hidden;
    self.viewContainer.hidden = hidden;
    self.viewAction.hidden = hidden;
}

- (UIView*)trackButton {
    return self.buttonTrack;
}

- (UIView*)shareButton {
    return self.buttonShare;
}

#pragma mark - IBAction

- (IBAction)tappedButtonSelected:(id)sender {
    if (self.projectNearMeListCollectionViewCellDelegate) {
        [self.projectNearMeListCollectionViewCellDelegate didSelectItem:self];
    }
}

- (IBAction)tappedButtonTrack:(id)sender {
    if (self.projectNearMeListCollectionViewCellDelegate) {
        self.buttonTrack.backgroundColor = colorButtonTapped;
        [self.projectNearMeListCollectionViewCellDelegate didTrackItem:self];
    }
}

- (IBAction)tappedButtonShare:(id)sender {
    if (self.projectNearMeListCollectionViewCellDelegate) {
        self.buttonShare.backgroundColor = colorButtonTapped;
        [self.projectNearMeListCollectionViewCellDelegate didShareItem:self];
    }
}

- (IBAction)tappedButtonHide:(id)sender {
    if (self.projectNearMeListCollectionViewCellDelegate) {
        [self.projectNearMeListCollectionViewCellDelegate didHideItem:self];
    }
}

- (IBAction)tappedButtonUndo:(id)sender {
    if (self.projectNearMeListCollectionViewCellDelegate) {
        [self.projectNearMeListCollectionViewCellDelegate undoHide:self];
    }
}

@end

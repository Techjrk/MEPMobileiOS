//
//  ProjectTrackItemView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTrackItemView.h"

#import "projectTrackingItemConstants.h"
#import <MapKit/MapKit.h>

@interface ProjectTrackItemView()<MKMapViewDelegate>{
    NSMutableDictionary *stateStatus;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;
@property (weak, nonatomic) IBOutlet UILabel *labelUpdateDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonExpand;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSpaceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constaintContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintUpdateContainerHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelUpdateType;
- (IBAction)tappedButtonExppand:(id)sender;
@end

@implementation ProjectTrackItemView
@synthesize projectTrackItemViewDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _constraintSpaceTop.constant = kDeviceHeight * 0.018;
    _constaintContainerHeight.constant = kDeviceHeight * 0.092;
    
    _labelTitle.font = PROJECT_TRACK_ITEM_TITLE_FONT;
    _labelTitle.textColor = PROJECT_TRACK_ITEM_TITLE_COLOR;
    
    _labelLocation.font = PROJECT_TRACK_ITEM_LOCATION_FONT;
    _labelLocation.textColor = PROJECT_TRACK_ITEM_LOCATION_COLOR;
    
    _labelType.font = PROJECT_TRACK_ITEM_TYPE_FONT;
    _labelType.textColor = PROJECT_TRACK_ITEM_TYPE_COLOR;
    
    _container.layer.cornerRadius = kDeviceWidth * 0.01;
    _container.layer.masksToBounds = YES;
    _container.backgroundColor = PROJECT_TRACK_UPDATE_BG_COLOR;
    
    _labelUpdateDetails.font = PROJECT_TRACK_UPDATE_FONT;
    _labelUpdateDetails.textColor = PROJECT_TRACK_UPDATE_COLOR;
    
    _labelUpdateType.font = PROJECT_TRACK_UPDATE_FONT;
    _labelUpdateType.textColor = PROJECT_TRACK_UPDATE_COLOR;
    
    _labelContainer.layer.cornerRadius = kDeviceWidth * 0.008;
    _labelContainer.layer.masksToBounds = YES;
    _labelContainer.backgroundColor = [PROJECT_TRACK_TEXT_BG_COLOR colorWithAlphaComponent:0.4];

    [_buttonExpand setTitleColor:PROJECT_TRACK_CARET_COLOR forState:UIControlStateNormal];
    _buttonExpand.titleLabel.font = PROJECT_TRACK_CARET_FONT;
    
}

- (void)setButtonTitle:(BOOL)isExpanded {

    [_buttonExpand setTitle:isExpanded?PROJECT_TRACK_DOWN_TEXT:PROJECT_TRACK_UP_TEXT forState:UIControlStateNormal];
    
}

- (void)setInfo:(id)info {
    NSDictionary *project = info[kStateData];
    _labelTitle.text = project[@"title"];
    
    NSString *addr = @"";
    
    NSString *county = [DerivedNSManagedObject objectOrNil:project[@"county"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:project[@"state"]];
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
    
    NSString *primaryProjectTypeTitle = nil;
    NSString *projectCategoryTitle = nil;
    NSString *projectGroupTitle = nil;
    
    NSDictionary *primaryProjectType = [DerivedNSManagedObject objectOrNil:project[@"primaryProjectType"]];
    if (primaryProjectType != nil) {
        primaryProjectTypeTitle = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"title"]];
        
        NSDictionary *category = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"projectCategory"]];
        if (category != nil) {
            projectCategoryTitle = category[@"title"];
        }
        
        NSDictionary *projectGroup = [DerivedNSManagedObject objectOrNil:category[@"projectGroup"]];
        if (projectGroup != nil) {
            projectGroupTitle = [DerivedNSManagedObject objectOrNil:projectGroup[@"title"]];
        }
    }

    NSString *projectType = [NSString stringWithFormat:@"%@ %@ %@", primaryProjectTypeTitle==nil?@"":primaryProjectTypeTitle, projectCategoryTitle==nil?@"":projectCategoryTitle, projectGroupTitle==nil?@"":projectGroupTitle];

    _labelType.text = projectType;
    
    stateStatus = info[kStateStatus];
    
    BOOL shouldShowUpdates = [stateStatus[kStateShowUpdate] boolValue];
    
    ProjectTrackUpdateType updateType = (ProjectTrackUpdateType)[stateStatus[kStateUpdateType] integerValue];
    _container.hidden = (updateType == ProjectTrackUpdateTypeNone);
    
    if(!_container.hidden){
        
        if (shouldShowUpdates) {

            BOOL isExpanded = [stateStatus[kStateExpanded] boolValue];
            
            _labelUpdateDetails.hidden = !isExpanded;
            _labelContainer.hidden = _labelUpdateDetails.hidden;
            _constraintUpdateContainerHeight.constant = kDeviceHeight * (!isExpanded?0.06:0.133);
            
            [self setButtonTitle:isExpanded];
        
            switch ((long)updateType) {
                case ProjectTrackUpdateTypeNewBid:{
                    _labelUpdateType.text = NSLocalizedLanguage(@"PROJECT_UPDATE_NEW_BID");
                    break;
                }
                    
                case ProjectTrackUpdateTypeNewNote: {
                    _labelUpdateType.text = NSLocalizedLanguage(@"PROJECT_UPDATE_NEW_NOTE");
                    break;
                }
                
            }
        } else {
            _container.hidden = YES;
        }
        
    }
    
    NSDictionary *geocode = project[@"geocode"];
    
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


- (IBAction)tappedButtonExppand:(id)sender {
    BOOL expanded = [stateStatus[kStateExpanded] boolValue];
    stateStatus[kStateExpanded] = [NSNumber numberWithBool:!expanded];
    [self.projectTrackItemViewDelegate tappedButtonExpand:self view:nil];
}



@end

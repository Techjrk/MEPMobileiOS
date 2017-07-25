//
//  HiddenProjectView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "HiddenProjectView.h"
#import <MapKit/MapKit.h>

#define HIDDEN_PROJECT_CELL_LINE_COLOR              RGB(193, 193, 193)

#define HIDDEN_PROJECT_TITLE_FONT                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define HIDDEN_PROJECT_TITLE_COLOR                  RGB(34, 34, 34)

#define HIDDEN_PROJECT_LOCATION_FONT                fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define HIDDEN_PROJECT_LOCATION_COLOR               RGB(159, 164, 166)

#define HIDDEN_PROJECT_HIDE_FONT                    fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define HIDDEN_PROJECT_UNHIDE_COLOR                 RGB(0, 63, 114)
#define HIDDEN_PROJECT_HIDE_COLOR                   RGB(168, 195, 230)

@interface HiddenProjectView()<MKMapViewDelegate>{
    BOOL projectHidden;
    NSNumber *projectId;
    NSMutableDictionary *projectInfo;
}
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonUnhide;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)tappedUnhideButton:(id)sender;
@end

@implementation HiddenProjectView

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.backgroundColor = HIDDEN_PROJECT_CELL_LINE_COLOR;
    
    _labelTitle.font = HIDDEN_PROJECT_TITLE_FONT;
    _labelTitle.textColor = HIDDEN_PROJECT_TITLE_COLOR;
    
    _labelLocation.font = HIDDEN_PROJECT_LOCATION_FONT;
    _labelLocation.textColor = HIDDEN_PROJECT_LOCATION_COLOR;
    
    _buttonUnhide.titleLabel.font = HIDDEN_PROJECT_HIDE_FONT;
    
    projectHidden = YES;

    [self changeButtonMode];
}

- (void)changeButtonMode {

    [UIView performWithoutAnimation:^{

        if (projectHidden) {
            
            [_buttonUnhide setTitle:NSLocalizedLanguage(@"HIDDEN_PROJECT_UNHIDE") forState:UIControlStateNormal];
            [_buttonUnhide setTitleColor:HIDDEN_PROJECT_UNHIDE_COLOR forState:UIControlStateNormal];
            
        } else {
            
            [_buttonUnhide setTitle:NSLocalizedLanguage(@"HIDDEN_PROJECT_HIDE") forState:UIControlStateNormal];
            [_buttonUnhide setTitleColor:HIDDEN_PROJECT_HIDE_COLOR forState:UIControlStateNormal];
            
        }

    }];

}

- (void)setInfo:(id)info {
    
    projectInfo = info;
    projectId = info[@"id"];
    
    NSNumber *isHidden = info[@"isHidden"];
    projectHidden = YES;
    if (isHidden != nil) {
        projectHidden = isHidden.boolValue;
    }
    
    [self changeButtonMode];
    
    _labelTitle.text = info[@"title"];
    
    NSString *addr = @"";
    
    NSString *county = [DerivedNSManagedObject objectOrNil:info[@"county"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:info[@"state"]];
    
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

    NSDictionary *geocode = [DerivedNSManagedObject objectOrNil:info[@"geocode"]];
    
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


- (IBAction)tappedUnhideButton:(id)sender {
    
    
    if (!projectHidden) {
        
        [[DataManager sharedManager] hideProject:projectId success:^(id object) {
           
            projectHidden = YES;
            projectInfo[@"isHidden"] = [NSNumber numberWithBool:projectHidden];
            [self changeButtonMode];
            
        } failure:^(id object) {
            
        }];
        
    } else {
      
        [[DataManager sharedManager] unhideProject:projectId success:^(id object) {
   
            projectHidden = NO;
            projectInfo[@"isHidden"] = [NSNumber numberWithBool:projectHidden];
            [self changeButtonMode];
        
        } failure:^(id object) {
            
        }];
        
    }
    
}

@end

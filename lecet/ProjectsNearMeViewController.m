//
//  ProjectsNearMeViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectsNearMeViewController.h"

#import "ShareLocationViewController.h"
#import "GoToSettingsViewController.h"
#import "ProjectAnnotationView.h"
#import "ProjectPointAnnotation.h"
#import "CallOutViewController.h"
#import "ProjectPointAnnotation.h"
#import <MapKit/MapKit.h>

#define PROJECTS_TEXTFIELD_TEXT_FONT                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 12);

@interface ProjectsNearMeViewController ()<ShareLocationDelegate, GoToSettingsDelegate, MKMapViewDelegate, UITextFieldDelegate>{
    BOOL isFirstLaunch;
    NSMutableArray *mapItems;
    BOOL isSearchLocation;
    BOOL showPrompt;
    BOOL isLocationCaptured;
}
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)tappedButtonback:(id)sender;
@end

@implementation ProjectsNearMeViewController

float MilesToMeters(float miles) {
    return 1609.344f * miles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableTapGesture:YES];
    
    showPrompt = YES;
    mapItems = [NSMutableArray new];
    _textFieldSearch.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _textFieldSearch.layer.cornerRadius = kDeviceWidth * 0.0106;
    _textFieldSearch.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_searchTextField"]];
    imageView.frame = CGRectMake(0, 0, kDeviceWidth * 0.1, kDeviceHeight * 0.025);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _textFieldSearch.leftView = imageView;
    _textFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    _textFieldSearch.textColor = [UIColor whiteColor];
    _textFieldSearch.font = PROJECTS_TEXTFIELD_TEXT_FONT;
    [_textFieldSearch setTintColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationAppBecomeActive:) name:NOTIFICATION_APP_BECOME_ACTIVE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationLocationDenied:) name:NOTIFICATION_LOCATION_DENIED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationLocationAllowed:) name:NOTIFICATION_LOCATION_ALLOWED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationGPSLocation:) name:NOTIFICATION_GPS_LOCATION object:nil];
    if([[DataManager sharedManager] locationManager].currentStatus == kCLAuthorizationStatusAuthorizedAlways) {
        
        [[[DataManager sharedManager] locationManager] startUpdatingLocation];
 
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self viewWasLaunced];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    showPrompt = NO;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)NotificationAppBecomeActive:(NSNotification*)notification {
    [self viewWasLaunced];
}

- (void)NotificationLocationDenied:(NSNotification*)notification {
    [self gotoSettings];
}

- (void)NotificationLocationAllowed:(NSNotification*)notification {
    [[[DataManager sharedManager] locationManager] startUpdatingLocation];

    //[self loadProjects:5 coordinate:[[DataManager sharedManager] locationManager].currentLocation.coordinate];
}

- (void)NotificationGPSLocation:(NSNotification*)notification {
    if (!isLocationCaptured) {
        isLocationCaptured = YES;
        [self loadProjects:5 coordinate:[[DataManager sharedManager] locationManager].currentLocation.coordinate];
    }
}

- (void)loadProjects:(int)distance coordinate:(CLLocationCoordinate2D)coordinate {
    
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        CGFloat lat = coordinate.latitude;
        CGFloat lng = coordinate.longitude;
        
        [[DataManager sharedManager] projectsNear:lat lng:lng distance:[NSNumber numberWithInt:distance] filter:nil success:^(id object) {

            [mapItems removeAllObjects];
            [_mapView removeAnnotations:_mapView.annotations];
            
            NSArray *result = object[@"results"];
            if (result != nil & result.count>0) {
                
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
                
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, MilesToMeters(distance), MilesToMeters(distance));
                
                [_mapView setRegion:region];
                
                [mapItems addObjectsFromArray:result];
                [self addItemsToMap];
            } else {
                if (distance < 500) {
                    [self loadProjects:distance + (distance==5?95:100) coordinate:[[DataManager sharedManager] locationManager].currentLocation.coordinate];
                } else {
                    if (showPrompt) {
                        if (isSearchLocation) {
                            //[[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"PROJECTS_NEAR_NO_PROJECT_LOCATION_SEARCH")];
                        } else {
                            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"PROJECTS_NEAR_NO_PROJECT_LOCATION_NEAR")];
                        }
                    }
                }
            }
        } failure:^(id object) {
            
        }];
    } else {
        [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"PROJECTS_NEAR_LOCATION_INVALID")];
    }
}

- (IBAction)tappedButtonback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWasLaunced {
    if (!isFirstLaunch) {
        isFirstLaunch = YES;
        switch ([[DataManager sharedManager] locationManager].currentStatus) {
            case kCLAuthorizationStatusNotDetermined:{
                [self showShareLocation];
                break;
            }
            case kCLAuthorizationStatusDenied : {
                [self gotoSettings];
            }
            default: {
                break;
            }
        }
    }
}

- (void)tappedButtonShareLocation:(id)object {
    [[[DataManager sharedManager] locationManager] requestAlways];
}

- (void)gotoSettings {
    GoToSettingsViewController *controller = [GoToSettingsViewController new];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.goToSettingsDelegate = self;
    [self presentViewController:controller animated:NO completion:nil];
    
}

- (void)showShareLocation {
    ShareLocationViewController *controller = [ShareLocationViewController new];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.shareLocationDelegate = self;
    [self presentViewController:controller animated:NO completion:nil];

}

-(void)tappedButtonShareCancel:(id)object {
    [self gotoSettings];
}

-(void)tappedButtonGotoSettingsCancel:(id)object {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tappedButtonGotoSettings:(id)object {
    
    if ([[DataManager sharedManager] locationManager].currentStatus != kCLAuthorizationStatusAuthorizedAlways) {
        isFirstLaunch = NO;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - Map Routines

- (void)addItemsToMap {
    for (NSDictionary *item in mapItems) {
        [self addAnnotationCargo:item];
    }
}

- (void)addAnnotationCargo:(id)cargo{
    NSDictionary *geoCode = cargo[@"geocode"];
    
    CGFloat lat = [geoCode[@"lat"] floatValue];
    CGFloat lng = [geoCode[@"lng"] floatValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
    ProjectPointAnnotation *annotation = [[ProjectPointAnnotation alloc] init];
    annotation.cargo = cargo;
    [annotation setCoordinate:coordinate];
    [_mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    ProjectAnnotationView *userAnnotationView = nil;
    if (![annotation isKindOfClass:MKUserLocation.class])
    {
        userAnnotationView = (ProjectAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"UserLocation"];
        if (userAnnotationView == nil)  {
            userAnnotationView = [[ProjectAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];
        }
        else
            userAnnotationView.annotation = annotation;
        
        userAnnotationView.enabled = YES;
        userAnnotationView.canShowCallout = YES;
        userAnnotationView.image = userAnnotationView.isPreBid?[UIImage imageNamed:@"icon_pinGreen"]:[UIImage imageNamed:@"icon_pinRed"];
    }
    
    return userAnnotationView;
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    CGPoint point = [sender locationInView:view];
    UIView* subview = [view hitTest:point withEvent:nil];

    [super handleSingleTap:sender];

    if ([subview class] == [ProjectAnnotationView class]) {
        CallOutViewController *controller = [CallOutViewController new];
        
        ProjectAnnotationView *annotationView = (ProjectAnnotationView*)subview;
        ProjectPointAnnotation *annotation =  (ProjectPointAnnotation*)annotationView.annotation;
        
        controller.popoverPresentationController.sourceView = subview;
        controller.popoverPresentationController.sourceRect = CGRectMake(0, 0, subview.frame.size.width, subview.frame.size.height);
        [controller setInfo:annotation.cargo];
        annotationView.image = [UIImage imageNamed:@"icon_pinOrange"];
        controller.projectPin = annotationView;
        [self.navigationController presentViewController:controller animated:NO completion:nil];
    }
}

- (void)searchForLocation {
    NSString *location = _textFieldSearch.text;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = _mapView.region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         region.span.longitudeDelta /= 8.0;
                         region.span.latitudeDelta /= 8.0;
                         
                         [self loadProjects:5 coordinate:region.center];
                         
                     } else if (error != nil) {
                         [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"PROJECTS_NEAR_LOCATION_INVALID")];
                     }
                 }
     ];

}

#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"PROJECTS_NEAR_LOCATION_EMPTY")];
    } else {
        [textField resignFirstResponder];
        isSearchLocation = YES;
        [self searchForLocation];
    }
    return YES;
}

- (IBAction)tappedLocationRecenterButton:(id)sender {
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    
}


@end

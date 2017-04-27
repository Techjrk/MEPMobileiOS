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
#import "ProjectNearMeListView.h"
#import <MapKit/MapKit.h>
#import "ProjectNearMeFilterViewController.h"
#import "UserLocationPinViewController.h"
#import "NewProjectViewController.h"
#import "ProjectHeaderView.h"
#import "NewProjectAnnotationView.h"
#import "NewProjectAnnotation.h"
#import "NewPinViewController.h"
#import "ProjectDetailViewController.h"

#define PROJECTS_TEXTFIELD_TEXT_FONT                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 12);

@interface ProjectsNearMeViewController ()<ShareLocationDelegate, GoToSettingsDelegate, MKMapViewDelegate, UITextFieldDelegate, ProjectNearMeFilterViewControllerDelegate, CreateProjectPinDelegate, NewProjectViewControllerDelegate>{
    BOOL isFirstLaunch;
    NSMutableArray *mapItems;
    BOOL isSearchLocation;
    BOOL showPrompt;
    BOOL isLocationCaptured;
    BOOL isDoneSearching;
    BOOL isListViewHidden;
    NSDictionary *filterDictionary;
}
@property (weak, nonatomic) IBOutlet UIButton *locListButton;
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet ProjectNearMeListView *projectNearMeListView;
@property (weak, nonatomic) IBOutlet UIButton *buttonFilter;

- (IBAction)tappedButtonback:(id)sender;
@end

@implementation ProjectsNearMeViewController

float MilesToMeters(float miles) {
    return 1609.344f * miles;
}

float MetersToMiles(float meters) {
    return 0.000621371 * meters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isDoneSearching = NO;
    [self enableTapGesture:YES];
    
    isListViewHidden = YES;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationGPSLocation:) name:NOTIFICATION_GPS_LOCATION_NEAR object:nil];

    
    if([[DataManager sharedManager] locationManager].currentStatus == kCLAuthorizationStatusAuthorizedAlways) {
        
        [[[DataManager sharedManager] locationManager] startUpdatingLocation];
 
    }
    
    filterDictionary = [NSDictionary new];
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
        [self loadProjects:1 coordinate:[[DataManager sharedManager] locationManager].currentLocation.coordinate regionValue:0];
    }
}

- (void)loadProjects:(int)distance coordinate:(CLLocationCoordinate2D)coordinate regionValue:(CGFloat)regionValue {
    
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        CGFloat lat = coordinate.latitude;
        CGFloat lng = coordinate.longitude;
        
        isDoneSearching = NO;
        [[DataManager sharedManager] projectsNear:lat lng:lng distance:[NSNumber numberWithInt:distance] filter:filterDictionary success:^(id object) {

            isDoneSearching = YES;
            
            [mapItems removeAllObjects];
            [_mapView removeAnnotations:_mapView.annotations];
            
            NSArray *result = object[@"results"];
            if (result != nil & result.count>0) {
                self.projectNearMeListView.parentCtrl = self;
                [self.projectNearMeListView setInfo:result];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
                
                if (regionValue == 0) {
                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, MilesToMeters(distance), MilesToMeters(distance));
                    [_mapView setRegion:region];
                } else {
                    [_mapView setRegion:self.mapView.region];
                    
                }
                
                [mapItems addObjectsFromArray:result];
                [self addItemsToMap];
                
                if (isSearchLocation) {
                    [self addNewProjectPin];
                }
            } else {
                
                isDoneSearching = YES;
                if (distance < 500) {
                    [self loadProjects:distance + (distance==5?95:100) coordinate:[[DataManager sharedManager] locationManager].currentLocation.coordinate regionValue:regionValue];
                    
                    
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
            isDoneSearching = YES;
        }];
    } else {
        isDoneSearching = YES;
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

- (IBAction)tappedButtonFilter:(id)sender {
    ProjectNearMeFilterViewController *controller = [ProjectNearMeFilterViewController new];
    controller.projectNearMeFilterViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:NO];
}
    
- (IBAction)tappedLocListButton:(id)sender {
    [self getVisibleAnmotationsInMap];
    isListViewHidden = !isListViewHidden;
    NSString *imageName = isListViewHidden ? @"list_icon" : @"loc_List_icon";
    [_locListButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    _projectNearMeListView.hidden = isListViewHidden;
}
    
#pragma mark - Map Routines
- (void)addItemsToMap {
    for (NSDictionary *item in mapItems) {
        [self addAnnotationCargo:item];
    }
}

- (void)addAnnotationCargo:(id)cargo{
    NSDictionary *geoCode = [DerivedNSManagedObject objectOrNil:cargo[@"geocode"]];

    if (geoCode == nil) {
        return;
    }
    CGFloat lat = 0;
    CGFloat lng = 0;

    if([DerivedNSManagedObject objectOrNil:geoCode[@"lat"]] != nil){
        lat = [geoCode[@"lat"] floatValue];
        lng = [geoCode[@"lng"] floatValue];
    } else {
        return;
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
    ProjectPointAnnotation *annotation = [[ProjectPointAnnotation alloc] init];
    annotation.cargo = cargo;
    [annotation setCoordinate:coordinate];
    [_mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    id annotationView = nil;
    
    if (![annotation isKindOfClass:MKUserLocation.class])
    {
        if ([annotation isKindOfClass:[ProjectPointAnnotation class]]) {
            ProjectAnnotationView *userAnnotationView = (ProjectAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"UserLocation"];
            if (userAnnotationView == nil)  {
                userAnnotationView = [[ProjectAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];
            } else
                userAnnotationView.annotation = annotation;
            
            userAnnotationView.rightCalloutAccessoryView = nil;
            userAnnotationView.enabled = YES;
            userAnnotationView.canShowCallout = YES;
            userAnnotationView.image = userAnnotationView.isPreBid?[UIImage imageNamed:@"icon_pinGreen"]:[UIImage imageNamed:@"icon_pinRed"];
            
            annotationView = userAnnotationView;
        } else {
            
            NewProjectAnnotationView *userAnnotationView = (NewProjectAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"NewPin"];
            if (userAnnotationView == nil)  {
                userAnnotationView = [[NewProjectAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"NewPin"];
            } else
                userAnnotationView.annotation = annotation;
            userAnnotationView.rightCalloutAccessoryView = nil;
            userAnnotationView.enabled = YES;
            userAnnotationView.canShowCallout = YES;
            userAnnotationView.image = [UIImage imageNamed:@"icon_userPinNew"];
            
            annotationView = userAnnotationView;
            
        }
    }
    
    [self getVisibleAnmotationsInMap];
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    for (MKAnnotationView* view in views)
    {
        if ([view.annotation isKindOfClass:[MKUserLocation class]])
        {
            view.canShowCallout = NO;
        }
    }
}

- (void) addNewProjectPin {
    NewProjectAnnotation *annotation = [[NewProjectAnnotation alloc] init];
    annotation.coordinate = self.mapView.centerCoordinate;
    [self.mapView addAnnotation:annotation];
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
        controller.parentCtrl = self;
        [self.navigationController presentViewController:controller animated:NO completion:nil];
    } else if ([subview class ] == NSClassFromString(@"MKModernUserLocationView")) {
        
        MKAnnotationView *annotationView = (MKAnnotationView*)subview;
        MKUserLocation *userLocation = annotationView.annotation;
        UserLocationPinViewController *controller = [UserLocationPinViewController new];
        controller.location = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        
        controller.popoverPresentationController.sourceView = subview;
        controller.popoverPresentationController.sourceRect = CGRectMake(0, 0, subview.frame.size.width, subview.frame.size.height);
        controller.createProjectPinDelegate = self;
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
    } else if([subview class] == [NewProjectAnnotationView class]) {
   
        NewProjectAnnotationView *annotationView = (NewProjectAnnotationView*)subview;
        MKUserLocation *userLocation = annotationView.annotation;
        NewPinViewController *controller = [NewPinViewController new];
        controller.location = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        
        controller.popoverPresentationController.sourceView = subview;
        controller.popoverPresentationController.sourceRect = CGRectMake(0, 0, subview.frame.size.width, subview.frame.size.height);
        controller.createProjectPinDelegate = self;
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
                         
                         [self loadProjects:1 coordinate:region.center regionValue:0];
                         
                         
                     } else if (error != nil) {
                         BOOL connected = [[BaseManager sharedManager] connected];
                         if (connected) {
                             [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"PROJECTS_NEAR_LOCATION_INVALID")];
                         }
                         
                     }
                 }
     ];

}

-(void)getVisibleAnmotationsInMap {
        MKMapRect visibleMapRect = self.mapView.visibleMapRect;
        NSSet *visibleAnnotations = [self.mapView annotationsInMapRect:visibleMapRect];
        NSArray *annotationArray = [visibleAnnotations allObjects];
        self.projectNearMeListView.visibleAnnotationArray = annotationArray;
        [self.projectNearMeListView setDataBasedOnVisible];
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

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    if (isDoneSearching) {

        [self getVisibleAnmotationsInMap];
        if (!animated) {
            double lat = mapView.centerCoordinate.latitude;
            double lng = mapView.centerCoordinate.longitude;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
            
            CGFloat miles = MetersToMiles([self getRadius]);
            if (miles<1) {
                miles = 2;
            } else {
                miles = round(miles);
            }
            [self loadProjects:miles coordinate:coordinate regionValue:miles];
        }
        
    }
    
}

- (CLLocationDistance)getRadius
{
    CLLocationCoordinate2D centerCoor = [self getCenterCoordinate];
   
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
    
    CLLocationCoordinate2D topCenterCoor = [self getTopCenterCoordinate];
    CLLocation *topCenterLocation = [[CLLocation alloc] initWithLatitude:topCenterCoor.latitude longitude:topCenterCoor.longitude];
    
    CLLocationDistance radius = [centerLocation distanceFromLocation:topCenterLocation];
    
    return radius;
}

- (CLLocationCoordinate2D)getCenterCoordinate
{
    CLLocationCoordinate2D centerCoor = [self.mapView centerCoordinate];
    return centerCoor;
}

- (CLLocationCoordinate2D)getTopCenterCoordinate
{
    CLLocationCoordinate2D topCenterCoor = [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width / 2.0f, 0) toCoordinateFromView:self.mapView];
    return topCenterCoor;
}

- (void)applySearchFilter:(NSDictionary *)filter {

    filterDictionary = filter;
    
    if (filterDictionary == nil) {
        filterDictionary = [NSDictionary new];
    }
    
    if (_textFieldSearch.text.length>0) {
        [self searchForLocation];
    } else {
        [self mapView:self.mapView regionDidChangeAnimated:NO];
    }
}

- (void)createProjectUsingLocation:(CLLocation *)location {
    
    NewProjectViewController *controller = [NewProjectViewController new];
    controller.location = location;
    controller.pinType = pinTypeUserNew;
    controller.projectViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)tappedSavedNewProject:(id)object {
    [[DataManager sharedManager] projectDetail:object success:^(id object) {
        
        ProjectDetailViewController *detail = [ProjectDetailViewController new];
        detail.view.hidden = NO;
        [detail detailsFromProject:object];
        isLocationCaptured = NO;
        [self.navigationController pushViewController:detail animated:YES];
    } failure:^(id object) {
    }];

}
@end

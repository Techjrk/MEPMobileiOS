//
//  ProjectsNearMeViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectsNearMeViewController.h"

#import "projectsNearMeConstants.h"
#import "ShareLocationViewController.h"
#import "GoToSettingsViewController.h"
#import "ProjectAnnotationView.h"
#import "ProjectPointAnnotation.h"
#import "CallOutViewController.h"
#import "ProjectPointAnnotation.h"
#import <MapKit/MapKit.h>

@interface ProjectsNearMeViewController ()<ShareLocationDelegate, GoToSettingsDelegate, MKMapViewDelegate>{
    BOOL isFirstLaunch;
    NSMutableArray *mapItems;
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
    if([[DataManager sharedManager] locationManager].currentStatus == kCLAuthorizationStatusAuthorizedAlways) {
        [self loadProjects:5];
    }
}

- (void)NotificationAppBecomeActive:(NSNotification*)notification {
    [self viewWasLaunced];
}

- (void)NotificationLocationDenied:(NSNotification*)notification {
    [self gotoSettings];
}

- (void)NotificationLocationAllowed:(NSNotification*)notification {
    [self loadProjects:5];
}

- (void)loadProjects:(int)distance {
    
    CGFloat lat = 39.65718;
    CGFloat lng = -83.90974;
    
    [mapItems removeAllObjects];
    [_mapView removeAnnotations:_mapView.annotations];

    [[DataManager sharedManager] projectsNear:lat lng:lng distance:[NSNumber numberWithInt:distance] filter:nil success:^(id object) {
        
        NSArray *result = object[@"results"];
        if (result != nil & result.count>0) {
        
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);

            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, MilesToMeters(distance), MilesToMeters(distance));
            
            [_mapView setRegion:region];

            [mapItems addObjectsFromArray:result];
            [self addItemsToMap];
        } else {
            if (distance == 5) {
                [self loadProjects:100];
            }
        }
    } failure:^(id object) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedButtonback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (void)viewDidAppear:(BOOL)animated {
    [self viewWasLaunced];
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
    MKAnnotationView *userAnnotationView = nil;
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
        userAnnotationView.image = [UIImage imageNamed:@"icon_pinOrange"];
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
        [self.navigationController presentViewController:controller animated:NO completion:nil];
    }
}

@end

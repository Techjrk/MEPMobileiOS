//
//  ContactDetailViewController.m
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactNavBarView.h"
#import "ContactDetailView.h"
#import "ContactFieldView.h"
#import "DB_CompanyContact.h"
#import "DB_Company.h"
#import <MapKit/MapKit.h>

@interface ContactDetailViewController()<ContactNavViewDelegate,ContactDetailViewDelegate>{
    NSMutableArray *contactDetails;
    NSString *name;
    NSString *address;
    
}
@property (weak, nonatomic) IBOutlet ContactNavBarView *contactNavBarView;
@property (weak, nonatomic) IBOutlet ContactDetailView *contactDetailView;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _contactNavBarView.contactNavViewDelegate =self;
    _contactDetailView.contactDetailViewDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_contactNavBarView setNameTitle:name];
    [_contactDetailView setItems:contactDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCompanyContactDetails:(id)item {
    
    DB_CompanyContact *record = item;
    DB_Company *recordCompany = record.relationshipCompany;

    name = record.name;
   
    NSMutableArray *contactItem = [NSMutableArray new];
    
    if (record.title) {
        NSString *accountTitleAndName = [NSString stringWithFormat:@"%@ at %@",record.title,recordCompany.name];
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeAccount ], CONTACT_FIELD_DATA:accountTitleAndName}];
    }
    if ([record fullAddress]) {
        NSString *contactAddressInfo = [record fullAddress];
        address = contactAddressInfo;
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeLocation ], CONTACT_FIELD_DATA:contactAddressInfo}];
    }
    if (record.phoneNumber) {
    
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypePhone ], CONTACT_FIELD_DATA:record.phoneNumber}];
    }
    if (record.email) {
        
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeEmail ], CONTACT_FIELD_DATA:record.email}];
    }
    
    contactDetails = contactItem;
    
}


- (NSString *)determineIfTitleIsEmpty:(NSString *)title {
    
    if (title) {
        return [NSString stringWithFormat:@"%@ at",title];
    }else{
        return @"";
    }
    
}


#pragma mark - Contact Nav Delegate
- (void)tappedContactNavBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ContactView Delegate
- (void)selectedContactDetails:(id)item {
    
    NSNumber *fieldType = item[CONTACT_FIELD_TYPE];
    NSString *fieldData = item[CONTACT_FIELD_DATA];
    
    switch (fieldType.integerValue) {
        case ContactFieldTypePhone:{
            fieldData = [[fieldData stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:fieldData]]];
            break;
        }
        case ContactFieldTypeAccount:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ContactFieldTypeLocation:{
            [self searchForLocation];
            break;
        }
        case ContactFieldTypeWeb:{
            NSString *field = [fieldData uppercaseString];
            if (![field hasPrefix:@"HTTP://"]) {
                fieldData = [@"http://" stringByAppendingString:fieldData];
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fieldData]];
            
            break;
        }
            
        case ContactFieldTypeEmail: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto:" stringByAppendingString:fieldData]]];
            
            break;
        }
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)searchForLocation {
    NSString *location = address;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     if (placemarks && placemarks.count > 0) {
            
                         CLPlacemark *result = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:result];
                         MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                         NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
                         [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
                         [endingItem openInMapsWithLaunchOptions:launchOptions];
                         
                     } else if (error != nil) {
                         [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"PROJECTS_NEAR_LOCATION_INVALID")];
                     }
                 }
     ];
    
}


@end

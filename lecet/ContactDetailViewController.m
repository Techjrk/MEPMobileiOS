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
#import <DataManagerSDK/DB_CompanyContact.h>
#import <DataManagerSDK/DB_Company.h>
#import <MapKit/MapKit.h>
#import "CompanyDetailViewController.h"

@interface ContactDetailViewController()<ContactNavViewDelegate,ContactDetailViewDelegate>{
    NSMutableArray *contactDetails;
    NSString *name;
    NSString *address;
    NSNumber *companyId;
}
@property (weak, nonatomic) IBOutlet ContactNavBarView *contactNavBarView;
@property (weak, nonatomic) IBOutlet ContactDetailView *contactDetailView;
@end

@implementation ContactDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:[[self class] description] bundle:nibBundleOrNil];
    return self;
}

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
    
    companyId = record.relationshipCompany.recordId;
   
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

- (void)setCompanyContactDetailsFromDictionary:(id)item {
    NSDictionary *record = item;
    name = record[@"name"];

    NSDictionary *recordCompany = [DerivedNSManagedObject objectOrNil:record[@"company"]];
    NSString *companyName = [DerivedNSManagedObject objectOrNil:recordCompany[@"name"]];
    
    companyId = [DerivedNSManagedObject objectOrNil:record[@"companyId"]];
    
    if (companyName == nil) {
        companyName = @"";
    }
    
    NSMutableArray *contactItem = [NSMutableArray new];
    NSString *title = [DerivedNSManagedObject objectOrNil:record[@"title"]];
    
    if (title != nil) {
        NSString *accountTitleAndName = [NSString stringWithFormat:@"%@ at %@",title,companyName];
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeAccount ], CONTACT_FIELD_DATA:accountTitleAndName}];
    }
    
    
    NSString *fullAddr = @"";
    NSString *address1 = [DerivedNSManagedObject objectOrNil:recordCompany[@"address1"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:recordCompany[@"state"]];;
    NSString *zip5 = [DerivedNSManagedObject objectOrNil:recordCompany[@"zipPlus4"]];;
    
    if(address1 != nil) {
        fullAddr = [fullAddr stringByAppendingString:address1];
        
        if (state != nil | zip5 != nil) {
            fullAddr = [fullAddr stringByAppendingString:@", "];
        }
    }
    
    if (state != nil) {
        fullAddr = [fullAddr stringByAppendingString:state];
        
        if (zip5 != nil) {
            fullAddr = [fullAddr stringByAppendingString:@" "];
        }
    }
    
    if (zip5 != nil) {
        fullAddr = [fullAddr stringByAppendingString:zip5];
        
    }

    if (fullAddr) {
        NSString *contactAddressInfo = fullAddr;
        address = contactAddressInfo;
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeLocation ], CONTACT_FIELD_DATA:contactAddressInfo}];
    }
    
    NSString *phoneNumber = [DerivedNSManagedObject objectOrNil:record[@"phoneNumber"]];
    NSString *email = [DerivedNSManagedObject objectOrNil:record[@"email"]];
    if (phoneNumber) {
        
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypePhone ], CONTACT_FIELD_DATA:phoneNumber}];
    }
    if (email) {
        
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeEmail ], CONTACT_FIELD_DATA:email}];
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
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:fieldData]] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];
            break;
        }
        case ContactFieldTypeAccount:{
            [[DataManager sharedManager] companyDetail:companyId success:^(id object) {
                id returnObject = object;
                CompanyDetailViewController *controller = [CompanyDetailViewController new];
                controller.view.hidden = NO;
                [controller setInfo:returnObject];
                [self.navigationController pushViewController:controller animated:YES];
                
            } failure:^(id object) {
            }];
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
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fieldData] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];
            
            break;
        }
            
        case ContactFieldTypeEmail: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto:" stringByAppendingString:fieldData]] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];
            
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

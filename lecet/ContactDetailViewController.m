//
//  ContactDetailViewController.m
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactNavBarView.h"
#import "DB_CompanyContact.h"
#import "contactFieldConstants.h"
#import "ContactDetailView.h"

@interface ContactDetailViewController()<ContactNavViewDelegate>{
    NSMutableArray *contactDetails;
    NSString *name;
    
}
@property (weak, nonatomic) IBOutlet ContactNavBarView *contactNavBarView;
@property (weak, nonatomic) IBOutlet ContactDetailView *contactDetailView;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _contactNavBarView.contactNavViewDelegate =self;
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
    
    /*
    NSMutableArray *contactItem = [@[ @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypePhone ], CONTACT_FIELD_DATA:@"(734) 591-3400"}, @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeEmail ], CONTACT_FIELD_DATA:@"companyinfo@jaydeecontr.com"}, @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeWeb], CONTACT_FIELD_DATA:@"www.jaydeecontr.com"}] mutableCopy];
    */
    
    //@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypePhone ], CONTACT_FIELD_DATA:@"(734) 591-3400"}
    
    
    name = record.name;
    NSLog(@"Email = %@",record.email);
    
    NSMutableArray *contactItem = [@[ @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypePhone ], CONTACT_FIELD_DATA:record.phoneNumber}, @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeEmail ], CONTACT_FIELD_DATA:record.email}, @{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeWeb], CONTACT_FIELD_DATA:@"www.jaydeecontr.com"}] mutableCopy];
    
    contactDetails = contactItem;
    
    
    
}

#pragma mark - Contact Nav Delegate
- (void)tappedContactNavBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

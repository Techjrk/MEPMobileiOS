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
#import "contactFieldConstants.h"

#import "DB_CompanyContact.h"
#import "DB_Company.h"

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
    DB_Company *recordCompany = record.relationshipCompany;

    name = record.name;
   
    NSMutableArray *contactItem = [NSMutableArray new];
    
    if (record.title) {
        

        NSString *accountTitleAndName = [NSString stringWithFormat:@"%@ at %@",record.title,recordCompany.name];
        [contactItem addObject:@{CONTACT_FIELD_TYPE:[NSNumber numberWithInteger:ContactFieldTypeAccount ], CONTACT_FIELD_DATA:accountTitleAndName}];
    }
    if (recordCompany.address1) {
        NSString *contactAddressInfo = [NSString stringWithFormat:@"%@ %@, %@ %@",recordCompany.address1,recordCompany.city,recordCompany.state,recordCompany.zipPlus4];
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
@end

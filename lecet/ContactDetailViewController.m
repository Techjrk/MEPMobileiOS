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

@interface ContactDetailViewController()<ContactNavViewDelegate>{
    DB_CompanyContact *contactDetails;
    
}
@property (weak, nonatomic) IBOutlet ContactNavBarView *contactNavBarView;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _contactNavBarView.contactNavViewDelegate =self;
}


- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setCompanyContactDetails:(id)item {
    
    contactDetails = item;
}

#pragma mark - Contact Nav Delegate
- (void)tappedContactNavBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

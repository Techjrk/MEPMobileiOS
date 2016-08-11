//
//  MyProfileViewController.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ProfileNavView.h"
#import "MyProfileView.h"
#import "MyProfileHeaderView.h"

@interface MyProfileViewController ()<ProfileNavViewDelegate> {
    
    id myProfileInfo;
}
@property (weak, nonatomic) IBOutlet ProfileNavView *profileNavView;
@property (weak, nonatomic) IBOutlet MyProfileView *myProfileView;

@end

@implementation MyProfileViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:[[self class] description] bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_profileNavView setNavTitleLabel:@"My Profile"];
    _profileNavView.profileNavViewDelegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissedKeyboard ) name:NOTIFYTODISMISSKEYBOARD object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
   
    [self setTextFieldText];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav View Delegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    
    switch (profileNavItem) {
        case ProfileNavItemBackButton:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case ProfileNavItemSaveButton:
            [self saveData];
            break;
    }
    
    
}

- (void)saveData {
    [[DataManager sharedManager] featureNotAvailable];
}

- (void)setInfo:(id)info {
    myProfileInfo = info;
}

- (void)setTextFieldText {

    
    [_myProfileView setFirstNamePlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_FIRSTNAME")];
    [_myProfileView setFirstName:myProfileInfo[@"first_name"]];
    
    [_myProfileView setLastNamePlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_LASTNAME")];
    [_myProfileView setLastName:myProfileInfo[@"last_name"]];
    
    [_myProfileView setEmailAddressPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_EMAIL_ADDRESS")];
    [_myProfileView setEmailAddress:myProfileInfo[@"email"]];
    
    //[_myProfileView setTitle:@"Director of Operations"];
    [_myProfileView setTitlePlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_TITLE")];
    [_myProfileView setTitle:myProfileInfo[@"title"]];
    
    //[_myProfileView setOrganization:@"Laborers-Employers CooperaMon and EducaMon Trust (LECET)"];
    [_myProfileView setOrganizationPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_ORGANIZATION")];
    [_myProfileView setOrganization:myProfileInfo[@"organization"]];
    
    //[_myProfileView setPhone:@"(718) 501-1234"];
    [_myProfileView setPhonePlaceHolder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_PHONE")];
    [_myProfileView setPhone:myProfileInfo[@"phoneNumber"]];
    
    //[_myProfileView setFax:@"(718) 432-9873"];
    [_myProfileView setFaxPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_FAX")];
    [_myProfileView setFax:@"(718) 432-9873"];
    
    //[_myProfileView setStreetAddress:@"905 16th St NW"];
    [_myProfileView setStreetAddressPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_STREETADDRESS")];
    [_myProfileView setStreetAddress:myProfileInfo[@"address"]];
    
    //[_myProfileView setCity:@"Washington"];
    [_myProfileView setCityPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_CITY")];
    [_myProfileView setCity:myProfileInfo[@"city"]];
    
    //[_myProfileView setState:@"DC"];
    [_myProfileView setStatePlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_STATE")];
    [_myProfileView setState:myProfileInfo[@"state"]];
    
    //[_myProfileView setZIP:@"20006"];
    [_myProfileView setZIPPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_ZIP")];
    [_myProfileView setZIP:myProfileInfo[@"zip"]];
    
}

- (void)dismissedKeyboard {
    [self.view endEditing:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end


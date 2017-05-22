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
            [self dismissedKeyboard];
            break;
    }
}

- (void)saveData {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setValue:[_myProfileView getFirstName] forKey:@"first_name"];
    [dict setValue:[_myProfileView getLastName] forKey:@"last_name"];
    [dict setValue:[_myProfileView getEmail] forKey:@"email"];
    [dict setValue:[_myProfileView getEmail] forKey:@"email"];
    [dict setValue:[_myProfileView getTitle] forKey:@"title"];
    [dict setValue:[_myProfileView getOrganization] forKey:@"organization"];
    [dict setValue:[_myProfileView getPhone] forKey:@"phoneNumber"];
    [dict setValue:[_myProfileView getFax] forKey:@"faxNumber"];
    [dict setValue:[_myProfileView getStreetAddress] forKey:@"address"];
    [dict setValue:[_myProfileView getCity] forKey:@"city"];
    [dict setValue:[_myProfileView getState] forKey:@"state"];
    [dict setValue:[_myProfileView getCity] forKey:@"city"];
    [dict setValue:[_myProfileView getZip] forKey:@"zip"];
    
    NSString *userId =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
    NSNumber *num = @([userId intValue]);
    [[DataManager sharedManager] updateUserInformation:num userUpdateData:dict success:^(id Object) {
        
        myProfileInfo = Object;
        [self setTextFieldText];
        [[DataManager sharedManager] promptMessage:@"Successfully Updated"];
        
    }failure:^(id fObject) {
        //NSLog(@"F = %@",fObject);
    }];
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
    
    [_myProfileView setTitlePlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_TITLE")];
    [_myProfileView setTitle:myProfileInfo[@"title"]];
    
    [_myProfileView setOrganizationPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_ORGANIZATION")];
    [_myProfileView setOrganization:myProfileInfo[@"organization"]];
    
    [_myProfileView setPhonePlaceHolder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_PHONE")];
    [_myProfileView setPhone:myProfileInfo[@"phoneNumber"]];
    
    [_myProfileView setFaxPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_FAX")];
    [_myProfileView setFax:myProfileInfo[@"faxNumber"]];
    
    [_myProfileView setStreetAddressPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_STREETADDRESS")];
    [_myProfileView setStreetAddress:myProfileInfo[@"address"]];
    
    [_myProfileView setCityPlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_CITY")];
    [_myProfileView setCity:myProfileInfo[@"city"]];
    
    [_myProfileView setStatePlaceholder:NSLocalizedLanguage(@"MYPROFILE_PLACEHOLDER_TEXT_STATE")];
    [_myProfileView setState:myProfileInfo[@"state"]];
    
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


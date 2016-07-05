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

    if ([DerivedNSManagedObject objectOrNil:myProfileInfo[@"first_name"]]) {
        [_myProfileView setFirstName:myProfileInfo[@"first_name"]];
    }

    if ([DerivedNSManagedObject objectOrNil:myProfileInfo[@"last_name"]]) {
        [_myProfileView setLastName:myProfileInfo[@"last_name"]];
    }
    
    if ([DerivedNSManagedObject objectOrNil:myProfileInfo[@"email"]]) {
        [_myProfileView setEmailAddress:myProfileInfo[@"email"]];
    }
    [_myProfileView setOrganization:@"Laborers-Employers CooperaMon and EducaMon Trust (LECET)"];
    [_myProfileView setTitle:@"Director of Operations"];
    [_myProfileView setPhone:@"(718) 501-1234"];
    [_myProfileView setFax:@"(718) 432-9873"];
    [_myProfileView setStreetAddress:@"905 16th St NW"];
    [_myProfileView setCity:@"Washington"];
    [_myProfileView setState:@"DC"];
    [_myProfileView setZIP:@"20006"];
    
}

- (void)dismissedKeyboard {
    [self.view endEditing:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end


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
#import "myProfileConstant.h"

@interface MyProfileViewController ()<ProfileNavViewDelegate> {
    
    id myProfileInfo;
}
@property (weak, nonatomic) IBOutlet ProfileNavView *profileNavView;
@property (weak, nonatomic) IBOutlet MyProfileView *myProfileView;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_profileNavView setNavTitleLabel:@"My Profile"];
    _profileNavView.profileNavViewDelegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissedKeyboard ) name:NOTIFYTODISMISSKEYBOARD object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
   
    [self setTextFieldText];
    
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
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


#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)dismissedKeyboard {
    [self.view endEditing:YES];
    
}

@end


//
//  LoginViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "LoginViewController.h"

#import "CustomTextField.h"
#import "DashboardViewController.h"

#import "loginConstants.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet CustomTextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet CustomTextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
- (IBAction)tappedButtonLogin:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _constraintContainerHeight.constant = kDeviceHeight * 0.47;
    
    [_textFieldEmail setPlaceHolder:NSLocalizedLanguage(@"LOGIN_PLACEHOLDER_EMAIL")];
    [_textFieldPassword setPlaceHolder:NSLocalizedLanguage(@"LOGIN_PLACEHOLDER_PASSWORD")];
    
    [_buttonLogin setTitle:NSLocalizedLanguage(@"LOGIN_BUTTON_TEXT") forState:UIControlStateNormal];
    _buttonLogin.titleLabel.font = LOGIN_BUTTON_FONT;
    _buttonLogin.backgroundColor = LOGIN_BUTTON_BG_COLOR;
    _buttonLogin.layer.shadowColor = LOGIN_BUTTON_SHADOW_COLOR.CGColor;
    _buttonLogin.layer.shadowRadius = 4;
    _buttonLogin.layer.shadowOffset = CGSizeMake(2, 2);
    _buttonLogin.layer.shadowOpacity = 0.5;
    _buttonLogin.layer.masksToBounds = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)tappedButtonLogin:(id)sender {
    [self.navigationController pushViewController:[DashboardViewController new] animated:YES];
}

@end

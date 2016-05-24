//
//  LoginViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "LoginViewController.h"

#import "CustomTextField.h"

#import "loginConstants.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet CustomTextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet CustomTextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
- (IBAction)tappedButtonLogin:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSpace;
@end

@implementation LoginViewController
@synthesize loginDelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableTapGesture:YES];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LAUNCHSCREEN"];
    controller.view.frame = self.view.frame;
    [self.view addSubview:controller.view];
    
    [self.view sendSubviewToBack:controller.view];
 
    [self addBlurEffect:_blurView];
    _blurView.alpha = 0;
    _scrollView.alpha = 0;
    
    _constraintTopSpace.constant = kDeviceHeight * 0.3;

    _constraintContainerHeight.constant = kDeviceHeight * 0.47;
    
    [_textFieldEmail setPlaceHolder:NSLocalizedLanguage(@"LOGIN_PLACEHOLDER_EMAIL")];
    
    [_textFieldPassword setPlaceHolder:NSLocalizedLanguage(@"LOGIN_PLACEHOLDER_PASSWORD")];
    [_textFieldPassword setSecure:YES];
    
    [_buttonLogin setTitle:NSLocalizedLanguage(@"LOGIN_BUTTON_TEXT") forState:UIControlStateNormal];
    _buttonLogin.titleLabel.font = LOGIN_BUTTON_FONT;
    _buttonLogin.backgroundColor = LOGIN_BUTTON_BG_COLOR;
    _buttonLogin.layer.shadowColor = LOGIN_BUTTON_SHADOW_COLOR.CGColor;
    _buttonLogin.layer.shadowRadius = 4;
    _buttonLogin.layer.shadowOffset = CGSizeMake(2, 2);
    _buttonLogin.layer.shadowOpacity = 0.5;
    _buttonLogin.layer.masksToBounds = NO;
    
    if (isDebug) {
        [_textFieldEmail setText: @"harry.camigla@domandtom.com"];
        [_textFieldPassword setText: @"3nB72JTrRB7Uu4mFRpFppV6PN"];
    }
}


- (void)addBlurEffect:(UIView*)view {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = view.frame;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc]initWithEffect:vibrancyEffect];
    vibrancyEffectView.frame = self.view.frame;
    vibrancyEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    view.backgroundColor = [UIColor clearColor];
    [_blurView addSubview:blurEffectView];
    [_blurView addSubview:vibrancyEffectView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)tappedButtonLogin:(id)sender {
    
    [[DataManager sharedManager] userLogin:[_textFieldEmail text] password:[_textFieldPassword text] success:^(id object) {
        NSString *token = object[@"id"];
        
        [[DataManager sharedManager] storeKeyChainValue:kKeychainAccessToken password:token serviceName:kKeychainServiceName];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.loginDelegate login];
        }];
        
    } failure:^(id object) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        _blurView.alpha = 1;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _scrollView.alpha = 1;
                _constraintTopSpace.constant = 0;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_textFieldEmail becomeFirstResponder];
}

@end

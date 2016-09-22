//
//  LoginViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "LoginViewController.h"

#import "CustomTextField.h"

#define LOGIN_BUTTON_FONT                   fontNameWithSize(FONT_NAME_LATO_BOLD, 12.0)
#define LOGIN_BUTTON_BG_COLOR               RGB(8, 73, 124)
#define LOGIN_BUTTON_SHADOW_COLOR           RGB(0, 0, 0)

#define LOGIN_SIGNUP_FONT                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 12.0)
#define LOGIN_SIGNUP_COLOR                  RGB(72, 72, 74)

#define LOGIN_SIGNUP_URL                    [kHost stringByAppendingString:@"#/onboarding"]

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet CustomTextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet CustomTextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSpace;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignUp;
@property (weak, nonatomic) IBOutlet UIButton *buttonTouchId;

- (IBAction)tappedButtonSignUp:(id)sender;
- (IBAction)tappedButtonLogin:(id)sender;
- (IBAction)tappedTouchId:(id)sender;
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
    _buttonTouchId.hidden = YES;

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
   
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:NSLocalizedLanguage(@"LOGIN_SIGNUP") attributes:@{NSFontAttributeName:LOGIN_SIGNUP_FONT, NSForegroundColorAttributeName:LOGIN_SIGNUP_COLOR, NSUnderlineStyleAttributeName:[NSNumber numberWithBool:YES]}];
    [_buttonSignUp setAttributedTitle:title forState:UIControlStateNormal];
    
    _buttonTouchId.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([[DataManager sharedManager] isDebugMode]) {
        
        //[_textFieldEmail setText:@"brickard@liuna.org"];
        //[_textFieldPassword setText:@"H8YhofaeZ4SLKMd2ajR03vdxnkVrvOMG"];
        [_textFieldEmail setText: @"harry.camigla@domandtom.com"];
        [_textFieldPassword setText: @"3nB72JTrRB7Uu4mFRpFppV6PN"];
        //[_textFieldEmail setText: @"brickard@liuna.org"];
        //[_textFieldPassword setText: @"H8YhofaeZ4SLKMd2ajR03vdxnkVrvOMG"];

        //[_textFieldEmail setText: @"amarocco@lecet.org"];
        //[_textFieldPassword setText: @"feelthepower905"];
        //[_textFieldEmail setText: @"kayle.saunar@domandtom.com"];
        //[_textFieldPassword setText: @"aaaa1234"];
        
        //[_textFieldEmail setText: @"bdonohue@lecet.org"];
        //[_textFieldPassword setText: @"lecet1"];
        
        //[_textFieldEmail setText:@"dbianco@neliuna.org"];
        //[_textFieldPassword setText: @"liuna9"];
        
        //[_textFieldEmail setText:@"no1adzeman@yahoo.com"];
        //[_textFieldPassword setText: @"local1421"];
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

- (void)processLogin:(NSDictionary*)object {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.loginDelegate login];
        
    }];

}

- (IBAction)tappedButtonLogin:(id)sender {
    
    NSString *email = [_textFieldEmail text];
    NSString *passsword = [_textFieldPassword text];
    
    if (email.length == 0 | passsword.length == 0) {
        
        if (email.length == 0) {
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"LOGIN_REQUIRED_EMAIL")];
            [_textFieldEmail becomeFirstResponder];
        } else {
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"LOGIN_REQUIRED_PASSWORD")];
            [_textFieldPassword becomeFirstResponder];
        }
        return;
    }
    
    [[DataManager sharedManager] userLogin:[_textFieldEmail text] password:[_textFieldPassword text] success:^(id object) {
        [self processLogin:object];
    } failure:^(id object) {
        [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"LOGIN_AUTH_ERROR_MSG")];
    }];
}

- (IBAction)tappedTouchId:(id)sender {
    [[TouchIDManager sharedTouchIDManager] authenticateWithSuccessHandler:^{
        [[DataManager sharedManager] loginFingerPrintForSuccess:^(id object) {
            [self processLogin:object];
        } failure:^(id object) {
            [[DataManager sharedManager] promptMessage:NSLocalizedLanguage(@"LOGIN_AUTH_ERROR_MSG")];
            
        }];
    } error:^{
        
    } viewController:self];

/*
     NSString *str = [[TouchIDManager sharedTouchIDManager] canAuthenticate];
     
     if (str.length==0) {
     } else {
         [[DataManager sharedManager] promptMessage:str];
     }
    
*/
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _buttonTouchId.hidden = YES;
    _constraintContainerHeight.constant = _buttonSignUp.frame.size.height + _buttonSignUp.frame.origin.y;
    
    [UIView animateWithDuration:0.5 animations:^{
        _blurView.alpha = 1;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _scrollView.alpha = 1;
                _constraintTopSpace.constant = 0;
                
                _buttonTouchId.hidden = YES;
                _constraintContainerHeight.constant = _buttonSignUp.frame.size.height + _buttonSignUp.frame.origin.y;

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

- (IBAction)tappedButtonSignUp:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LOGIN_SIGNUP_URL]];
}

@end

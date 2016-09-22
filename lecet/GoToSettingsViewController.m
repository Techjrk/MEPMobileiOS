//
//  GoToSettingsViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/4/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "GoToSettingsViewController.h"

#define GOTO_SETTINGS_MSG_FONT                      fontNameWithSize(FONT_NAME_LATO_REGULAR, 13)
#define GOTO_SETTINGS_MSG_COLOR                     RGB(34, 34, 34)

#define GOTO_SETTINGS_BUTTON_SETTINGS_FONT          fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define GOTO_SETTINGS_BUTTON_SETTINGS_COLOR         RGB(255, 255, 255)
#define GOTO_SETTINGS_BUTTON_SETTINGS_BG_COLOR      RGB(0, 63, 114)

#define GOTO_SETTINGS_BUTTON_CANCEL_FONT            fontNameWithSize(FONT_NAME_LATO_BOLD, 10)
#define GOTO_SETTINGS_BUTTON_CANCEL_COLOR           RGB(0, 63, 114)

@interface GoToSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;
@property (weak, nonatomic) IBOutlet UILabel *labelMsg;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
- (IBAction)tappedButtonSettings:(id)sender;
- (IBAction)tappedButtonCancel:(id)sender;

@end

@implementation GoToSettingsViewController
@synthesize goToSettingsDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self enableTapGesture:YES];

    self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];

    [self addBlurEffect:_blurView];
    _container.layer.cornerRadius =  kDeviceWidth * 0.0106;
    _container.layer.masksToBounds = YES;
    
    _containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _containerView.layer.shadowRadius = 4;
    _containerView.layer.shadowOffset = CGSizeMake(2, 4);
    _containerView.layer.shadowOpacity = 0.25;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = GOTO_SETTINGS_BUTTON_SETTINGS_FONT.lineHeight;
    paragraphStyle.maximumLineHeight = GOTO_SETTINGS_BUTTON_SETTINGS_FONT.lineHeight;
    paragraphStyle.lineSpacing = GOTO_SETTINGS_BUTTON_SETTINGS_FONT.lineHeight * 0.3;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *msg = [[NSAttributedString alloc] initWithString:NSLocalizedLanguage(@"GOTO_SETTINGS_MSG") attributes:@{NSFontAttributeName:GOTO_SETTINGS_MSG_FONT, NSForegroundColorAttributeName:GOTO_SETTINGS_MSG_COLOR, NSParagraphStyleAttributeName:paragraphStyle}];
    _labelMsg.attributedText = msg ;
    
    [_buttonSettings setTitle:NSLocalizedLanguage(@"GOTO_SETTINGS_BUTTON_SETTINGS_TEXT") forState:UIControlStateNormal];
    [_buttonSettings setTitleColor:GOTO_SETTINGS_BUTTON_SETTINGS_COLOR forState:UIControlStateNormal];
    _buttonSettings.titleLabel.font = GOTO_SETTINGS_BUTTON_SETTINGS_FONT;
    _buttonSettings.backgroundColor = GOTO_SETTINGS_BUTTON_SETTINGS_BG_COLOR;
    
    [_buttonCancel setTitle:NSLocalizedLanguage(@"GOTO_SETTINGS_BUTTON_CANCEL_TEXT") forState:UIControlStateNormal];
    [_buttonCancel setTitleColor:GOTO_SETTINGS_BUTTON_CANCEL_COLOR forState:UIControlStateNormal];
    _buttonCancel.titleLabel.font = GOTO_SETTINGS_BUTTON_CANCEL_FONT;

}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    
    //UIView* view = sender.view;
    //CGPoint loc = [sender locationInView:view];
    //UIView* subview = [view hitTest:loc withEvent:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addBlurEffect:(UIView*)view {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = view.frame;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurEffectView.userInteractionEnabled = NO;
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc]initWithEffect:vibrancyEffect];
    vibrancyEffectView.frame = self.view.frame;
    vibrancyEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    vibrancyEffectView.userInteractionEnabled = NO;
    
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:blurEffectView];
    [view addSubview:vibrancyEffectView];
    
}

- (IBAction)tappedButtonSettings:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.goToSettingsDelegate tappedButtonGotoSettings:nil];
    }];
}

- (IBAction)tappedButtonCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.goToSettingsDelegate tappedButtonGotoSettingsCancel:nil];
    }];
}

@end

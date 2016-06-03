//
//  ShareLocationViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ShareLocationViewController.h"

#import "shareLocationConstants.h"

@interface ShareLocationViewController ()
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *labelMsg;
@property (weak, nonatomic) IBOutlet UIButton *buttonShareLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
- (IBAction)tappedButtonShare:(id)sender;
- (IBAction)tappedButtonCancel:(id)sender;
@end

@implementation ShareLocationViewController

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
    paragraphStyle.minimumLineHeight = SHARE_LOCATION_BUTTON_SHARE_FONT.lineHeight;
    paragraphStyle.maximumLineHeight = SHARE_LOCATION_BUTTON_SHARE_FONT.lineHeight;
    paragraphStyle.lineSpacing = SHARE_LOCATION_BUTTON_SHARE_FONT.lineHeight * 0.3;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *msg = [[NSAttributedString alloc] initWithString:NSLocalizedLanguage(@"SHARE_LOCATION_MSG") attributes:@{NSFontAttributeName:SHARE_LOCATION_MSG_FONT, NSForegroundColorAttributeName:SHARE_LOCATION_MSG_COLOR, NSParagraphStyleAttributeName:paragraphStyle}];
    _labelMsg.attributedText = msg ;
    
    [_buttonShareLocation setTitle:NSLocalizedLanguage(@"SHARE_LOCATION_BUTTON_SHARE") forState:UIControlStateNormal];
    [_buttonShareLocation setTitleColor:SHARE_LOCATION_BUTTON_SHARE_COLOR forState:UIControlStateNormal];
    _buttonShareLocation.titleLabel.font = SHARE_LOCATION_BUTTON_SHARE_FONT;
    _buttonShareLocation.backgroundColor = SHARE_LOCATION_BUTTON_SHARE_BG_COLOR;
    
    [_buttonCancel setTitle:NSLocalizedLanguage(@"SHARE_LOCATION_BUTTON_CANCEL") forState:UIControlStateNormal];
    [_buttonCancel setTitleColor:SHARE_LOCATION_BUTTON_CANCEL_COLOR forState:UIControlStateNormal];
    _buttonCancel.titleLabel.font = SHARE_LOCATION_BUTTON_CANCEL_FONT;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    
    UIView* view = sender.view;
    CGPoint loc = [sender locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    if ([subview isEqual:_blurView]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
     
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

- (IBAction)tappedButtonShare:(id)sender {
    [[DataManager sharedManager] featureNotAvailable];
}

- (IBAction)tappedButtonCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end

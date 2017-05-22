//
//  UserLocationPinViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/29/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "UserLocationPinViewController.h"

#define MYLOCATION_COLOR            RGB(59, 59, 59)
#define MYLOCATION_FONT             fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)

#define CREATEPIN_COLOR             RGB(7, 34, 73)
#define CREATEPIN_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)

#define LINE_COLOR                  RGB(193, 193, 193)

@interface UserLocationPinViewController ()<UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonCreatePin;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation UserLocationPinViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.delegate = self;
    }
    return self;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelLocation.text = NSLocalizedLanguage(@"ULP_MYLOCATION");
    self.labelLocation.textColor = MYLOCATION_COLOR;
    self.labelLocation.font = MYLOCATION_FONT;
    
    [self.buttonCreatePin setTitle:NSLocalizedLanguage(@"ULP_CREATE") forState:UIControlStateNormal];
    [self.buttonCreatePin setTitleColor:CREATEPIN_COLOR forState:UIControlStateNormal];
    [self.buttonCreatePin setImage:[UIImage imageNamed:@"icon_createPin"] forState:UIControlStateNormal];
    self.buttonCreatePin.titleLabel.font = CREATEPIN_FONT;
    
    self.lineView.backgroundColor = LINE_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGSize)preferredContentSize {
    return CGSizeMake(kDeviceWidth * 0.44, kDeviceHeight * 0.12);
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    CGPoint point = [sender locationInView:view];
    UIView* subview = [view hitTest:point withEvent:nil];
    
    if ([subview isEqual:self.view]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)tappedCreatePinButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.createProjectPinDelegate createProjectUsingLocation:self.location];
    }];
}

@end

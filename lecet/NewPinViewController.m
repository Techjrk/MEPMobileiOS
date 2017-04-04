//
//  NewPinViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/4/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "NewPinViewController.h"

#define CREATEPIN_COLOR             RGB(7, 34, 73)
#define CREATEPIN_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)

@interface NewPinViewController ()<UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonCreatePin;

@end

@implementation NewPinViewController

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
    
    [self.buttonCreatePin setTitle:NSLocalizedLanguage(@"ULP_CREATE") forState:UIControlStateNormal];
    [self.buttonCreatePin setTitleColor:CREATEPIN_COLOR forState:UIControlStateNormal];
    [self.buttonCreatePin setImage:[UIImage imageNamed:@"icon_createPin"] forState:UIControlStateNormal];
    self.buttonCreatePin.titleLabel.font = CREATEPIN_FONT;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGSize)preferredContentSize {
    return CGSizeMake(kDeviceWidth * 0.44, kDeviceHeight * 0.06);
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

- (IBAction)tappedButtonCreatePin:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.createProjectPinDelegate createProjectUsingLocation:self.location];
    }];
}

@end

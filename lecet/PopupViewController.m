//
//  PopupViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "PopupViewController.h"

#import "TriangleView.h"
@interface PopupViewController ()
@property (weak, nonatomic) IBOutlet TriangleView *popupPlacementTop;
@property (weak, nonatomic) IBOutlet UIView *popupContainer;
@property (weak, nonatomic) IBOutlet CustomCollectionView *container;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPlacementTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPlacementTopLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopupWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopupHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopupLeading;
@end

@implementation PopupViewController
@synthesize popupPlacementColor;
@synthesize popupPalcement;
@synthesize popupWidth;
@synthesize popupRect;
@synthesize isGreyedBackground;
@synthesize customCollectionViewDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self enableTapGesture:YES];
    
    if (self.popupPlacementColor == nil) {
        self.popupPlacementColor = [UIColor whiteColor];
    }
    
    [_popupPlacementTop setObjectColor:self.popupPlacementColor];
    _constraintPlacementTopLeading.constant = (self.popupRect.origin.x + (self.popupRect.size.width * 0.5)) - (_popupPlacementTop.frame.size.width * 0.5);
    _constraintPlacementTop.constant = self.popupRect.origin.y + (self.popupRect.size.height);
    _constraintPopupWidth.constant = kDeviceWidth * self.popupWidth;
    _constraintPopupLeading.constant = (kDeviceWidth - _constraintPopupWidth.constant) /2.0;
    
    _popupContainer.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor ;
    _popupContainer.layer.shadowOffset = CGSizeMake(2, 2);
    _popupContainer.layer.shadowOpacity = 1.0;
    _popupContainer.layer.shadowRadius = kDeviceWidth * 0.01;
    _popupContainer.backgroundColor = [UIColor clearColor];
    
    _container.layer.cornerRadius = kDeviceWidth * 0.01;
    _container.layer.masksToBounds = YES;
    
    if (self.isGreyedBackground) {
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
    }
    
    _container.customCollectionViewDelegate = self.customCollectionViewDelegate;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)getViewPositionFromViewController:(UIView*)view controller:(UIViewController*)controller {

    return [controller.view convertRect:view.frame toView:controller.view];

}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    
    UIView* view = sender.view;
    CGPoint loc = [sender locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    if ([subview isEqual:self.view]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}


@end

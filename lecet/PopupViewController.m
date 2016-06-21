//
//  PopupViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/15/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "PopupViewController.h"

#import "TriangleView.h"
@interface PopupViewController ()<CustomCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet TriangleView *popupPlacementTop;
@property (weak, nonatomic) IBOutlet UIView *popupContainer;
@property (weak, nonatomic) IBOutlet TriangleView *popupPlacementBottom;
@property (weak, nonatomic) IBOutlet CustomCollectionView *container;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPlacementTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPlacementTopLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopupWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopupHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopupLeading;
@property (strong, nonatomic) IBOutlet UIView *constraintPlacementBottom;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCollectionViewCellSizeChange:) name:NOTIFICATION_CELL_SIZE_CHANGE object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(NotificationDismiss:) name:NOTIFICATION_DISMISS_POPUP object:nil];
    
    [_popupPlacementTop setObjectColor:self.popupPlacementColor];
    [_popupPlacementBottom setObjectColor:self.popupPlacementColor];
    _popupPlacementTop.hidden = self.popupPalcement != PopupPlacementTop;
    _popupPlacementBottom.hidden = !_popupPlacementTop.hidden;
    
    _constraintPlacementTopLeading.constant = (self.popupRect.origin.x + (self.popupRect.size.width * 0.5)) - (_popupPlacementTop.frame.size.width * 0.5);
    
    if (self.popupPalcement == PopupPlacementTop) {
        
        _constraintPlacementTop.constant = self.popupRect.origin.y + (self.popupRect.size.height);
    
    } else {
        
        _constraintPlacementTop.constant = kDeviceHeight - (self.popupRect.size.height);
        
    }
    _constraintPopupWidth.constant = kDeviceWidth * self.popupWidth;
    _constraintPopupLeading.constant = (kDeviceWidth - _constraintPopupWidth.constant) /2.0;
    
    _popupContainer.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor ;
    _popupContainer.layer.shadowOffset = CGSizeMake(2, 2);
    _popupContainer.layer.shadowOpacity = 1.0;
    _popupContainer.layer.shadowRadius = kDeviceWidth * 0.01;
    _popupContainer.backgroundColor = [UIColor clearColor];
    
    _container.layer.cornerRadius = kDeviceWidth * 0.012;
    _container.layer.masksToBounds = YES;
    
    if (self.isGreyedBackground) {
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    
    _container.customCollectionViewDelegate = self;
    [_container setConstraintHeight:_constraintPopupHeight];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)getViewPositionFromViewController:(UIView*)view controller:(UIViewController*)controller {

    return [view convertRect:view.bounds toView:controller.view];

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

- (void)notificationCollectionViewCellSizeChange:(NSNotificationCenter*)notification {
    [_container reload];
    [_container layoutSubviews];
    [UIView animateWithDuration:0.2 animations:^{
        _constraintPopupHeight.constant =[_container contentSize].height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - CustomCollectionView Delegate

- (void)collectionViewItemClassRegister:(id)customCollectionView {
    [self.customCollectionViewDelegate collectionViewItemClassRegister:customCollectionView];
}

- (UICollectionViewCell*)collectionViewItemClassDeque:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView {
    return [self.customCollectionViewDelegate collectionViewItemClassDeque:indexPath collectionView:collectionView];
}

- (NSInteger)collectionViewItemCount {
    return [self.customCollectionViewDelegate collectionViewItemCount];
}

- (NSInteger)collectionViewSectionCount {
    return [self.customCollectionViewDelegate collectionViewSectionCount];
}

- (CGSize)collectionViewItemSize:(UIView*)view indexPath:(NSIndexPath*)indexPath cargo:(id)cargo {
    return [self.customCollectionViewDelegate collectionViewItemSize:view indexPath:indexPath cargo:cargo];
}

- (void)collectionViewDidSelectedItem:(NSIndexPath*)indexPath {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.customCollectionViewDelegate collectionViewDidSelectedItem:indexPath];
    }];
}

- (void)collectionViewPrepareItemForUse:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath{
    [self.customCollectionViewDelegate collectionViewPrepareItemForUse:cell indexPath:indexPath];
}

- (void)NotificationDismiss:(NSNotification*)notification {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end

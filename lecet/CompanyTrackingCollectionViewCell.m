//
//  CompanyTrackingCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyTrackingCollectionViewCell.h"
#import "CompanyTrackingView.h"

@interface CompanyTrackingCollectionViewCell ()<CompanyTrackingViewDelegate, ActionViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet CompanyTrackingView *companyTrackingView;
@property (strong, nonatomic)id<ActionViewDelegate> cellDelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintExpand;

@end

@implementation CompanyTrackingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.companyTrackingView.layer setCornerRadius:4.0f];
    self.companyTrackingView.layer.masksToBounds = YES;
 
    _companyTrackingView.companyTrackingViewDelegate = self;
}


- (void)setAddressTop:(NSString *)text {
    [_companyTrackingView setAddress:text];
}

- (void)setAddressBelow:(NSString *)text {
    [_companyTrackingView setAddressTwo:text];
}
- (void)setTitleName:(NSString *)text {
    [_companyTrackingView setName:text];
    self.actionView.constraintHorizontal = self.contraintExpand;
    self.actionView.viewContainer = self.companyTrackingView;
    
}

- (void)setButtonLabelTitle:(NSString *)text {
    [_companyTrackingView setButtonLabelTitle:text];
}

- (void)setButtontag:(int)tag {
    [_companyTrackingView setButtonTag:tag];
}


- (void)tappedButtonAtTag:(int)tag {
    [_companyTrackingCollectionViewCellDelegate tappedButtonAtTag:tag];
}

- (void)changeCaretToUp:(BOOL)up {
    [_companyTrackingView changeCaretToUp:up];
}

- (void)setImage:(id)imageName {
    [_companyTrackingView setImage:imageName];
}

- (void)setUpdateDescription:(NSString *)text {
    //[_companyTrackingView setLabelDescription:text];
}

- (void)searchLocationGeoCode {
    [_companyTrackingView searchForLocationGeocode];
}

- (void)setUpdateInfo:(id)info {
    [_companyTrackingView setUpdateInfo:info];
}

#pragma mark - Delegate

- (void)setActionViewDelegate:(id<ActionViewDelegate>)actionViewDelegate {
    self.actionView.actionViewDelegate = self;
    self.cellDelegate = actionViewDelegate;
}

#pragma mark - ActionViewDelegate

- (void)didSelectItem:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didSelectItem:self];
    }
}

- (void)didTrackItem:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didTrackItem:self];
    }
}

- (void)didShareItem:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didShareItem:self];
    }
}

- (void)didHideItem:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didHideItem:self];
    }
}

- (void)didExpand:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate didExpand:self];
    }
}

- (void)undoHide:(id)sender {
    if(self.cellDelegate) {
        [self.cellDelegate undoHide:self];
    }
}

@end

//
//  CompanyTrackingCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyTrackingCollectionViewCell.h"
#import "CompanyTrackingView.h"

@interface CompanyTrackingCollectionViewCell ()<CompanyTrackingViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet CompanyTrackingView *companyTrackingView;

@end

@implementation CompanyTrackingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.layer setCornerRadius:4.0f];
    self.layer.masksToBounds = YES;
 
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
@end

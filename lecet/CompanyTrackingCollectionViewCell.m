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

- (void)setTextViewHidden:(BOOL)hide {
    [_companyTrackingView setTextViewHidden:hide];
}

@end

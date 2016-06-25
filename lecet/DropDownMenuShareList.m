//
//  DropDownMenuShareList.m
//  lecet
//
//  Created by Get Devs on 22/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DropDownMenuShareList.h"
#import "ShareItemCollectionViewCell.h"

@interface DropDownMenuShareList ()
@property (weak, nonatomic) IBOutlet UIButton *buttonSendByEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonCopyLink;

@end

@implementation DropDownMenuShareList

- (void)awakeFromNib {
    
    _buttonSendByEmail.tag = DropDownSendByEmail;
    _buttonCopyLink.tag = DropDownCopyLink;
    _buttonSendByEmail.titleLabel.font = DROPDOWN_SHARELIST_BUTTON_SENDBYEMAIL_FONT;
    _buttonCopyLink.titleLabel.font = DROPDOWN_SHARELIST_BUTTON_COPYLINK_FONT;
    [_buttonSendByEmail setTitle:NSLocalizedLanguage(@"DROPDOWNSHARELIST_SENDBYEMAIL_BUTTON_TEXT") forState:UIControlStateNormal];
    [_buttonCopyLink setTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_COPYLINK_BUTTON_TEXT") forState:UIControlStateNormal];
    
    [self drawTopTriangle];
    [self drawShadow];

}

- (void)drawTopTriangle{

    //Screen Size for Y axiz
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    int height = 0;
    
    float width = (screenWidth / 2) +12;
    int triangleTopDirection = -1;
    int triangleSize =  9;
    
    UIColor *bgColor = [UIColor whiteColor];
    CAShapeLayer *triangleTop = [[Utilities sharedIntances] drawDropDownTopTriangle:width backgroundColor:bgColor triangleTopDirection:triangleTopDirection heightPlacement:height sizeOfTriangle:triangleSize];
    
    [self.layer insertSublayer:triangleTop atIndex:1];
    
}

- (void)drawShadow {
    CGRect screenRect = self.bounds;
    CGRect customDimRect = screenRect;

    customDimRect.size.height = 0;
    customDimRect.size.width = 0;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:customDimRect];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
    [self.layer setCornerRadius:5.0f];

}

- (IBAction)tappedDropDonwShareList:(id)sender {
    UIButton *button = sender;
    [_dropDownShareListDelegate tappedDropDownShareList:(DropDownShareListItem)button.tag];
    
}

@end

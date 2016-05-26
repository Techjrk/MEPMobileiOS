//
//  DropDownMenuShareList.m
//  lecet
//
//  Created by Get Devs on 22/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DropDownMenuShareList.h"
#import "dropDownShareListConstant.h"


@interface DropDownMenuShareList ()
@property (weak, nonatomic) IBOutlet UIButton *buttonSendByEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonCopyLink;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEmailButtonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEmailAndLinkLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEmailLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEmailImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLinkImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCopyButtonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEmailImageBottom;


@end

@implementation DropDownMenuShareList



- (void)awakeFromNib{
    
    _buttonSendByEmail.tag = DropDownSendByEmail;
    _buttonCopyLink.tag = DropDownCopyLink;
    
    _buttonSendByEmail.titleLabel.font = DROPDOWN_SHARELIST_BUTTON_SENDBYEMAIL_FONT;
    _buttonCopyLink.titleLabel.font = DROPDOWN_SHARELIST_BUTTON_COPYLINK_FONT;
    
    [_buttonSendByEmail setTitle:NSLocalizedLanguage(@"DROPDOWNSHARELIST_SENDBYEMAIL_BUTTON_TEXT") forState:UIControlStateNormal];
 
    
    [_buttonCopyLink setTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_COPYLINK_BUTTON_TEXT") forState:UIControlStateNormal];
    
    
    
    [self drawTopTriangle];
    
    [self drawShadow];
    
    
    
    [self adjustConstraintForIncompatibleDevies];
}

- (void)drawTopTriangle{
    
    
    //Screen Size for Y axiz
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    int height = 0;
    
    //float widthNeedToAdd = screenWidth * 0.021f;
    float width = (screenWidth / 2) +12;
    int triangleTopDirection = -1;
    
    int triangleSize =  9;
    
    
    UIColor *bgColor = [UIColor whiteColor];
    CAShapeLayer *triangleTop = [[Utilities sharedIntances] drawDropDownTopTriangle:width backgroundColor:bgColor triangleTopDirection:triangleTopDirection heightPlacement:height sizeOfTriangle:triangleSize];
    
    [self.layer insertSublayer:triangleTop atIndex:1];
    
}

- (void)drawShadow{
    
    CGRect screenRect = self.bounds;
    
    CGRect customDimRect = screenRect;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:customDimRect];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
    
  
    
    [self.layer setCornerRadius:5.0f];

}




-(IBAction)tappedDropDonwShareList:(id)sender{
    
    UIButton *button = sender;
    [_dropDownShareListDelegate tappedDropDownShareList:(DropDownShareListItem)button.tag];
    
}





- (void)adjustConstraintForIncompatibleDevies{
    
    if (isiPhone5 || isiPhone4) {
        _constraintEmailButtonTop.constant = 5;
        _constraintEmailImageTop.constant = 12;
        _constraintLinkImageTop.constant = 5;
        _constraintCopyButtonTop.constant = 0;
        _constraintEmailImageBottom.constant = 6;
        
    }
    
        
    
}

@end

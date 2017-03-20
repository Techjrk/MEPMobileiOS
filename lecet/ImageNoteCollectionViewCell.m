//
//  ImageNoteCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/13/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ImageNoteCollectionViewCell.h"

#define CONSTRAINT_IMAGE_HEIGHT                 kDeviceHeight * 0.35
#define CONSTRAINT_IMAGE_BOTTOM_SPACER          kDeviceHeight * 0.005
#define CONSTRAINT_TITLE_HEIGHT                 kDeviceHeight * 0.05
#define CONSTRAINT_BOTTOM_TITLE_SPACER          kDeviceHeight * 0.003
#define CONSTRAINT_BOTTOM_NOTE_SPACER           kDeviceHeight * 0.005
#define CONSTRAINT_USER                         kDeviceHeight * 0.05

#define ITEM_SIZE                               CONSTRAINT_IMAGE_BOTTOM_SPACER + CONSTRAINT_TITLE_HEIGHT + CONSTRAINT_BOTTOM_TITLE_SPACER + CONSTRAINT_BOTTOM_NOTE_SPACER + CONSTRAINT_USER

#define SHADOW_COLOR                            RGB(0, 0, 0)

#define TITLE_COLOR                             RGB(34, 34, 34)
#define TITLE_LINE_COLOR                        RGB(8, 73, 124)
#define TITLE_FONT                              fontNameWithSize(FONT_NAME_LATO_BOLD, 12)

#define USER_COLOR                              RGB(76, 145, 209)
#define USER_FONT                               fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)

#define STAMP_COLOR                             RGB(190, 190, 190)
#define STAMP_FONT                              fontNameWithSize(FONT_NAME_LATO_REGULAR, 9)

@interface ImageNoteCollectionViewCell()

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageBottomSpacer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomTitleSpacer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintUserHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomNoteSpacer;

//IBOutlets
@property (weak, nonatomic) IBOutlet UIView *titleLine;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@end

@implementation ImageNoteCollectionViewCell
@synthesize imageId;
@synthesize userId;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.constraintImageHeight.constant = 0;
    self.constraintImageBottomSpacer.constant = CONSTRAINT_IMAGE_BOTTOM_SPACER;
    self.constraintTitleHeight.constant = CONSTRAINT_TITLE_HEIGHT;
    self.constraintBottomTitleSpacer.constant = CONSTRAINT_BOTTOM_TITLE_SPACER;
    self.constraintBottomNoteSpacer.constant = CONSTRAINT_BOTTOM_NOTE_SPACER;
    self.constraintUserHeight.constant = CONSTRAINT_USER;
   
    self.layer.shadowColor = [SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    
    self.titleView.font = TITLE_FONT;
    self.titleView.textColor = TITLE_COLOR;
    self.titleLine.backgroundColor = TITLE_LINE_COLOR;
    
    self.user.text = @"Erin Bernardin";
    self.user.textColor = USER_COLOR;
    self.user.font = USER_FONT;

    self.stamp.text = @"30 minutes ago  ";
    self.stamp.textColor = STAMP_COLOR;
    self.stamp.font = STAMP_FONT;

    self.activityIndicator.hidden = YES;
    self.imageId = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageId != nil) {
        self.constraintImageHeight.constant = CONSTRAINT_IMAGE_HEIGHT;
    } else {
        self.constraintImageHeight.constant = 0;
    }
    
    NSString *userIdentity =[[DataManager sharedManager] getKeyChainValue:kKeychainUserId serviceName:kKeychainServiceName];
   if ( userIdentity.integerValue == self.userId.integerValue) {
        
        if (self.imageId == nil) {
            [self.buttonDelete setImage:[UIImage imageNamed:@"icon_deleteNote"] forState:UIControlStateNormal];
            [self.buttonEdit setImage:[UIImage imageNamed:@"icon_editNote"] forState:UIControlStateNormal];
        } else {
            [self.buttonDelete setImage:[UIImage imageNamed:@"icon_deleteImage"] forState:UIControlStateNormal];
            [self.buttonEdit setImage:[UIImage imageNamed:@"icon_editImage"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Item Size
+ (CGFloat)itemSize{
    return ITEM_SIZE;
}

+ (CGFloat)itemSizeWithImage {
    return ITEM_SIZE + CONSTRAINT_IMAGE_HEIGHT;
}

- (void)loadImage:(UIImage *)image {
    self.image.image = image;
    self.image.hidden = NO;
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.constraintImageHeight.constant = CONSTRAINT_IMAGE_HEIGHT;
    [self layoutSubviews];
}
@end

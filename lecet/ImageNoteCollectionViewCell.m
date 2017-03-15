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
#define CONSTRAINT_TITLE_HEIGHT                 kDeviceHeight * 0.04
#define CONSTRAINT_BOTTOM_TITLE_SPACER          kDeviceHeight * 0.005
#define CONSTRAINT_BOTTOM_NOTE_SPACER           kDeviceHeight * 0.005
#define CONSTRAINT_USER                         kDeviceHeight * 0.05
#define SHADOW_COLOR                            RGB(0, 0, 0)

#define ITEM_SIZE                               CONSTRAINT_IMAGE_HEIGHT + CONSTRAINT_IMAGE_BOTTOM_SPACER + CONSTRAINT_TITLE_HEIGHT + CONSTRAINT_BOTTOM_TITLE_SPACER + CONSTRAINT_BOTTOM_NOTE_SPACER + CONSTRAINT_USER

@interface ImageNoteCollectionViewCell()

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageBottomSpacer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomTitleSpacer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNoteHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomNoteSpacer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonHeight;

//IBOutlets

@end

@implementation ImageNoteCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.constraintImageHeight.constant = CONSTRAINT_IMAGE_HEIGHT;
    self.constraintImageBottomSpacer.constant = CONSTRAINT_IMAGE_BOTTOM_SPACER;
    self.constraintTitleHeight.constant = CONSTRAINT_TITLE_HEIGHT;
    self.constraintBottomTitleSpacer.constant = CONSTRAINT_BOTTOM_TITLE_SPACER;
    self.constraintBottomNoteSpacer.constant = CONSTRAINT_BOTTOM_NOTE_SPACER;
    self.constraintButtonHeight.constant = kDeviceHeight * 0.05;
    self.constraintNoteHeight.constant = 200;
    
    self.layer.shadowColor = [SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;

}

+ (CGFloat)itemSize {
    return ITEM_SIZE + 200;
}

@end

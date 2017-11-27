//
//  ProjectBiddersCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectBiddersCollectionViewCell.h"

#import "CustomEntryField.h"

#define CUSTOM_ENTRYFIELD_BOTTOM_LINE_COLOR         RGB(149, 149, 149)
#define PROJECT_DETAIL_CONTAINER_BG_COLOR           RGB(245, 245, 245)

@interface ProjectBiddersCollectionViewCell()<ActionViewDelegate>
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintExpand;
@property (strong, nonatomic)id<ActionViewDelegate> cellDelegate;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation ProjectBiddersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lineView.backgroundColor = [CUSTOM_ENTRYFIELD_BOTTOM_LINE_COLOR colorWithAlphaComponent:0.5];
    
}

- (void)setItem:(NSString*)title line1:(NSString*)line1 line2:(NSString*)line2 {
    self.actionView.constraintHorizontal = self.contraintExpand;
    self.actionView.viewContainer = self.fieldItem;
    self.fieldItem.backgroundColor = PROJECT_DETAIL_CONTAINER_BG_COLOR;
    [_fieldItem setTitle:title line1Text:line1 line2Text:line2];
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

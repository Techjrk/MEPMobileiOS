//
//  EditTabView.m
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "EditTabView.h"

#define EDITTAB_BUTTON_FONT         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 14)
#define EDITTAB_BUTTON_FONT_COLOR   RGB(168,195,230)
#define EDITTAB_VIEW_BG_COLOR       RGB(5, 35, 74)

@interface EditTabView ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation EditTabView

- (void)awakeFromNib {
    
    _cancelButton.tag = EditTabItemCancel;
    _doneButton.tag = EditTabItemDone;
    
    _cancelButton.titleLabel.font = EDITTAB_BUTTON_FONT;
    [_cancelButton setTitleColor:EDITTAB_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    _doneButton.titleLabel.font = EDITTAB_BUTTON_FONT;
    [_doneButton setTitleColor:EDITTAB_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    [_cancelButton setTitle:NSLocalizedLanguage(@"EDIT_BUTTON_CANCEL") forState:UIControlStateNormal];
    [_doneButton setTitle:NSLocalizedLanguage(@"EDIT_BUTTON_DONE") forState:UIControlStateNormal];
    [self.view setBackgroundColor:EDITTAB_VIEW_BG_COLOR];
}

- (IBAction)tappedEditTabButton:(id)sender {
    UIButton *button = sender;
    [_editTabViewDelegate selectedEditTabButton:(EditTabItem)button.tag];
}

@end

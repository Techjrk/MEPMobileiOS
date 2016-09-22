//
//  SaveSearchChangeItemView.m
//  lecet
//
//  Created by Michael San Minay on 01/08/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SaveSearchChangeItemView.h"

#define LABEL_FONT              fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 14)
#define LABEL_FONT_COLOR        RGB(33,33,33)

#define BUTTON_FONT             fontNameWithSize(FONT_NAME_LATO_BOLD, 10)
#define BUTTON_FONT_COLOR       RGB(0,63,114)

#define VIEW_BG_COLOR           RGB(245,245,245)

@interface SaveSearchChangeItemView ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation SaveSearchChangeItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    _labelTitle.font        = LABEL_FONT;
    _labelTitle.textColor   = LABEL_FONT_COLOR;
    
    [_saveButton setTitleColor:BUTTON_FONT_COLOR forState:UIControlStateNormal];
    [_cancelButton setTitleColor:BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    _saveButton.titleLabel.font = BUTTON_FONT;
    _cancelButton.titleLabel.font = BUTTON_FONT;
    
    _labelTitle.text = NSLocalizedLanguage(@"SAVE_SEARCH_TITLE");
    [_saveButton setTitle:NSLocalizedLanguage(@"SAVE_SEARCH_SAVECHANGES") forState:UIControlStateNormal];
    [_cancelButton setTitle:NSLocalizedLanguage(@"SAVE_SEARCH_CANCEL") forState:UIControlStateNormal];
    
    _saveButton.tag = SaveSearchChangeItemSave;
    _cancelButton.tag = SaveSearchChangeItemCancel;
    
    [self.view setBackgroundColor:VIEW_BG_COLOR];
}

- (IBAction)tappedButton:(id)sender{
    UIButton *button = sender;
    [_saveSearchChangeItemViewDelegate tappedButtonSaveSearchesItem:(SaveSearchChangeItem)button.tag];
}

@end

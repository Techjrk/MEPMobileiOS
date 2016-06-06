//
//  NotesView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "NotesView.h"

#import "SectionTitleView.h"
#import "notesConstants.h"

@interface NotesView(){
    NSLayoutConstraint *constraintHeight;
}
@property (weak, nonatomic) IBOutlet UITextView *notesView;
@property (weak, nonatomic) IBOutlet SectionTitleView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@end

@implementation NotesView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_titleView setTitle:NSLocalizedLanguage(@"NOTES_VIEW_TITLE")];
    _constraintTitleHeight.constant = kDeviceHeight * 0.05;
    
    _notesView.textColor = NOTES_VIEW_TEXT_COLOR;
    _notesView.font = NOTES_VIEW_TEXT_FONT;
    self.backgroundColor = [UIColor clearColor];
    _notesView.backgroundColor = [UIColor clearColor];
}

- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint {
    constraintHeight = constraint;
}

- (void)layoutSubviews {
    [_notesView layoutIfNeeded];
    if (_notesView.text.length>0) {
        constraintHeight.constant = _notesView.contentSize.height + _titleView.frame.size.height;
    } else {
        constraintHeight.constant = 0;
    }
    
}

- (void)setNotes:(id)notes {
    _notesView.text = notes;
}

@end

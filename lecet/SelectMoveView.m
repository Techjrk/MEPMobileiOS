//
//  SelectMoveView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SelectMoveView.h"

#import "selectMoveViewConstants.h"

@interface SelectMoveView()
@property (weak, nonatomic) IBOutlet UILabel *labelMove;
@property (weak, nonatomic) IBOutlet UILabel *labelRemove;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
- (IBAction)tappedButton:(id)sender;
@end

@implementation SelectMoveView
@synthesize selectMoveViewDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];

    _labelRemove.font = SELECT_MOVE_BUTTON_FONT;
    _labelRemove.textColor = SELECT_MOVE_BUTTON_COLOR;
    _labelRemove.text = NSLocalizedLanguage(@"SELECT_REMOVE");
    
    _labelMove.font = SELECT_MOVE_BUTTON_FONT;
    _labelMove.textColor = SELECT_MOVE_BUTTON_COLOR;
    _labelMove.text = NSLocalizedLanguage(@"SELECT_MOVE");
    
    _labelCount.font = SELECT_MOVE_COUNT_FONT;
    _labelCount.textColor = SELECT_MOVE_COUNT_COLOR;
    _labelCount.text = @"3 Selected";
    
}

- (IBAction)tappedButton:(id)sender {
    UIButton *button = sender;
    [self.selectMoveViewDelegate tappedMoveItem:sender shouldMove:[NSNumber numberWithBool:button.tag == 1]];

}

@end

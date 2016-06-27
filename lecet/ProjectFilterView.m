//
//  ProjectFilterView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterView.h"

#import "FilterEntryView.h"
#import "FilterLabelView.h"

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define BUTTON_COLOR                        RGB(121, 120, 120)

#define BUTTON_OPTION_FONT                  fontNameWithSize(FONT_NAME_AWESOME, 16)
#define BUTTON_OPTION_DOWN                  [NSString stringWithFormat:@"%C", 0xf107]
#define BUTTON_OPTION_UP                    [NSString stringWithFormat:@"%C", 0xf106]

@interface ProjectFilterView(){
    BOOL isExpanded;
    NSLayoutConstraint *constraintObject;
}
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldLocation;
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldType;
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldValue;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldUpdated;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldJurisdiction;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldStage;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldBidding;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldBH;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldOwner;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldWork;
@property (weak, nonatomic) IBOutlet UIButton *buttonOptions;
@property (weak, nonatomic) IBOutlet UIView *viewOptions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewOptionsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelHeight;
- (IBAction)tappedButtonOptions:(id)sender;
@end

@implementation ProjectFilterView
@synthesize scrollView;

- (void)awakeFromNib {
    [super awakeFromNib];

    _constraintFieldHeight.constant = kDeviceHeight * 0.115;
    _constraintLabelHeight.constant = kDeviceHeight * 0.079;
     
    [_fieldLocation setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_LOCATION")];
    [_fieldType setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_TYPE")];
    [_fieldValue setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_VALUE")];
    [_fieldUpdated setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_UPDATED")];
    [_fieldJurisdiction setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_JURISDICTION")];
    [_fieldStage setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_STAGE")];
    [_fieldBidding setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_BIDDING")];
    [_fieldBH setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_BH")];
    [_fieldOwner setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_OWNER")];
    [_fieldWork setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_WORK")];
    
    [_fieldUpdated setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldJurisdiction setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldStage setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldBidding setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldBH setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldOwner setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldWork setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    
    
    [self setButtonTitle];
}

- (void)setButtonTitle {
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSLocalizedLanguage(!isExpanded?@"PROJECT_FILTER_MORE":@"PROJECT_FILTER_FEW") stringByAppendingString:@" "]   attributes:@{NSFontAttributeName:BUTTON_FONT, NSForegroundColorAttributeName:BUTTON_COLOR}];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:!isExpanded?BUTTON_OPTION_DOWN:BUTTON_OPTION_UP attributes:@{NSFontAttributeName:BUTTON_OPTION_FONT, NSForegroundColorAttributeName:BUTTON_COLOR}] ];
    
    
    [ _buttonOptions setAttributedTitle:title forState:UIControlStateNormal];
    
}

- (IBAction)tappedButtonOptions:(id)sender {
    isExpanded = !isExpanded;
    [self setButtonTitle];
    
    _constraintViewOptionsHeight.constant = isExpanded?_fieldUpdated.frame.size.height * 3.0:0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {

        if (finished) {
            [self layoutSubviews];
       }
    }];
    
}

- (void)setConstraint:(NSLayoutConstraint *)constraint {
    constraintObject = constraint;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    constraintObject.constant = _buttonOptions.frame.size.height + _buttonOptions.frame.origin.y + (kDeviceHeight * 0.02);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, constraintObject.constant);

}

@end

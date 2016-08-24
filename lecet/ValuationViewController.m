//
//  ValuationViewController.m
//  lecet
//
//  Created by Michael San Minay on 01/07/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ValuationViewController.h"
#import "ProfileNavView.h"

#define LABEL_FONT                                  fontNameWithSize(FONT_NAME_LATO_BOLD, 12.0)
#define LABEL_FONT_COLOR                            RGB(8, 73, 124)

#define LABEL_CENTER_FONT                           fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12.0)
#define LABEL_CENTER_FONT_COLOR                     RGB(34, 34, 34)

#define TEXTFIELD_FONT                              fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12.0)
#define TEXTFIELD_FONT_COLOR                        RGB(34, 34, 34)

@interface ValuationViewController ()<ProfileNavViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet ProfileNavView *navView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

@end

@implementation ValuationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
    _navView.profileNavViewDelegate = self;

    _leftLabel.font = LABEL_FONT;
    _leftLabel.textColor = LABEL_FONT_COLOR;
    
    _rightLabel.font = LABEL_FONT;
    _rightLabel.textColor = LABEL_FONT_COLOR;
    
    _centerLabel.font = LABEL_CENTER_FONT;
    _centerLabel.textColor = LABEL_CENTER_FONT_COLOR;
    
    _leftTextField.font = TEXTFIELD_FONT;
    _leftTextField.textColor = TEXTFIELD_FONT_COLOR;
    [_leftTextField setKeyboardType:UIKeyboardTypeNumberPad];
    _leftTextField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    _leftTextField.layer.borderWidth= 1.0f;
    _leftTextField.attributedPlaceholder = [self placeHolderForTextField];
    _leftTextField.leftView = [self paddingView];
    _leftTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _rightTextField.font = TEXTFIELD_FONT;
    _rightTextField.textColor = TEXTFIELD_FONT_COLOR;
    [_rightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    _rightTextField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    _rightTextField.layer.borderWidth= 1.0f;
    _rightTextField.attributedPlaceholder = [self placeHolderForTextField];
    _rightTextField.leftView = [self paddingView];
    _rightTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [_navView setRigthBorder:10];
    [_navView setNavRightButtonTitle:NSLocalizedLanguage(@"RIGHTNAV_BUTTON_TITLE")];
    [_navView setNavTitleLabel:NSLocalizedLanguage(@"VALUATION_NAV_TITLE")];
    
    [self enableTapGesture:YES];
    
    [_leftTextField becomeFirstResponder];
    
}

- (NSMutableAttributedString *)placeHolderForTextField {
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:TEXTFIELD_FONT, NSForegroundColorAttributeName:TEXTFIELD_FONT_COLOR}];
    
    [placeHolder appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"$"] attributes:@{NSFontAttributeName:TEXTFIELD_FONT, NSForegroundColorAttributeName:TEXTFIELD_FONT_COLOR}]];
    
    return placeHolder;
}

- (UIView *)paddingView {
    
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth * 0.017, kDeviceHeight * 0.025)];
    return paddingView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavViewDelegate

- (void)tappedProfileNav:(ProfileNavItem)profileNavItem {
    switch (profileNavItem) {
        case ProfileNavItemBackButton:{
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ProfileNavItemSaveButton:{
            
            
            NSNumber *min = [NSNumber numberWithInteger:_leftTextField.text.length==0?0:[_leftTextField.text integerValue]];
            NSNumber *max = [NSNumber numberWithInteger:_rightTextField.text.length==0?0:[_rightTextField.text integerValue]];
            
            NSDictionary * dict;
            if (max.integerValue>0) {
                dict = @{@"min":min,@"max":max};
            } else {
                dict = @{@"min":min};
                
            }
            [_valuationViewControllerDelegate tappedValuationApplyButton:dict];
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
    
}

@end

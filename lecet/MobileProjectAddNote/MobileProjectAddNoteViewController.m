//
//  MobileProjectAddNoteViewController.m
//  lecet
//
//  Created by Michael San Minay on 09/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "MobileProjectAddNoteViewController.h"

#pragma mark - FONT
#define FONT_NAV_TITLE_LABEL            fontNameWithSize(FONT_NAME_LATO_BOLD, 10)

#pragma mark - COLOR
#define COLOR_FONT_NAV_TITLE_LABEL      RGB(184,184,184)
#define COLOR_BG_NAV_VIEW               RGB(5, 35, 74)

@interface MobileProjectAddNoteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *postTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *postTitleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIView *navView;

@end

@implementation MobileProjectAddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.backgroundColor = COLOR_BG_NAV_VIEW;
    self.navTitleLabel.text = NSLocalizedLanguage(@"MPANV_NAV_TITLE");
    [self.cancelButton setTitle:NSLocalizedLanguage(@"MPANV_NAV_CANCEL") forState:UIControlStateNormal];
    [self.addButton setTitle:NSLocalizedLanguage(@"MPANV_NAV_ADD") forState:UIControlStateNormal];
    
    self.postTitleLabel.text = NSLocalizedLanguage(@"MPANV_POST_TITLE");
    self.postTitleTextField.placeholder = NSLocalizedLanguage(@"MPANV_POST_TITLE_PLACEHOLDER");
    NSString *countText = NSLocalizedLanguage(@"MPANV_POST_TITLE_COUNT");
    self.postTitleCountLabel.text = [NSString stringWithFormat:countText,self.postTitleTextField.text.length];
    
    self.bodyTitleLabel.text = NSLocalizedLanguage(@"MPANV_BODY_TITLE");
    self.footerLabel.text = NSLocalizedLanguage(@"MPANV_FOOTER_TILE");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

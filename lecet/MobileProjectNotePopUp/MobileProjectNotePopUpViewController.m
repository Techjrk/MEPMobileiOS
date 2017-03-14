//
//  MobileProjectNotePopUpViewController.m
//  lecet
//
//  Created by Michael San Minay on 11/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "MobileProjectNotePopUpViewController.h"


#define PROJECTDETAIL_CANCEL_BUTTON_FONT_COLOR              RGB(0, 63, 144)


#pragma mark - FONT
#define FONT_PN_POPUP_TITLE                                 fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 13)
#define FONT_POSTNOTE_BUTTON_TITLE                          fontNameWithSize(FONT_NAME_LATO_BOLD, 11)
#define FONT_POSTNOTE_CANCEL_BUTTON                         fontNameWithSize(FONT_NAME_LATO_BOLD, 10)


#pragma mark - COLOR
#define COLOR_FONT_POPUP_TITLE                              RGB(33, 33, 33)

#define COLOR_BG_POSTNOTE_BUTTON                            RGB(0, 63, 114)
#define COLOR_FONT_POSTNOTE_BUTTON_TITLE                    RGB(255, 255, 255)
#define COLOR_FONT_POSTNOTE_CANCEL_BUTTON                   RGB(0, 63, 144)


@interface MobileProjectNotePopUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *postNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *popupView;

@end

@implementation MobileProjectNotePopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = NSLocalizedLanguage(@"MPNPV_TITLE");
    self.titleLabel.font = FONT_PN_POPUP_TITLE;
    self.titleLabel.textColor = COLOR_FONT_POPUP_TITLE;
    
    [self.postNoteButton setTitle:NSLocalizedLanguage(@"MPNPV_POST_NOTE") forState:UIControlStateNormal];
    [self.postNoteButton setTitleColor:COLOR_FONT_POSTNOTE_BUTTON_TITLE forState:UIControlStateNormal];
    self.postNoteButton.titleLabel.font = FONT_POSTNOTE_BUTTON_TITLE;
    self.postNoteButton.backgroundColor = COLOR_BG_POSTNOTE_BUTTON;
    
    [self.cancelButton setTitle:NSLocalizedLanguage(@"MPNPV_CANCEL") forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_FONT_POSTNOTE_CANCEL_BUTTON forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = FONT_POSTNOTE_CANCEL_BUTTON;
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  NewProjectViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/21/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "NewProjectViewController.h"
#import "FilterLabelView.h"
#import <MapKit/MapKit.h>

//#define LABEL_FONT                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
//#define LABEL_COLOR                         RGB(34, 34, 34)

#pragma mark - Fonts
#define TITLE_FONT                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 13)
#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_REGULAR, 13)
#define LABEL_FONT                          fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define PLACEHOLDER_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)

#pragma mark - Colors
#define TITLE_COLOR                         [UIColor whiteColor]
#define BUTTON_COLOR                        RGB(168, 195, 230)
#define LABEL_COLOR                         RGB(8, 73, 124)
#define LINE_COLOR                          [[UIColor lightGrayColor] colorWithAlphaComponent:0.5]
#define HEADER_BGROUND                      RGBA(21, 78, 132, 95)
#define PLACEHOLDER_COLOR                   RGBA(34, 34, 34, 50)

@interface NewProjectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *spacerView;
@property (weak, nonatomic) IBOutlet UILabel *labelProjectTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldProjectTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldState;
@property (weak, nonatomic) IBOutlet UITextField *textFieldZip;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldCounty;
@end

@implementation NewProjectViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     "NPVC_TITLE"                                =               "New Project";
     "NPVC_CANCEL"                               =               "CANCEL";
     "NPVC_SAVE"                                 =               "SAVE";
     "NPVC_LABEL_TITLE"                          =               "TITLE";
     "NPVC_LABEL_ADDRESS"                        =               "ADDRESS";
     
     "NPVC_PROJECT_TITLE"                        =               "Project Title";
     "NPVC_STREET1"                              =               "Street 1";
     "NPVC_STREET2"                              =               "Street 2";
     "NPVC_CITY"                                 =               "City";
     "NPVC_STATE"                                =               "State";
     "NPVC_ZIP"                                  =               "Zip";

     */
    self.headerView.backgroundColor = HEADER_BGROUND;
    self.spacerView.backgroundColor = HEADER_BGROUND;
    
    self.labelTitle.text = NSLocalizedLanguage(@"NPVC_TITLE");
    self.labelTitle.textColor = TITLE_COLOR;
    self.labelTitle.font = TITLE_FONT;
    
    [self.buttonCancel setTitle:NSLocalizedLanguage(@"NPVC_CANCEL") forState:UIControlStateNormal];
    [self.buttonCancel setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    self.buttonCancel.titleLabel.font = BUTTON_FONT;
    
    [self.buttonSave setTitle:NSLocalizedLanguage(@"NPVC_SAVE") forState:UIControlStateNormal];
    [self.buttonSave setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    self.buttonSave.titleLabel.font = BUTTON_FONT;
    
    self.labelProjectTitle.text = NSLocalizedLanguage(@"NPVC_LABEL_TITLE");
    [self changeLabelStyle:self.labelProjectTitle];
  
    self.labelAddress.text = NSLocalizedLanguage(@"NPVC_LABEL_ADDRESS");
    [self changeLabelStyle:self.labelAddress];
    
    
    [self changeTextFieldStyle:self.textFieldProjectTitle placeHolder:NSLocalizedLanguage(@"NPVC_PROJECT_TITLE")];
    [self changeTextFieldStyle:self.textFieldAddress1 placeHolder:NSLocalizedLanguage(@"NPVC_STREET1")];
    [self changeTextFieldStyle:self.textFieldAddress2 placeHolder:NSLocalizedLanguage(@"NPVC_STREET2")];
    [self changeTextFieldStyle:self.textFieldCity placeHolder:NSLocalizedLanguage(@"NPVC_CITY")];
    [self changeTextFieldStyle:self.textFieldState placeHolder:NSLocalizedLanguage(@"NPVC_STATE")];
    [self changeTextFieldStyle:self.textFieldZip placeHolder:NSLocalizedLanguage(@"NPVC_ZIP")];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Custom Methods

- (void)changeLabelStyle:(UILabel*)label {
    label.font = LABEL_FONT;
    label.textColor = LABEL_COLOR;
}

- (void)changeTextFieldStyle:(UITextField*)textField placeHolder:(NSString*)placeHolder{
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = LINE_COLOR.CGColor;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:PLACEHOLDER_FONT, NSForegroundColorAttributeName:PLACEHOLDER_COLOR}];
    textField.attributedPlaceholder = attributedString;
}

#pragma mark - IBActions
- (IBAction)tappedCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedSave:(id)sender {
}

@end
